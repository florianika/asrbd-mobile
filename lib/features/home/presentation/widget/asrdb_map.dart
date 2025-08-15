import 'dart:async';
import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/helpers/polygon_hit_detection.dart';
import 'package:asrdb/core/helpers/string_helper.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/general_fields.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/markers/building_marker.dart';
import 'package:asrdb/core/widgets/markers/entrance_marker.dart';
import 'package:asrdb/core/widgets/markers/municipality_marker.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:asrdb/features/home/presentation/widget/edit_shape_elements.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:asrdb/core/widgets/file_tile_provider.dart' as ft;
import 'package:latlong2/latlong.dart';

class AsrdbMap extends StatefulWidget {
  final MapController mapController;
  final String attributeLegend;
  final void Function(bool)? onEntranceVisibilityChange;
  const AsrdbMap(
      {super.key,
      required this.mapController,
      required this.attributeLegend,
      this.onEntranceVisibilityChange});

  @override
  State<AsrdbMap> createState() => _AsrdbMapState();
}

class _AsrdbMapState extends State<AsrdbMap> {
  final GlobalKey mapKey = GlobalKey();

  LatLng currentPosition = const LatLng(40.534406, 19.6338131);
  LatLngBounds? visibleBounds;
  late String tileDirPath = '';
  double zoom = 0;
  String? _selectedGlobalId;

  Map<String, List<Legend>> buildingLegends = {};
  List<Legend> entranceLegends = [];

  Map<String, dynamic> _initialData = {};

  List<dynamic> highlightMarkersGlobalId = [];

  bool _showLocationMarker = false;
  bool _entranceOutsideVisibleArea = false;

  String? highlightedBuildingIds;
  LatLng? _userLocation;

  final legendService = sl<LegendService>();

  List<BuildingEntity> buildingsData = [];
  List<EntranceEntity> entranceData = [];
  String? _selectedBuildingGlobalId;

