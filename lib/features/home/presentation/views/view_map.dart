import 'dart:math';

import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/widgets/map_events/map_action_buttons.dart';
import 'package:asrdb/core/widgets/map_events/map_action_events.dart';
import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:asrdb/core/widgets/file_tile_provider.dart' as _ft;

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  bool _isInitialized = true;
  late String tileDirPath = '';
  bool _isDrawing = false;
  List<LatLng> _newPolygonPoints = [];

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

  Future<void> _initialize() async {
    context.read<BuildingCubit>().getBuildings();
    context.read<EntranceCubit>().getEntrances();
  }

  void handleMarkerTap(Map<String, dynamic> data) {
    // _showPopup(context, data[EntranceFields.objectID].toString());
    //TODO: show  popup
  }

  @override
  void initState() {
    super.initState();
    _initialize();

    entranceGeoJsonParser.onMarkerTapCallback = handleMarkerTap;
  }

  void _onAddPolygon(LatLng position) {
    setState(() {
      _newPolygonPoints.add(position);
    });
  }

  void enableDrawing(ShapeType type) {
    setState(() {
      _isDrawing = true;
    });
  
  }

  void _onClose() {
    setState(() {
      _isDrawing = false;
      _newPolygonPoints.clear();
    });
  }

  void _onUndo(List<LatLng> newPolygonPoints) {
    setState(() {
      _newPolygonPoints = newPolygonPoints;
    });
  }


  List<Marker> _buildMarkers() {
    return _newPolygonPoints.map((point) {
      return Marker(
        width: 50.0,
        height: 50.0,
        point: point,
        child: Draggable(
          feedback:
              Icon(Icons.circle, size: 20, color: Colors.red.withOpacity(0.5)),
          childWhenDragging: Container(), // Hide original marker during drag
          onDragEnd: (details) {
            setState(() {
              int index = _newPolygonPoints.indexOf(point);

              // Get the RenderBox of the map
              final RenderBox mapRenderBox =
                  context.findRenderObject() as RenderBox;

              // Get the top-left position of the map in global coordinates
              final mapPosition = mapRenderBox.localToGlobal(Offset.zero);

              // Convert global drag position to local map-relative position
              final localDropPosition = details.offset - mapPosition;

              // Convert local screen position to LatLng
              final newPoint = mapController.camera.pointToLatLng(
                Point(localDropPosition.dx, localDropPosition.dy),
              );

              // Update the point in the polygon list
              _newPolygonPoints[index] = newPoint;
            });
          },
          child: const Icon(Icons.circle, size: 20, color: Colors.red),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map")),
      drawer: const SideMenu(),
      body: BlocConsumer<BuildingCubit, BuildingState>(
        listener: (context, state) {
          if (state is Buildings) {
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.buildings.length.toString())),
              );

              buildinGeoJsonParser.parseGeoJson(state.buildings);
            });
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
                entranceGeoJsonParser.parseGeoJson(state.entrances);
              } else if (state is EntranceError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: const LatLng(40.534406, 19.6338131),
                      initialZoom: 13.0,
                      onTap: (tapPosition, point) =>
                          {if (_isDrawing) _onAddPolygon(point)},
                    ),
                    children: [
                      TileLayer(
                        tileProvider: _ft.FileTileProvider(tileDirPath, false),
                      ),
                      _newPolygonPoints.isNotEmpty
                          ? PolygonLayer(
                              polygons: [
                                Polygon(
                                  points: _newPolygonPoints,
                                  color: Colors.blue.withOpacity(0.4),
                                  borderColor: Colors.blue,
                                  borderStrokeWidth: 2,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      _newPolygonPoints.isNotEmpty
                          ? MarkerLayer(
                              markers: _buildMarkers(),
                            )
                          : const SizedBox(),
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
                            newPolygonPoints: [..._newPolygonPoints],
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
