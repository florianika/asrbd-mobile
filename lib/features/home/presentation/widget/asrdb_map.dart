import 'dart:async';
import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/helpers/polygon_hit_detection.dart';
import 'package:asrdb/core/helpers/string_helper.dart';
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/markers/buildings_marker.dart';
import 'package:asrdb/core/widgets/markers/entrances_marker.dart';
import 'package:asrdb/core/widgets/markers/municipality_marker.dart';
import 'package:asrdb/core/widgets/markers/selected_building_marker.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:asrdb/features/home/presentation/widget/markers/edit_building_marker.dart';
import 'package:asrdb/features/home/presentation/widget/markers/edit_entrance_marker.dart';
import 'package:asrdb/features/home/presentation/widget/markers/location_tag_marker.dart';
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

  bool _showLocationMarker = false;
  bool _entranceOutsideVisibleArea = false;

  LatLng? _userLocation;
  String? _selectedBuildingGlobalId;
  String? _highlightBuildingGlobalId;

  Timer? _debounce;
  StorageService storageService = sl<StorageService>();

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

  Future<void> _handleEntranceTap(EntranceEntity entrance) async {
    try {
      context.read<DwellingCubit>().closeDwellings();
      _selectedGlobalId = entrance.globalId;
      context.read<AttributesCubit>().clearSelections();

      setState(() {
        _selectedBuildingGlobalId = null;
        _highlightBuildingGlobalId = entrance.entBldGlobalID;
      });

      if (_selectedGlobalId == null) return;

      final storageResponsitory = sl<StorageRepository>();
      storageResponsitory.saveString(
          boxName: HiveBoxes.selectedBuilding,
          key: 'currentBuildingGlobalId',
          value: entrance.entBldGlobalID!);

      final buildingGlobalId =
          context.read<AttributesCubit>().currentBuildingGlobalId;

      await context
          .read<AttributesCubit>()
          .showEntranceAttributes(entrance.globalId, buildingGlobalId);

      if (mounted) {
        await context
            .read<OutputLogsCubit>()
            .outputLogsBuildings(entrance.entBldGlobalID.removeCurlyBraces()!);
      }
    } catch (e) {
      if (mounted) {
        NotifierService.showMessage(
          context,
          message: e.toString(),
          type: MessageType.error,
        );
      }
    }
  }

  void _checkEntranceVisibility(MapCamera camera) {
    List<EntranceEntity> entrances = context.read<EntranceCubit>().entrances;

    if (_selectedBuildingGlobalId != null && entrances.isNotEmpty) {
      final entrancePoints = entrances
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
      _debounce = Timer(const Duration(milliseconds: 800), () {
        if (camera.zoom >= AppConfig.buildingMinZoom) {
          context
              .read<BuildingCubit>()
              .getBuildings(camera.visibleBounds, camera.zoom, municipalityId);
        } else {
          setState(() {
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
    context.read<DwellingCubit>().closeDwellings();
    final buildingsState = context.read<BuildingCubit>().state;

    final buildings =
        buildingsState is Buildings ? buildingsState.buildings : null;

    if (buildings == null) return;

    final buildingFound =
        PolygonHitDetector.getBuildingByTapLocation(buildings, position);

    if (buildingFound != null) {
      final geometryCubit = context.read<GeometryEditorCubit>();
      geometryCubit.onBuildingLongPress(buildingFound);
    }
  }

  void _handleBuildingOnTap(LatLng position) {
    try {
      context.read<DwellingCubit>().closeDwellings();
      context.read<AttributesCubit>().clearSelections();
      final buildingList = context.read<BuildingCubit>().buildings;
      final buildingFound =
          PolygonHitDetector.getBuildingByTapLocation(buildingList, position);

      if (buildingFound != null) {
        context
            .read<AttributesCubit>()
            .showBuildingAttributes(buildingFound.globalId);

        final storageResponsitory = sl<StorageRepository>();
        storageResponsitory.saveString(
            boxName: HiveBoxes.selectedBuilding,
            key: 'currentBuildingGlobalId',
            value: buildingFound.globalId!);

        setState(() {
          _selectedBuildingGlobalId = buildingFound.globalId;
          _highlightBuildingGlobalId = null;
        });

        _checkEntranceVisibility(widget.mapController.camera);

        final center =
            GeometryHelper.getPolygonCentroid(buildingFound.coordinates.first);

        widget.mapController.move(
            center,
            (widget.mapController.camera.zoom +
                    widget.mapController.camera.zoom * 0.1)
                .clamp(0.0, 20.5));
      }
    } catch (e) {
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  void _onLongTapEntrance(EntranceEntity entrance) {
    context.read<DwellingCubit>().closeDwellings();
    final geometryCubit = context.read<GeometryEditorCubit>();
    geometryCubit.onEntranceLongPress(entrance);
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
          // setState(() {
          //   currentPosition = state.mapCenter ?? currentPosition;
          // });
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
        Center(
          child: LocationTagMarker(isActive: true),
        ),
        BuildingsMarker(
          attributeLegend: widget.attributeLegend,
          mapController: widget.mapController,
        ),
        SelectedBuildingMarker(
          selectedBuildingGlobalId: _selectedBuildingGlobalId,
          highlightBuildingGlobalId: _highlightBuildingGlobalId,
        ),
        EntrancesMarker(
          onTap: _handleEntranceTap,
          onLongPress: _onLongTapEntrance,
          attributeLegend: widget.attributeLegend,
          mapController: widget.mapController,
        ),
        EditBuildingMarker(
          mapKey: mapKey,
          mapController: widget.mapController,
        ),
        EditEntranceMarker(
          mapKey: mapKey,
          mapController: widget.mapController,
        ),
      ],
    );
  }
}
