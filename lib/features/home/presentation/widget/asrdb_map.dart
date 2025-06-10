import 'dart:async';

import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/esri_condition_helper.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/markers/building_marker.dart';
import 'package:asrdb/core/widgets/markers/entrance_marker.dart';
import 'package:asrdb/core/widgets/markers/target_marker.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:asrdb/core/widgets/file_tile_provider.dart' as ft;
import 'package:latlong2/latlong.dart';

class AsrdbMap extends StatefulWidget {
  final MapController mapController;
  final String attributeLegend;
  const AsrdbMap(
      {super.key, required this.mapController, required this.attributeLegend});

  @override
  State<AsrdbMap> createState() => _AsrdbMapState();
}

class _AsrdbMapState extends State<AsrdbMap> {
  // MapController mapController = MapController();
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
  // bool _isDwellingVisible = false;
  // bool _isPropertyVisibile = false;

  String? highlightedBuildingIds;
  LatLng? _userLocation;

  final legendService = sl<LegendService>();

  Map<String, dynamic>? buildingsData;
  Map<String, dynamic>? entranceData;

  // bool _isDrawing = false;

  // String attributeLegend = 'quality';

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _goToCurrentLocation() async {
    try {
      final location = await LocationService.getCurrentLocation();
      widget.mapController.move(location, EsriConfig.initZoom);
      setState(() {
        _userLocation = location;
        _showLocationMarker = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
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

      context.read<EntranceCubit>().getEntranceDetails(_selectedGlobalId!);

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
    // Check if zoom has changed
    final zoomChanged = _previousZoom == null || _previousZoom != camera.zoom;
    _previousZoom = camera.zoom;

    // Trigger only if the user moved the map or zoomed in/out
    if (!hasGesture && !zoomChanged) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context
          .read<BuildingCubit>()
          .getBuildings(camera.visibleBounds, camera.zoom, municipalityId);
    });

    zoom = camera.zoom;
    visibleBounds = widget.mapController.camera.visibleBounds;
  }

  void _handleBuildingOnTap(String globalID) {
    try {
      context.read<BuildingCubit>().getBuildingDetails(globalID);

      List<dynamic> buildingEntrances = [];
      if (entranceData != null) {
        final entranceFeatures = entranceData?['features'] as List<dynamic>?;

        if (entranceFeatures != null) {
          buildingEntrances = entranceFeatures
              .whereType<Map<String, dynamic>>()
              .where((feature) {
                final props = feature['properties'] as Map<String, dynamic>?;
                return props != null &&
                    props['EntBldGlobalID']?.toString() == globalID;
              })
              .map((feature) => feature['properties']?['GlobalID'])
              .where((id) => id != null)
              .toList();
        }
      }

      setState(() {
        _selectedGlobalId = globalID;
        _selectedShapeType = ShapeType.polygon;
        highlightMarkersGlobalId = buildingEntrances;
      });
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
      mapController: widget.mapController,
      options: MapOptions(
        initialCenter: currentPosition,
        initialZoom: EsriConfig.initZoom,
        onMapReady: () => {
          _goToCurrentLocation(),
          context.read<BuildingCubit>().getBuildings(
              widget.mapController.camera.visibleBounds,
              EsriConfig.buildingMinZoom,
              userService.userInfo!.municipality),
          visibleBounds = widget.mapController.camera.visibleBounds,
        },
        onPositionChanged: (MapCamera camera, bool hasGesture) =>
            _onPositionChanged(
                camera, hasGesture, userService.userInfo!.municipality),
        onLongPress: (tapPosition, point) => (),
      ),
      children: [
        TileLayer(
          tileProvider: ft.FileTileProvider(tileDirPath, false),
        ),
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
            } else if (state is BuildingAddResponse) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.isAdded
                        ? 'Building addedd successfully'
                        : 'Building not added')),
              );
            } else if (state is Attributes) {
              final lat = (state as Attributes).initialData['BldLatitude'];
              final lng = (state as Attributes).initialData['BldLongitude'];

              if (lat != null && lng != null) {
                widget.mapController.move(LatLng(lat, lng), 19);
              }
            } else if (state is BuildingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
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
              // case EntranceAttributes(:final attributes):
              //   _entranceSchema = attributes;

              case EntranceError(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );

              case EntranceAddResponse(:final isAdded):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(isAdded
                          ? 'Entrance addedd successfully'
                          : 'Entrance not added')),
                );
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
        BlocConsumer<NewGeometryCubit, NewGeometryState>(
            listener: (context, state) {},
            builder: (context, state) {
              return (state as NewGeometry).isDrawing
                  ? const Center(child: TargetMarker())
                  : const SizedBox();
            }),
        BlocConsumer<NewGeometryCubit, NewGeometryState>(
          listener: (context, state) {},
          builder: (context, state) {
            return MarkerLayer(
              markers: _buildMarkers((state as NewGeometry).points),
            );
          },
        ),
        BlocConsumer<NewGeometryCubit, NewGeometryState>(
          listener: (context, state) {},
          builder: (context, state) {
            return (state as NewGeometry).points.isNotEmpty
                ? PolygonLayer(polygons: [
                    Polygon(
                      points: state.points,
                      color: Colors.red.withOpacity(0.25),
                      borderStrokeWidth: 3.0,
                      borderColor: Colors.red.shade700,
                      pattern: StrokePattern.dashed(
                        segments: const [10, 5],
                      ),
                    )
                  ])
                : const SizedBox();
          },
        ),
      ],
    );
  }
}
