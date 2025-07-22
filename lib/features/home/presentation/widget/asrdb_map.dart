import 'dart:async';

import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/esri_condition_helper.dart';
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
  // MapController mapController = MapController();
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

  Map<String, dynamic>? buildingsData;
  Map<String, dynamic>? entranceData;
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
    widget.mapController.move(location, EsriConfig.initZoom);
    setState(() {
      _userLocation = location;
      _showLocationMarker = true;
    });
  }

  void _handleEntranceTap(Map<String, dynamic> data) {
    try {
      _selectedGlobalId = data[EntranceFields.globalID];

      if (_selectedGlobalId == null) return;

      highlightMarkersGlobalId = [];

      final buildingGlobalId =
          context.read<AttributesCubit>().currentBuildingGlobalId;
      context.read<DwellingCubit>().closeDwellings();
      context.read<NewGeometryCubit>().setType(ShapeType.point);
      context
          .read<EntranceCubit>()
          .getEntranceDetails(_selectedGlobalId!, buildingGlobalId);
      context.read<OutputLogsCubit>().outputLogsBuildings(
          StringHelper.removeCurlyBracesFromString(
              data[EntranceFields.entBldGlobalID].toString()));
    } catch (e) {
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
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
        if (camera.zoom >= EsriConfig.buildingMinZoom) {
          context
              .read<BuildingCubit>()
              .getBuildings(camera.visibleBounds, camera.zoom, municipalityId);
        } else {
          setState(() {
            buildingsData = null;
            entranceData = null;
            _selectedBuildingGlobalId = null;
          });
          context.read<BuildingCubit>().clearBuildings();
          context.read<AttributesCubit>().clearSelections();
        }
      });

      zoom = camera.zoom;
      visibleBounds = widget.mapController.camera.visibleBounds;
      if (_selectedBuildingGlobalId != null && entranceData != null) {
        final features =
            entranceData?[GeneralFields.features] as List<dynamic>?;

        final entrancePoints = features
            ?.whereType<Map<String, dynamic>>()
            .where((f) =>
                f[GeneralFields.properties]?[EntranceFields.entBldGlobalID]
                    ?.toString() ==
                _selectedBuildingGlobalId)
            .map((f) {
          final coords = f[GeneralFields.geometry][GeneralFields.coordinates];
          return LatLng(coords[1], coords[0]);
        }).toList();

        if (entrancePoints != null && entrancePoints.isNotEmpty) {
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

    final globalId =
        PolygonHitDetector.getPolygonIdAtPoint(buildings, position);

    if (globalId != null) {
      final geometry =
          GeometryHelper.getPolygonGeometryById(buildings, globalId);

      final coordinates = GeometryHelper.getPolygonPoints(geometry!);

      context
          .read<AttributesCubit>()
          .setCurrentBuildingGlobalId(globalId.removeCurlyBraces());
      context.read<NewGeometryCubit>().setPoints(coordinates);
      context.read<NewGeometryCubit>().setType(ShapeType.polygon);
      context.read<NewGeometryCubit>().setDrawing(true);
    }
  }

  void _handleBuildingOnTap(LatLng position) {
    try {
      final buildingsState = context.read<BuildingCubit>().state;

      final buildings =
          buildingsState is Buildings ? buildingsState.buildings : null;

      if (buildings == null) return;

      final globalId =
          PolygonHitDetector.getPolygonIdAtPoint(buildings, position);

      if (globalId != null) {
        context
            .read<AttributesCubit>()
            .showBuildingAttributes(globalId.removeCurlyBraces());

        final storageResponsitory = sl<StorageRepository>();
        storageResponsitory.saveString(
            boxName: HiveBoxes.selectedBuilding,
            key: 'currentBuildingGlobalId',
            value: globalId);

        _selectedBuildingGlobalId = globalId;

        List<dynamic> buildingEntrances = [];
        List<LatLng> entrancePoints = [];

        if (entranceData != null) {
          final entranceFeatures =
              entranceData?[GeneralFields.features] as List<dynamic>?;

          if (entranceFeatures != null) {
            for (final feature
                in entranceFeatures.whereType<Map<String, dynamic>>()) {
              final props =
                  feature[GeneralFields.properties] as Map<String, dynamic>?;
              final geom =
                  feature[GeneralFields.geometry] as Map<String, dynamic>?;
              if (props != null &&
                  props[EntranceFields.entBldGlobalID]?.toString() ==
                      globalId &&
                  geom != null &&
                  geom[GeneralFields.type] == 'Point') {
                final coords = geom[GeneralFields.coordinates];
                entrancePoints.add(LatLng(coords[1], coords[0]));
                buildingEntrances.add(props[GeneralFields.globalID]);
              }
            }
          }
        }
        final bounds = widget.mapController.camera.visibleBounds;
        final anyOutside =
            GeometryHelper.anyPointOutsideBounds(entrancePoints, bounds);

        setState(() {
          _entranceOutsideVisibleArea = anyOutside;
        });

        if (widget.onEntranceVisibilityChange != null) {
          widget.onEntranceVisibilityChange!(_entranceOutsideVisibleArea);
        }

        final features = buildings[GeneralFields.features] as List<dynamic>?;
        final building = features?.firstWhere(
          (f) => f[GeneralFields.properties][GeneralFields.globalID].toString() == globalId,
          orElse: () => null,
        );

        if (building != null) {
          final geometry = building[GeneralFields.geometry];
          final polygonPoints = GeometryHelper.getPolygonPoints(geometry);

          if (polygonPoints.isNotEmpty) {
            final center = GeometryHelper.getPolygonCentroid(polygonPoints);

            widget.mapController.move(center, 20.5);
          }
        }
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
        initialZoom: EsriConfig.initZoom,
        onTap: (TapPosition position, LatLng latlng) =>
            _handleBuildingOnTap(latlng),
        onMapReady: () => {
          _goToCurrentLocation(),
          context.read<BuildingCubit>().getBuildings(
                widget.mapController.camera.visibleBounds,
                EsriConfig.buildingMinZoom,
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
        BlocConsumer<TileCubit, TileCubitState>(listener: (context, state) {
          if (state is Tile) {
            setState(() {
              tileDirPath = state.path;
            });
          }
        }, builder: (context, state) {
          return TileLayer(
            tileProvider: ft.FileTileProvider(tileDirPath, false),
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
              if (state.buildings.isNotEmpty) {
                buildingsData = state.buildings;
                context.read<EntranceCubit>().getEntrances(
                      zoom,
                      EsriConditionHelper.getPropertiesAsList(
                        GeneralFields.globalID,
                        state.buildings,
                      ),
                    );
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
