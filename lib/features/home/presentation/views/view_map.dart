import 'dart:async';

import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/constants/app_config.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/widgets/element_attribute/mobile_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/core/widgets/legend/map_legend.dart';
import 'package:asrdb/core/widgets/map_events/map_action_buttons.dart';
import 'package:asrdb/core/widgets/map_events/map_action_events.dart';
import 'package:asrdb/core/widgets/markers/building_marker.dart';
import 'package:asrdb/core/widgets/markers/entrance_marker.dart';
import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:asrdb/core/widgets/file_tile_provider.dart' as ft;

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  // bool _isInitialized = true;
  late String tileDirPath = '';
  bool _isDrawing = false;
  List<LatLng> _newPolygonPoints = [];
  final List<List<LatLng>> _undoStack = [];
  final List<List<LatLng>> _redoStack = [];
  Map<String, dynamic>? buildingsData;
  Map<String, dynamic>? entranceData;
  EntityType entityType = EntityType.entrance;
  List<FieldSchema> _buildingSchema = [];
  List<FieldSchema> _entranceSchema = [];
  List<dynamic> highilghGlobalIds = [];

  Timer? _debounce;

  final GlobalKey _appBarKey = GlobalKey();

  List<FieldSchema> _schema = [];
  Map<String, dynamic> _initialData = {};

  ShapeType _selectedShapeType = ShapeType.point;
  int _selectedObjectId = -1;

  MapController mapController = MapController();

  bool _isPropertyVisibile = false;

  Future<void> _initialize() async {
    context.read<BuildingCubit>().getBuildingAttibutes();
    context.read<EntranceCubit>().getEntranceAttributes();
  }

  final String _styleAttribute = 'CATEGORY';
  Map<String, Color> _getCurrentLegendItems() {
    switch (_styleAttribute) {
      case 'CATEGORY':
        return {
          'Të dhëna pa gabime': Colors.blue.withOpacity(0.7),
          'Mungesa në të dhënat': Colors.purple.withOpacity(0.7),
          'Të dhëna kontradiktore': Colors.brown.withOpacity(0.7),
          '<Per tu pare>': Colors.teal.withOpacity(0.7),
          '<Per tu pare>2':
              const Color.fromARGB(255, 60, 145, 214).withOpacity(0.7),
        };
      case 'CONDITION':
        return {
          'Good': Colors.green,
          'Fair': Colors.amber,
          'Poor': Colors.red,
          'Unknown': const Color.fromARGB(255, 13, 102, 175),
        };
      case 'HEIGHT':
        return {
          'Low (< 10m)': Colors.blue.withOpacity(0.7),
          'Medium (10-30m)': Colors.green.withOpacity(0.7),
          'High (30-100m)': Colors.orange.withOpacity(0.7),
          'Skyscraper (> 100m)': Colors.red.withOpacity(0.7),
        };
      default:
        return {
          'Default': const Color.fromARGB(255, 60, 145, 214).withOpacity(0.7),
        };
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void handleEntranceTap(Map<String, dynamic> data) {
    try {
      // Determine if the device is using a small screen (mobile)
      final bool isMobile =
          MediaQuery.of(context).size.width < AppConfig.tabletBreakpoint;

      // Update state accordingly
      setState(() {
        highilghGlobalIds = [];
        _initialData = data;
        _schema = _entranceSchema;
        _selectedShapeType = ShapeType.point;
        _selectedObjectId = data['OBJECTID'];
        _isPropertyVisibile = !isMobile;
      });

      // For mobile devices, show the mobile attribute UI
      if (isMobile) {
        mobileElementAttribute(context, _entranceSchema, data, _onSave);
      }
    } catch (e) {
      // Display error message to the user in case of exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _onAddShape(LatLng position) {
    if (_selectedShapeType == ShapeType.point &&
        _newPolygonPoints.length == 1) {
      return;
    }

    setState(() {
      _undoStack.add(List.from(_newPolygonPoints)); // Save current state
      _redoStack.clear(); // Clear redo on new action
      _newPolygonPoints.add(position);
    });
  }

  void enableDrawing(ShapeType type) {
    setState(() {
      if (type == ShapeType.polygon) {
        _schema = _buildingSchema;
      } else {
        _schema = _entranceSchema;
      }
      _isDrawing = true;
      _selectedShapeType = type;
      highilghGlobalIds = [];
    });
  }

  void _onClose() {
    setState(() {
      _isDrawing = false;
      _newPolygonPoints.clear();
    });
  }

  void _onUndo() {
    if (_undoStack.isEmpty) return;

    setState(() {
      _redoStack.add(List.from(_newPolygonPoints));
      _newPolygonPoints = _undoStack.removeLast();
    });
  }

  void _onRedo() {
    if (_redoStack.isEmpty) return;

    setState(() {
      _undoStack.add(List.from(_newPolygonPoints));
      _newPolygonPoints = _redoStack.removeLast();
    });
  }

  void _onDrawFinished() {
    if (_newPolygonPoints.isEmpty || buildingsData == null) return;

    final existingFeatures =
        List<Map<String, dynamic>>.from(buildingsData!['features']);

    final intersects = existingFeatures.any((feature) {
      final geom = feature['geometry'];
      if (geom['type'] != 'Polygon') return false;

      final existingPolygon = GeometryHelper.parseCoordinates(geom);

      return GeometryHelper.doPolygonsIntersect(
          _newPolygonPoints, existingPolygon);
    });

    if (intersects) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Ky poligon ndërpritet me një ekzistues. Krijimi nuk lejohet.")),
      );
      return;
    }
    setState(() {
      // _isDrawing = false;
      if (_selectedShapeType == ShapeType.point) {
        _initialData['EntLatitude'] = _newPolygonPoints[0].latitude;
        _initialData['EntLongitude'] = _newPolygonPoints[0].longitude;
      } else {
        //initialize with centroid of polygon
        //   _initialData['BldLatitude']= newPoint.latitude;
        // _initialData['BldLongitude']= newPoint.longitude;
      }
      _isPropertyVisibile = true;
    });
  }

  void _onSave(Map<String, dynamic> attributes) {
    context
        .read<EntranceCubit>()
        .addEntranceFeature(attributes, _newPolygonPoints);

    setState(() {
      _isDrawing = false;
    });
  }

  void handleBuildingOnTap(TapPosition tapPosition, LatLng point) {
    if (buildingsData == null) return;

    try {
      final features =
          List<Map<String, dynamic>>.from(buildingsData!['features']);

      final tappedFeature = features.firstWhere(
        (feature) {
          final geometry = feature['geometry'];
          final polygonPoints = GeometryHelper.parseCoordinates(geometry);
          return GeometryHelper.isPointInPolygon(point, polygonPoints);
        },
        orElse: () => {},
      );

      if (tappedFeature.isEmpty) return;

      final props = tappedFeature['properties'];
      final objectId = props[EntranceFields.objectID];
      final globalId = props[EntranceFields.globalID];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(globalId)),
      );
      final isMobile =
          MediaQuery.of(context).size.width < AppConfig.tabletBreakpoint;

      setState(() {
        _selectedShapeType = ShapeType.polygon;
        _selectedObjectId = objectId;

        //find entrances of the selected building
        if (entranceData != null) {
          final features = entranceData?['features'] as List<dynamic>?;

          if (features != null) {
            final List<dynamic>? features = entranceData?['features'];

            if (features != null) {
              highilghGlobalIds = features
                  .whereType<Map<String, dynamic>>()
                  .where((feature) {
                    final props =
                        feature['properties'] as Map<String, dynamic>?;
                    return props != null &&
                        props['EntBldGlobalID']
                                ?.toString()
                                .toLowerCase()
                                .replaceAll(RegExp(r'[{}]'), '') ==
                            globalId
                                .toLowerCase()
                                .replaceAll(RegExp(r'[{}]'), '');
                  })
                  .map((feature) => feature['properties']?['OBJECTID'])
                  .where((id) => id != null)
                  .toList();
            }
          }
        }

        if (!isMobile) {
          _schema = _buildingSchema;
          _isPropertyVisibile = true;
          _initialData = props;
        }
      });

      if (isMobile) {
        mobileElementAttribute(context, _entranceSchema, props, _onSave);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  List<Marker> _buildMarkers() {
    return _newPolygonPoints.map((point) {
      return Marker(
        width: 30,
        height: 30,
        point: point,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1),
          ),
        ),
      );
    }).toList();
  }

  double? _previousZoom;
  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    // Check if zoom has changed
    final zoomChanged = _previousZoom == null || _previousZoom != camera.zoom;
    _previousZoom = camera.zoom;

    // Trigger only if the user moved the map or zoomed in/out
    if (!hasGesture && !zoomChanged) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context
          .read<BuildingCubit>()
          .getBuildings(camera.visibleBounds, camera.zoom);
      context
          .read<EntranceCubit>()
          .getEntrances(camera.visibleBounds, camera.zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _appBarKey,
        // title: Text("Map -${buildinGeoJsonParser.polygons.length}"),
      ),
      drawer: const SideMenu(),
      body: BlocConsumer<BuildingCubit, BuildingState>(
        listener: (context, state) {
          if (state is Buildings) {
            if (state.buildings.isNotEmpty) {
              buildingsData = state.buildings;
            }
          } else if (state is BuildingAttributes) {
            _buildingSchema = state.attributes;
          } else if (state is BuildingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return BlocConsumer<EntranceCubit, EntranceState>(
            listener: (context, state) {
              if (state is Entrances) {
                if (state.entrances.isNotEmpty) {
                  entranceData = state.entrances;
                }
              } else if (state is EntranceAttributes) {
                _entranceSchema = state.attributes;
              } else if (state is EntranceError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    flex: _isPropertyVisibile ? 2 : 1,
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: const LatLng(40.534406, 19.6338131),
                            initialZoom: EsriConfig.minZoom,
                            onMapReady: () => {
                              context.read<BuildingCubit>().getBuildings(
                                  mapController.camera.visibleBounds,
                                  EsriConfig.minZoom),
                              context.read<EntranceCubit>().getEntrances(
                                  mapController.camera.visibleBounds,
                                  EsriConfig.minZoom)
                            },
                            onPositionChanged: _onPositionChanged,
                            onTap: (tapPosition, point) {
                              if (!_isDrawing) {
                                handleBuildingOnTap(tapPosition, point);
                              }
                            },
                          ),
                          children: [
                            TileLayer(
                              tileProvider:
                                  ft.FileTileProvider(tileDirPath, false),
                            ),
                            EntranceMarker(
                              entranceData: entranceData,
                              onTap: handleEntranceTap,
                              selectedObjectId: _selectedObjectId,
                              selectedShapeType: _selectedShapeType,
                              mapController: mapController,
                              highilghGlobalIds: highilghGlobalIds,
                            ),
                            BuildingMarker(
                              buildingsData: buildingsData,
                              selectedObjectId: _selectedObjectId,
                              selectedShapeType: _selectedShapeType,
                            ),
                            if (_newPolygonPoints.isNotEmpty)
                              MarkerLayer(markers: _buildMarkers()),
                            if (_newPolygonPoints.isNotEmpty &&
                                _selectedShapeType == ShapeType.polygon)
                              PolygonLayer(polygons: [
                                Polygon(
                                  points: _newPolygonPoints,
                                  color: Colors.green.withOpacity(0.3),
                                  borderStrokeWidth: 2.0,
                                  borderColor: Colors.green,
                                )
                              ]),
                          ],
                        ),
                        _isDrawing
                            ? MapActionEvents(
                                onClose: _onClose,
                                onUndo: _onUndo,
                                onRedo: _onRedo,
                                onSave: _onDrawFinished,
                                newPolygonPoints: [..._newPolygonPoints],
                                mapController: mapController,
                                isEntrance:
                                    _selectedShapeType == ShapeType.point,
                                onMarkerPlaced: (LatLng position) {
                                  _onAddShape(position);
                                },
                              )
                            : MapActionButtons(
                                mapController: mapController,
                                enableDrawing: enableDrawing,
                              ),
                        Positioned(
                          bottom: 16,
                          left: 75,
                          child: MapLegend(
                            legendItems: _getCurrentLegendItems(),
                            title: "Legjenda",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _isPropertyVisibile,
                    child: Expanded(
                      flex: 1,
                      child: TabletElementAttribute(
                        schema: _schema,
                        initialData: _initialData,
                        save: _onSave,
                        onClose: () => {
                          setState(() {
                            _isPropertyVisibile = false;
                            _isDrawing = false;
                          })
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
