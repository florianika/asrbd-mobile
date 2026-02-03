import 'dart:async';
import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/cubit/location_accuracy_cubit.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
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
import 'package:asrdb/domain/entities/download_entity.dart';
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
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';

class AsrdbMap extends StatefulWidget {
  final MapController mapController;
  final String attributeLegend;
  final String? selectedBuildingGlobalId;
  final void Function(bool)? onEntranceVisibilityChange;
  const AsrdbMap({
    super.key,
    required this.mapController,
    required this.attributeLegend,
    this.selectedBuildingGlobalId,
    this.onEntranceVisibilityChange,
  });

  @override
  State<AsrdbMap> createState() => _AsrdbMapState();
}

class _AsrdbMapState extends State<AsrdbMap> {
  final GlobalKey mapKey = GlobalKey();

  LatLng currentPosition = const LatLng(40.534406, 19.6338131);
  double zoom = 0;
  String? _selectedGlobalId;

  bool _entranceOutsideVisibleArea = false;

  String? _previousBasemapUrl;

  Timer? _debounce;
  StorageService storageService = sl<StorageService>();

  /// Get the minimum zoom level for loading buildings based on the current basemap
  double _getBuildingMinZoom(String basemapUrl) {
    if (basemapUrl == AppConfig.basemapAsigSatellite2025Url) {
      return 9.0;
    }
    return AppConfig.buildingMinZoom;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onMapReady() async {
    final initialZoom = context.read<TileCubit>().initZoom;
    final location = await LocationService.getCurrentLocation();
    
    if (!mounted) return;
    
    widget.mapController.move(location, initialZoom);

    bool isOffline = context.read<TileCubit>().isOffline;
    DownloadEntity? download = context.read<TileCubit>().download;
    final tileState = context.read<TileCubit>().state;
    final userService = sl<UserService>();
    
    final buildingMinZoom = _getBuildingMinZoom(tileState.basemapUrl);
    final currentZoom = widget.mapController.camera.zoom;

    if (currentZoom >= buildingMinZoom) {
      context.read<BuildingCubit>().getBuildings(
          widget.mapController.camera.visibleBounds,
          currentZoom,
          isOffline
              ? (download?.municipalityId ?? 0)
              : userService.userInfo!.municipality,
          isOffline,
          download?.id,
          minZoom: buildingMinZoom,
      );
    }
  }

  Future<void> _handleEntranceTap(EntranceEntity entrance) async {
    try {
      context.read<DwellingCubit>().closeDwellings();
      bool isOffline = context.read<TileCubit>().isOffline;
      DownloadEntity? download = context.read<TileCubit>().download;
      _selectedGlobalId = entrance.globalId;

      context.read<AttributesCubit>().clearSelections();
      context.read<AttributesCubit>().toggleAttributesVisibility(false);

      if (_selectedGlobalId == null) return;

      final storageResponsitory = sl<StorageRepository>();
      storageResponsitory.saveString(
          boxName: HiveBoxes.selectedBuilding,
          key: 'currentBuildingGlobalId',
          value: entrance.entBldGlobalID!);

      final buildingGlobalId =
          context.read<AttributesCubit>().currentBuildingGlobalId;

      await context.read<AttributesCubit>().showEntranceAttributes(
            entrance.globalId,
            buildingGlobalId,
            isOffline,
            download?.id,
          );

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
    final attributesContext = context.read<AttributesCubit>();

    if (attributesContext.currentBuildingGlobalId != null &&
        entrances.isNotEmpty) {
      final entrancePoints = entrances
          .where((e) =>
              e.entBldGlobalID?.toString() ==
              attributesContext.currentBuildingGlobalId)
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

  void _onPositionChanged(
    MapCamera camera,
    bool hasGesture,
    int municipalityId,
    bool isOffline,
    int? downloadId,
  ) {
    try {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      // KEY FIX: Use longer debounce for offline mode
      final debounceMs = isOffline ? 0 : 800; // Much longer delay for offline

      _debounce = Timer(Duration(milliseconds: debounceMs), () {
        final tileState = context.read<TileCubit>().state;
        final buildingMinZoom = _getBuildingMinZoom(tileState.basemapUrl);
        
        if (camera.zoom >= buildingMinZoom) {
          context.read<BuildingCubit>().getBuildings(
                camera.visibleBounds,
                camera.zoom,
                municipalityId,
                isOffline,
                downloadId,
                minZoom: buildingMinZoom,
              );
        } else {
          context.read<BuildingCubit>().clearBuildings();
          context.read<AttributesCubit>().clearSelections();
        }
      });

      zoom = camera.zoom;
      _checkEntranceVisibility(camera);
    } on Exception catch (e) {
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  void _onLongTapBuilding(LatLng position) {
    context.read<DwellingCubit>().closeDwellings();
    context.read<AttributesCubit>().toggleAttributesVisibility(false);
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

  void _handleMapTap(LatLng position, bool isOffline, int? downloadId) async {
    try {
      final geometryEditor = context.read<GeometryEditorCubit>();
      context.read<AttributesCubit>().setPersistentBuilding(null);
      context.read<AttributesCubit>().setPersistentEntrance(null);
      context.read<EntranceCubit>().clearEntrances();

      if (geometryEditor.isEditing) {
        // Disable tap-to-add vertices for buildings
        // Only allow drag-to-add vertices
        if (geometryEditor.selectedType == EntityType.entrance) {
          final attributeCubit = context.read<AttributesCubit>();
          final buildingGlobalId = attributeCubit.currentBuildingGlobalId;

          if (buildingGlobalId != null) {
            await geometryEditor.onMapTapWithValidation(
              position,
              buildingGlobalId,
              isOffline,
              downloadId,
            );

            final validationError =
                geometryEditor.entranceCubit.validationError;
            if (validationError != null && mounted) {
              NotifierService.showMessage(
                context,
                message: AppLocalizations.of(context)
                    .translate(validationError)
                    .replaceAll('{distance}',
                        AppConfig.maxEntranceDistanceFromBuilding.toString()),
                type: MessageType.warning,
              );
            }
          } else {
            geometryEditor.onMapTap(position);
          }
        }
      } else {
        _handleBuildingOnTap(position, isOffline, downloadId);
      }
    } catch (e) {
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  void _handleBuildingOnTap(LatLng position, bool isOffline, int? downloadId) {
    try {
      context.read<DwellingCubit>().closeDwellings();
      context.read<AttributesCubit>().clearSelections();
      context.read<AttributesCubit>().setPersistentEntrance(null);
      context.read<EntranceCubit>().clearEntrances();
      final buildingList = context.read<BuildingCubit>().buildings;

      final maxZoom = context.read<TileCubit>().maxZoom;
      final buildingFound =
          PolygonHitDetector.getBuildingByTapLocation(buildingList, position);

      if (buildingFound != null) {
        context.read<AttributesCubit>().showBuildingAttributes(
            buildingFound.globalId, isOffline, downloadId);

        context.read<EntranceCubit>().getEntranceByGlobalId(
            buildingFound.globalId!, isOffline, downloadId);

        final storageResponsitory = sl<StorageRepository>();
        storageResponsitory.saveString(
            boxName: HiveBoxes.selectedBuilding,
            key: 'currentBuildingGlobalId',
            value: buildingFound.globalId!);

        _checkEntranceVisibility(widget.mapController.camera);

        final center =
            GeometryHelper.getPolygonCentroid(buildingFound.coordinates.first);

        widget.mapController.move(
            center,
            (widget.mapController.camera.zoom +
                    widget.mapController.camera.zoom * 0.1)
                .clamp(0.0, maxZoom));

        if (mounted) {
          context
              .read<OutputLogsCubit>()
              .outputLogsBuildings(buildingFound.globalId.removeCurlyBraces()!);
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

  void _onLongTapEntrance(EntranceEntity entrance) {
    context.read<DwellingCubit>().closeDwellings();
    context.read<AttributesCubit>().toggleAttributesVisibility(false);
    final geometryCubit = context.read<GeometryEditorCubit>();
    geometryCubit.onEntranceLongPress(entrance);
  }

  @override
  Widget build(BuildContext context) {
    final userService = sl<UserService>();

    return BlocConsumer<TileCubit, TileState>(
        listener: (context, state) {
          // Clamp zoom level when switching to ASIG satellite (maxZoom = 9)
          final isSwitchingToAsig = state.basemapUrl == AppConfig.basemapAsigSatellite2025Url &&
              _previousBasemapUrl != AppConfig.basemapAsigSatellite2025Url;
          
          if (isSwitchingToAsig) {
            final currentZoom = widget.mapController.camera.zoom;
            if (currentZoom > state.maxZoom) {
              // Clamp zoom to maxZoom
              final clampedZoom = state.maxZoom;
              final currentCenter = widget.mapController.camera.center;
              widget.mapController.move(currentCenter, clampedZoom);
            }
          }
          
          _previousBasemapUrl = state.basemapUrl;
        },
        builder: (context, state) {
          return BlocListener<AttributesCubit, AttributesState>(
            listener: (context, attributesState) {},
            child: KeyedSubtree(
              key: ValueKey(state.basemapUrl),
              child: FlutterMap(
                key: mapKey,
                mapController: widget.mapController,
                options: MapOptions(
                crs: state.csr,
                maxZoom: state.maxZoom,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                minZoom: 0.0,
                // initialZoom: 7.0,
                onLongPress: (tapPosition, point) => _onLongTapBuilding(point),
                initialCenter: state.isOffline
                    ? (LatLng(
                        state.download!.centerLat!, state.download!.centerLng!))
                    : currentPosition,
                initialZoom: state.initialZoom,
                onTap: (TapPosition position, LatLng latlng) => _handleMapTap(
                  latlng,
                  state.isOffline,
                  state.download?.id,
                ),
                onMapReady: _onMapReady,
                onMapEvent: (event) {
                  if (event is MapEventMoveEnd) {
                    final camera = widget.mapController.camera;

                    _onPositionChanged(
                      camera,
                      false, // hasGesture = false, since user stopped
                      state.isOffline
                          ? (state.download?.municipalityId ?? 0)
                          : userService.userInfo!.municipality,
                      state.isOffline,
                      state.download?.id,
                    );
                  }
                },
              ),
                children: [
                  TileLayer(
                    urlTemplate: state.basemapUrl,
                    userAgentPackageName: AppConfig.userAgentPackageName,
                    tileSize: 256,
                    tileProvider: FMTCTileProvider(
                      stores: {
                        state.storeName: BrowseStoreStrategy.readUpdateCreate
                      },
                    ),
                  ),
                  MunicipalityMarker(
                    isOffline: state.isOffline,
                    municipalityId: state.download?.municipalityId,
                  ),
                  BlocBuilder<LocationAccuracyCubit, LocationAccuracyState>(
                    builder: (context, locationState) {
                      if (locationState is LocationAccuracyUpdated) {
                        return MarkerLayer(
                          markers: [
                            Marker(
                              point: locationState.position,
                              width: 56,
                              height: 56,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Soft glow
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: (locationState.isAccurate
                                                  ? Colors.green
                                                  : Colors.orange)
                                              .withOpacity(0.35),
                                          blurRadius: 16,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Accuracy circle
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (locationState.isAccurate
                                              ? Colors.green
                                              : Colors.orange)
                                          .withOpacity(0.18),
                                      border: Border.all(
                                        color: locationState.isAccurate
                                            ? Colors.green
                                            : Colors.orange,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  // Center pin
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: locationState.isAccurate
                                            ? Colors.green
                                            : Colors.orange,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.navigation,
                                      size: 12,
                                      color: locationState.isAccurate
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  BuildingsMarker(
                    attributeLegend: widget.attributeLegend,
                    mapController: widget.mapController,
                    isSatellite: state.isSatellite,
                  ),
                  BlocBuilder<AttributesCubit, AttributesState>(
                    builder: (context, state) {
                      return SelectedBuildingMarker(
                        selectedBuildingGlobalId: state is Attributes &&
                                ((state.shapeType == ShapeType.polygon &&
                                    state.showAttributes))
                            ? state.buildingGlobalId
                            : null,
                        highlightBuildingGlobalId: (state is Attributes &&
                                ((state.shapeType != ShapeType.polygon &&
                                        state.showAttributes) ||
                                    (state.shapeType == ShapeType.noShape &&
                                        state.viewDwelling) ||
                                    context
                                        .read<GeometryEditorCubit>()
                                        .isEditing))
                            ? state.buildingGlobalId
                            : null,
                      );
                    },
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
                  Center(
                    child: LocationTagMarker(isActive: true),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
