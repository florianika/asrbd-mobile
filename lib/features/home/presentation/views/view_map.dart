import 'dart:async';
import 'dart:math';

import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/constants/app_config.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/widgets/element_attribute/mobile_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/core/widgets/map_events/map_action_buttons.dart';
import 'package:asrdb/core/widgets/map_events/map_action_events.dart';
import 'package:asrdb/core/widgets/markers/target_marker.dart';
import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
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
  Map<String, dynamic>? vanillaGeoJson;
  EntityType entityType = EntityType.entrance;
  List<FieldSchema> _buildingSchema = [];
  List<FieldSchema> _entranceSchema = [];

  Timer? _debounce;

  final GlobalKey _appBarKey = GlobalKey();

  List<FieldSchema> _schema = [];
  Map<String, dynamic> _initialData = {};

  ShapeType _selectedShapeType = ShapeType.point;

  MapController mapController = MapController();

  GeoJsonParser entranceGeoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.red,
    defaultPolygonBorderColor: Colors.red,
    defaultPolygonFillColor: Colors.red.withOpacity(0.1),
    defaultCircleMarkerColor: Colors.red.withOpacity(0.25),
  );

  GeoJsonParser buildinGeoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.red,
    defaultPolygonBorderColor: Colors.red,
    defaultPolygonFillColor: Colors.red.withOpacity(0.1),
    defaultCircleMarkerColor: Colors.red.withOpacity(0.25),
  );

  bool _isPropertyVisibile = false;

  Future<void> _initialize() async {
    context.read<BuildingCubit>().getBuildingAttibutes();
    context.read<EntranceCubit>().getEntranceAttributes();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void handleMarkerTap(Map<String, dynamic> data) {
    setState(() {
      _initialData = data;
      _schema = _entranceSchema;

      if (MediaQuery.of(context).size.width < AppConfig.tabletBreakpoint) {
        mobileElementAttribute(context, _entranceSchema, data);
      } else {
        _isPropertyVisibile = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();

    entranceGeoJsonParser.onMarkerTapCallback = handleMarkerTap;
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

  void _onSave() {
    if (_newPolygonPoints.isEmpty) return;

    setState(() {
      _isPropertyVisibile = true;
    });
  }

  void handleOnTap(TapPosition tapPosition, LatLng point) {
    try {
      var selectedFeatureManual = buildinGeoJsonParser.polygons
          .where(
            (feature) => GeometryHelper.isPointInPolygon(point, feature.points),
          )
          .firstOrNull;

      if (selectedFeatureManual != null) {
        var response = GeometryHelper.findPolygonPropertiesByCoordinates(
            vanillaGeoJson!, selectedFeatureManual.points);

        if (response != null) {
          if (MediaQuery.of(context).size.width < AppConfig.tabletBreakpoint) {
            mobileElementAttribute(context, _entranceSchema, response);
          } else {
            setState(() {
              _schema = _buildingSchema;
              _isPropertyVisibile = true;
              _initialData = response;
            });
          }
        }
      }
    } catch (e) {
      // _showPopup(context, e.toString());
    }
  }

  List<Marker> _buildMarkers() {
    final RenderBox box =
        _appBarKey.currentContext?.findRenderObject() as RenderBox;

    return _newPolygonPoints.map((point) {
      return Marker(
        width: 36.0,
        height: 36.0,
        point: point,
        child: Draggable(
          feedback: Transform.translate(
            offset: const Offset(0, -90),
            child: const TargetMarker(
              color: Colors.red,
            ),
          ),
          childWhenDragging: Container(), // Hide original marker during drag
          onDragEnd: (details) {
            setState(() {
              int index = _newPolygonPoints.indexOf(point);

              final RenderBox mapRenderBox =
                  context.findRenderObject() as RenderBox;
              final mapPosition = mapRenderBox.localToGlobal(Offset.zero);

              final appBarHeight = box.size.height;
              final topPadding = MediaQuery.of(context).padding.top;

              final dropOffset = details.offset +
                  const Offset(0, -90) // offset used during drag feedback
                  +
                  const Offset(18, 36 + 18); // center of the 36x36 feedback

              final localDropPosition = dropOffset -
                  mapPosition -
                  Offset(MediaQuery.of(context).padding.left,
                      appBarHeight + topPadding);

              final newPoint = mapController.camera.pointToLatLng(
                Point(localDropPosition.dx, localDropPosition.dy),
              );

              _newPolygonPoints[index] = newPoint;
            });
          },
          onDragUpdate: (details) {
            setState(() {
              int index = _newPolygonPoints.indexOf(point);

              final RenderBox mapRenderBox =
                  context.findRenderObject() as RenderBox;
              final mapPosition = mapRenderBox.localToGlobal(Offset.zero);

              final appBarHeight = box.size.height;
              final topPadding = MediaQuery.of(context).padding.top;

              final dropOffset = details.globalPosition +
                  const Offset(0, -72); // your effective vertical offset

              final localDropPosition = dropOffset -
                  mapPosition -
                  Offset(MediaQuery.of(context).padding.left,
                      appBarHeight + topPadding);

              final newPoint = mapController.camera.pointToLatLng(
                Point(localDropPosition.dx, localDropPosition.dy),
              );

              _newPolygonPoints[index] = newPoint;
            });
          },
          child: const TargetMarker(),
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
        title: Text("Map -${buildinGeoJsonParser.polygons.length}"),
      ),
      drawer: const SideMenu(),
      body: BlocConsumer<BuildingCubit, BuildingState>(
        listener: (context, state) {
          if (state is Buildings) {
            if (state.buildings.isNotEmpty) {
              setState(() {
                buildinGeoJsonParser.polygons.clear();
                buildinGeoJsonParser.parseGeoJson(state.buildings);
              });

              vanillaGeoJson = state.buildings;
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
                  entranceGeoJsonParser.markers.clear();
                  entranceGeoJsonParser.parseGeoJson(state.entrances);
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
                              if (_isDrawing) {
                                _onAddShape(point);
                              } else {
                                handleOnTap(tapPosition, point);
                              }
                            },
                          ),
                          children: [
                            TileLayer(
                              tileProvider:
                                  ft.FileTileProvider(tileDirPath, false),
                            ),
                            if (_newPolygonPoints.isNotEmpty)
                              PolygonLayer(
                                polygons: [
                                  Polygon(
                                    points: _newPolygonPoints,
                                    color: Colors.blue
                                        .withOpacity(0.3), // lighter fill
                                    borderColor:
                                        Colors.blueAccent, // more vivid border
                                    borderStrokeWidth:
                                        3, // slightly thicker border
                                  ),
                                ],
                              ),
                            if (_newPolygonPoints.isNotEmpty)
                              MarkerLayer(markers: _buildMarkers()),
                            MarkerLayer(markers: entranceGeoJsonParser.markers),
                            PolygonLayer(
                              polygons: buildinGeoJsonParser.polygons
                                  .where((singlePolygon) =>
                                      singlePolygon.points.isNotEmpty)
                                  .toList(),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: !_isDrawing
                              ? MapActionButtons(
                                  mapController: mapController,
                                  enableDrawing: enableDrawing,
                                )
                              : MapActionEvents(
                                  onClose: _onClose,
                                  onUndo: _onUndo,
                                  onRedo: _onRedo,
                                  onSave: _onSave,
                                  newPolygonPoints: [..._newPolygonPoints],
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
                        onClose: () => {
                          setState(() {
                            _isPropertyVisibile = false;
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
