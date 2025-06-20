import 'dart:async';

import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/esri_condition_helper.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/markers/building_marker.dart';
import 'package:asrdb/core/widgets/markers/entrance_marker.dart';
import 'package:asrdb/core/widgets/markers/target_marker.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
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
  ShapeType _selectedShapeType = ShapeType.point;
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(path.toString())),
      );
    }
  }

  void _goToCurrentLocation() async {
    // try {
    final location = await LocationService.getCurrentLocation();
    widget.mapController.move(location, EsriConfig.initZoom);
    setState(() {
      _userLocation = location;
      _showLocationMarker = true;
    });
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error fetching location: $e')),
    //   );
    // }
  }

  List<Marker> _buildMarkers(List<LatLng> points) {
    return points.map((point) {
      return Marker(
        width: 30,
        height: 30,
        point: point,
        child: GestureDetector(
          onTap: () => _handleEntranceTap(_initialData),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _handleEntranceTap(Map<String, dynamic> data) {
    try {
      _selectedGlobalId = data[EntranceFields.globalID];

      if (_selectedGlobalId == null) return;

      highlightMarkersGlobalId = [];

      _selectedShapeType = ShapeType.point;

      context.read<DwellingCubit>().closeDwellings();
      context.read<NewGeometryCubit>().setType(ShapeType.point);
      context.read<EntranceCubit>().getEntranceDetails(_selectedGlobalId!);
      context.read<OutputLogsCubit>().outputLogsBuildings(
          data['EntBldGlobalID'].replaceAll('{', '').replaceAll('}', ''));

      final bldGlobalId = data['EntBldGlobalID'];

      setState(() {
        highlightedBuildingIds = bldGlobalId;
        _showLocationMarker = false;
        // _isDwellingVisible = false;
      });
    } catch (e) {
      // Display error message to the user in case of exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  double? _previousZoom;
  void _onPositionChanged(
      MapCamera camera, bool hasGesture, int municipalityId) {
    final zoomChanged = _previousZoom == null || _previousZoom != camera.zoom;
    _previousZoom = camera.zoom;

    if (!hasGesture && !zoomChanged) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context
          .read<BuildingCubit>()
          .getBuildings(camera.visibleBounds, camera.zoom, municipalityId);
    });

    zoom = camera.zoom;
    visibleBounds = widget.mapController.camera.visibleBounds;
    if (_selectedBuildingGlobalId != null && entranceData != null) {
      final features = entranceData?['features'] as List<dynamic>?;

      final entrancePoints = features
          ?.whereType<Map<String, dynamic>>()
          .where((f) =>
              f['properties']?['EntBldGlobalID']?.toString() ==
              _selectedBuildingGlobalId)
          .map((f) {
        final coords = f['geometry']['coordinates'];
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
  }

  void _handleBuildingOnTap(String globalID) {
    try {
      context.read<DwellingCubit>().closeDwellings();
      context.read<NewGeometryCubit>().setType(ShapeType.polygon);
      context.read<BuildingCubit>().getBuildingDetails(globalID);
      context.read<OutputLogsCubit>().outputLogsBuildings(
          globalID.replaceAll('{', '').replaceAll('}', ''));
      _selectedBuildingGlobalId = globalID;

      List<dynamic> buildingEntrances = [];
      List<LatLng> entrancePoints = [];

      if (entranceData != null) {
        final entranceFeatures = entranceData?['features'] as List<dynamic>?;

        if (entranceFeatures != null) {
          for (final feature
              in entranceFeatures.whereType<Map<String, dynamic>>()) {
            final props = feature['properties'] as Map<String, dynamic>?;
            final geom = feature['geometry'] as Map<String, dynamic>?;
            if (props != null &&
                props['EntBldGlobalID']?.toString() == globalID &&
                geom != null &&
                geom['type'] == 'Point') {
              final coords = geom['coordinates'];
              entrancePoints.add(LatLng(coords[1], coords[0]));
              buildingEntrances.add(props['GlobalID']);
            }
          }
        }
      }
      final bounds = widget.mapController.camera.visibleBounds;
      final anyOutside =
          GeometryHelper.anyPointOutsideBounds(entrancePoints, bounds);

      setState(() {
        _selectedGlobalId = globalID;
        _selectedShapeType = ShapeType.polygon;
        highlightMarkersGlobalId = buildingEntrances;
        _entranceOutsideVisibleArea = anyOutside;
      });
      if (widget.onEntranceVisibilityChange != null) {
        widget.onEntranceVisibilityChange!(_entranceOutsideVisibleArea);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = sl<UserService>();
    return FlutterMap(
      key: mapKey,
      mapController: widget.mapController,
      options: MapOptions(
        initialCenter: currentPosition,
        initialZoom: EsriConfig.initZoom,
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
        onLongPress: (tapPosition, point) => (),
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
        BlocConsumer<BuildingCubit, BuildingState>(
          listener: (context, state) {
            if (state is Buildings) {
              if (state.buildings.isNotEmpty) {
                buildingsData = state.buildings;
                context.read<EntranceCubit>().getEntrances(
                    zoom,
                    EsriConditionHelper.getPropertiesAsList(
                        'GlobalID', state.buildings));
              }
            } else if (state is Attributes) {
              final lat = (state as Attributes).initialData['BldLatitude'];
              final lng = (state as Attributes).initialData['BldLongitude'];

              if (lat != null && lng != null) {
                widget.mapController.move(LatLng(lat, lng), 19);
              }
            }
          },
          builder: (context, state) {
            return BuildingMarker(
              buildingsData: buildingsData,
              selectedGlobalID: _selectedGlobalId,
              onTap: _handleBuildingOnTap,
              selectedShapeType: _selectedShapeType,
              attributeLegend: widget.attributeLegend,
              highlightedBuildingIds: highlightedBuildingIds,
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
                  List<dynamic> features = entrance['features'];
                  if (features.isNotEmpty &&
                      features[0] is Map<String, dynamic>) {
                    Map<String, dynamic> firstFeature = features[0];
                    Map<String, dynamic> properties =
                        firstFeature['properties'];
                    _initialData = properties;
                    // _isPropertyVisibile = true;
                  }
                }
            }
          },
          builder: (context, state) {
            return EntranceMarker(
              entranceData: entranceData,
              onTap: _handleEntranceTap,
              attributeLegend: widget.attributeLegend,
              selectedGlobalId: _selectedGlobalId,
              selectedShapeType: _selectedShapeType,
              mapController: widget.mapController,
              highilghGlobalIds: highlightMarkersGlobalId,
            );
          },
        ),
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