  Timer? _debounce;
  StorageService storageService = sl<StorageService>();
  LatLng? tappedLocation;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    applyTile();
    super.initState();
  }

  Future<void> applyTile() async {
    String? path = await storageService.getString(
        boxName: HiveBoxes.offlineMap, key: "map");
    if (path != null) {
      setState(() {
        tileDirPath = path;
      });
    }
  }

  void _goToCurrentLocation() async {
    final location = await LocationService.getCurrentLocation();
    widget.mapController.move(location, AppConfig.initZoom);
    setState(() {
      _userLocation = location;
      _showLocationMarker = true;
    });
  }

  void _handleEntranceTap(EntranceEntity entrance) {
    try {
      // EntranceEntity entrance = EntranceEntity.fromMap(data);

      _selectedGlobalId = entrance.globalId;

      if (_selectedGlobalId == null) return;

      highlightMarkersGlobalId = [];

      final storageResponsitory = sl<StorageRepository>();
      storageResponsitory.saveString(
          boxName: HiveBoxes.selectedBuilding,
          key: 'currentBuildingGlobalId',
          value: entrance.entBldGlobalID!);

      final buildingGlobalId =
          context.read<AttributesCubit>().currentBuildingGlobalId;
      // context.read<DwellingCubit>().closeDwellings();
      // context.read<NewGeometryCubit>().setType(ShapeType.point);
      // context
      //     .read<EntranceCubit>()
      //     .getEntranceDetails(_selectedGlobalId!, buildingGlobalId);

      context
          .read<AttributesCubit>()
          .showEntranceAttributes(entrance.globalId, buildingGlobalId);

      // context.read<OutputLogsCubit>().outputLogsBuildings(
      //     StringHelper.removeCurlyBracesFromString(
      //         entrance.entBldGlobalID.toString()));
    } catch (e) {
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  void _checkEntranceVisibility(MapCamera camera) {
    if (_selectedBuildingGlobalId != null && entranceData.isNotEmpty) {
      final entrancePoints = entranceData
          .where(
              (e) => e.entBldGlobalID?.toString() == _selectedBuildingGlobalId)
          .map((e) => e.coordinates)
          .whereType<LatLng>()
          .toList();

      if (entrancePoints.isNotEmpty && entrancePoints.isNotEmpty) {
        final isOutside = GeometryHelper.anyPointOutsideBounds(
          entrancePoints,
          camera.visibleBounds,
        );

        if (_entranceOutsideVisibleArea != isOutside) {
          setState(() {
            _entranceOutsideVisibleArea = isOutside;
          });

          widget.onEntranceVisibilityChange?.call(isOutside);
        }
      }
    }
  }

  double? _previousZoom;
  void _onPositionChanged(
      MapCamera camera, bool hasGesture, int municipalityId) {
    try {
      final zoomChanged = _previousZoom == null || _previousZoom != camera.zoom;
      _previousZoom = camera.zoom;

      if (!hasGesture && !zoomChanged) return;

      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (camera.zoom >= AppConfig.buildingMinZoom) {
          context
              .read<BuildingCubit>()
              .getBuildings(camera.visibleBounds, camera.zoom, municipalityId);
        } else {
          setState(() {
            buildingsData = [];
            entranceData = [];
            _selectedBuildingGlobalId = null;
          });
          context.read<BuildingCubit>().clearBuildings();
          context.read<AttributesCubit>().clearSelections();
        }
      });

      zoom = camera.zoom;
      _checkEntranceVisibility(camera);
      // visibleBounds = widget.mapController.camera.visibleBounds;
      // if (_selectedBuildingGlobalId != null && entranceData.isNotEmpty) {
      //   final entrancePoints = entranceData
      //       .where((e) =>
      //           e.entBldGlobalID?.toString() == _selectedBuildingGlobalId)
      //       .map((e) => e.coordinates)
      //       .whereType<LatLng>()
      //       .toList();

      //   if (entrancePoints.isNotEmpty && entrancePoints.isNotEmpty) {
      //     final isOutside = GeometryHelper.anyPointOutsideBounds(
      //       entrancePoints,
      //       camera.visibleBounds,
      //     );

      //     if (_entranceOutsideVisibleArea != isOutside) {
      //       setState(() {
      //         _entranceOutsideVisibleArea = isOutside;
      //       });

      //       widget.onEntranceVisibilityChange?.call(isOutside);
      //     }
      //   }
      // }
    } on Exception catch (e) {
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  void _hanldeOnLongPress(LatLng position) {
    final buildingsState = context.read<BuildingCubit>().state;

    final buildings =
        buildingsState is Buildings ? buildingsState.buildings : null;

    if (buildings == null) return;

    final buildingFound =
        PolygonHitDetector.getBuildingByTapLocation(buildings, position);

    if (buildingFound != null) {
      // final geometry =
      //     GeometryHelper.getPolygonGeometryById(buildings, globalId);

      // final coordinates = GeometryHelper.getPolygonPoints(geometry!);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('${buildingFound.globalId} - buildingFound.globalId'),
      //     duration: Duration(seconds: 10),
      //     backgroundColor: Colors.blue,
      //     action: SnackBarAction(
      //       label: 'UNDO',
      //       textColor: Colors.white,
      //       onPressed: () {
      //         // Handle action
      //       },
      //     ),
      //   ),
      // );

      context
          .read<AttributesCubit>()
          .showBuildingAttributes(buildingFound.globalId);

      context
          .read<NewGeometryCubit>()
          .setPoints(buildingFound.coordinates.first);
      context.read<NewGeometryCubit>().setType(ShapeType.polygon);
      context.read<NewGeometryCubit>().setDrawing(true);
    }
  }

  void _handleBuildingOnTap(LatLng position) {
    try {
      final buildingFound =
          PolygonHitDetector.getBuildingByTapLocation(buildingsData, position);

      if (buildingFound != null) {
        context
            .read<AttributesCubit>()
            .showBuildingAttributes(buildingFound.globalId);

        final storageResponsitory = sl<StorageRepository>();
        storageResponsitory.saveString(
            boxName: HiveBoxes.selectedBuilding,
            key: 'currentBuildingGlobalId',
            value: buildingFound.globalId!);

        _selectedBuildingGlobalId = buildingFound.globalId;

        _checkEntranceVisibility(widget.mapController.camera);

        final center =
            GeometryHelper.getPolygonCentroid(buildingFound.coordinates.first);
        widget.mapController.move(center, 20.5);
      }
    } catch (e) {
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  void _onLongTapEntrance(LatLng coordinates, String entranceGlobalId) {
    final buildingGlobalId =
        context.read<AttributesCubit>().currentBuildingGlobalId;
    context.read<AttributesCubit>().showEntranceAttributes(
        entranceGlobalId.removeCurlyBraces(), buildingGlobalId);

    context.read<NewGeometryCubit>().setPoints([coordinates]);
    context.read<NewGeometryCubit>().setType(ShapeType.point);
    context.read<NewGeometryCubit>().setDrawing(true);
    context.read<NewGeometryCubit>().setMovingPoint(true);
  }

  @override
  Widget build(BuildContext context) {
    final userService = sl<UserService>();
    return FlutterMap(
      key: mapKey,
      mapController: widget.mapController,
      options: MapOptions(
        onLongPress: (tapPosition, point) => _hanldeOnLongPress(point),
        initialCenter: currentPosition,
        initialZoom: AppConfig.initZoom,
        onTap: (TapPosition position, LatLng latlng) =>
            _handleBuildingOnTap(latlng),
        onMapReady: () => {
          _goToCurrentLocation(),
          context.read<BuildingCubit>().getBuildings(
                widget.mapController.camera.visibleBounds,
                AppConfig.buildingMinZoom,
                userService.userInfo!.municipality,
              ),
          visibleBounds = widget.mapController.camera.visibleBounds,
        },
        onPositionChanged: (MapCamera camera, bool hasGesture) =>
            _onPositionChanged(
          camera,
          hasGesture,
          userService.userInfo!.municipality,
        ),
      ),
      children: [
        BlocConsumer<TileCubit, TileState>(listener: (context, state) {
          setState(() {
            currentPosition = state.mapCenter ?? currentPosition;
          });
        }, builder: (context, state) {
          return TileLayer(
            key: ValueKey('${state.path}_${state.isOffline}'),
            tileProvider: ft.IndexedFileTileProvider(
              tileIndex: state.indexService,
              isOffline: state.isOffline,
            ),
          );
        }),
        const MunicipalityMarker(),
        if (_showLocationMarker)
          MarkerLayer(
            markers: [
              Marker(
                point: _userLocation!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blueAccent,
                  size: 30,
                ),
              ),
            ],
          ),
        BlocConsumer<BuildingCubit, BuildingState>(
          listener: (context, state) {
            if (state is BuildingError) {
              NotifierService.showMessage(
                context,
                message: state.message,
                type: MessageType.error,
              );
              return;
            } else if (state is Buildings) {
              setState(() {
                buildingsData = state.buildings;
              });
              if (state.buildings.isNotEmpty) {
                context.read<EntranceCubit>().getEntrances(
                    zoom,
                    state.buildings
                        .map((building) => building.globalId)
                        .whereType<String>()
                        .toList());
              }
            }
          },
          builder: (context, state) {
            return BuildingMarker(
              buildingsData: buildingsData,
              attributeLegend: widget.attributeLegend,
            );
          },
        ),
        BlocConsumer<EntranceCubit, EntranceState>(
          listener: (context, state) {
            switch (state) {
              case Entrances(:final entrances):
                entranceData = entrances;
              case Entrance(:final entrance):
                if (entrance.isNotEmpty) {
                  List<dynamic> features = entrance[GeneralFields.features];
                  if (features.isNotEmpty &&
                      features[0] is Map<String, dynamic>) {
                    Map<String, dynamic> firstFeature = features[0];
                    Map<String, dynamic> properties =
                        firstFeature[GeneralFields.properties];
                    _initialData = properties;
                  }
                }
            }
          },
          builder: (context, state) {
            return EntranceMarker(
              entranceData: entranceData,
              onTap: _handleEntranceTap,
              onLongPress: _onLongTapEntrance,
              attributeLegend: widget.attributeLegend,
              mapController: widget.mapController,
            );
          },
        ),
        EditShapeElements(
          mapKey: mapKey,
          mapController: widget.mapController,
          handleEntranceTap: _handleEntranceTap,
          initialData: _initialData,
        ),
      ],
    );
  }
}
