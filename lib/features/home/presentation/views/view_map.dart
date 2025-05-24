import 'dart:async';

import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/constants/app_config.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/widgets/element_attribute/dwellings_form.dart';
import 'package:asrdb/core/widgets/element_attribute/mobile_element_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/tablet_element_attribute.dart';
import 'package:asrdb/core/widgets/legend/legend_widget.dart';
import 'package:asrdb/core/widgets/legend/map_legend.dart';
import 'package:asrdb/core/widgets/map_events/map_action_buttons.dart';
import 'package:asrdb/core/widgets/map_events/map_action_events.dart';
import 'package:asrdb/core/widgets/markers/building_marker.dart';
import 'package:asrdb/core/widgets/markers/entrance_marker.dart';
import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/main.dart';
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
  String attributeLegend = 'quality';

  LatLngBounds? visibleBounds;
  double zoom = 0;

  Timer? _debounce;

  final GlobalKey _appBarKey = GlobalKey();

  List<FieldSchema> _schema = [];
  Map<String, dynamic> _initialData = {};

  ShapeType _selectedShapeType = ShapeType.point;
  int _selectedObjectId = -1;

  Map<String, List<Legend>> buildingLegends = {};
  List<Legend> entranceLegends = [];

  MapController mapController = MapController();

  bool _isPropertyVisibile = false;
  bool _isDwellingVisible = false;

  final legendService = sl<LegendService>();

  Future<void> _initialize() async {
    context.read<BuildingCubit>().getBuildingAttibutes();
    context.read<EntranceCubit>().getEntranceAttributes();
   
   
    buildingLegends = {
      'quality':
          legendService.getLegendForStyle(LegendType.building, 'quality'),
      'review': legendService.getLegendForStyle(LegendType.building, 'review'),
    };

    entranceLegends =
        legendService.getLegendForStyle(LegendType.entrance, 'quality');
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

      _selectedObjectId = data['OBJECTID'];
      highilghGlobalIds = [];

      _schema = _entranceSchema;
      _selectedShapeType = ShapeType.point;

      context.read<EntranceCubit>().getEntranceDetails(data['OBJECTID']);

      // For mobile devices, show the mobile attribute UI
      // if (isMobile) {
      //   mobileElementAttribute(context, _entranceSchema, data, _onSave);
      // }
    } catch (e) {
      // Display error message to the user in case of exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showContextMenu(
    BuildContext context,
    Offset globalPosition,
    EntityType type,
    LatLng position,
  ) async {
    final selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        globalPosition.dx,
        globalPosition.dy,
      ),
      items: const [
        PopupMenuItem(
          value: 'view',
          child: Text('View Properties'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    );

    if (selected == 'view') {
      if (type == EntityType.entrance) {
        _schema = _entranceSchema;
      } else {
        _schema = _buildingSchema;
      }

      setState(() {
        _initialData = {
          'Lat': position.latitude,
          'Lng': position.longitude,
        };
        _isPropertyVisibile = true;
      });
    } else if (selected == 'delete') {
      // Handle delete if needed
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
    if (_newPolygonPoints.isEmpty) return;
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
      final buildingFeatures =
          List<Map<String, dynamic>>.from(buildingsData!['features']);

      final tappedFeature = buildingFeatures.firstWhere(
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

      final isMobile =
          MediaQuery.of(context).size.width < AppConfig.tabletBreakpoint;

      setState(() {
        _selectedShapeType = ShapeType.polygon;
        _selectedObjectId = objectId;

        //find entrances of the selected building
        if (entranceData != null) {
          final entranceFeatures = entranceData?['features'] as List<dynamic>?;

          if (entranceFeatures != null) {
            highilghGlobalIds = entranceFeatures
                .whereType<Map<String, dynamic>>()
                .where((feature) {
                  final props = feature['properties'] as Map<String, dynamic>?;
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

    zoom = camera.zoom;
    visibleBounds = mapController.camera.visibleBounds;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onLegendChangeAttribute(String seletedAttribute) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(seletedAttribute)));
    setState(() {
      attributeLegend = seletedAttribute;
    });
  }

  void _handleEntranceResponse(
      BuildContext context, bool isAdded, String actionName) {
    _showSnackBar(
      context,
      isAdded ? "$actionName u krye" : "$actionName dështoi",
    );
    if (isAdded) {
      context.read<EntranceCubit>().getEntrances(visibleBounds, zoom);
      setState(() => _newPolygonPoints.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _appBarKey,
        title: Text(
            "Map -${entranceData != null ? (entranceData?['features'] as List<dynamic>).length : 0}"),
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
              switch (state) {
                case Entrances(:final entrances):
                  if (entrances.isNotEmpty) entranceData = entrances;
                case Entrance(:final entrance):
                  if (entrance.isNotEmpty) {
                    List<dynamic> features = entrance['features'];
                    if (features.isNotEmpty &&
                        features[0] is Map<String, dynamic>) {
                      Map<String, dynamic> firstFeature = features[0];
                      Map<String, dynamic> properties =
                          firstFeature['properties'];
                      _initialData = properties;
                      _isPropertyVisibile = true;
                    }
                  }
                case EntranceAttributes(:final attributes):
                  _entranceSchema = attributes;
                case EntranceAddResponse(:final isAdded):
                  _handleEntranceResponse(context, isAdded, "Shtimi i hyrjes");
                case EntranceUpdateResponse(:final isAdded):
                  _handleEntranceResponse(
                      context, isAdded, "Perditesimi i hyrjes");
                case EntranceDeleteResponse(:final isAdded):
                  _handleEntranceResponse(context, isAdded, "Fshirja e hyrjes");
                case EntranceError(:final message):
                  _showSnackBar(context, message);
              }
            },
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    flex: _isPropertyVisibile ? 3 : 2,
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
                                  EsriConfig.minZoom),
                              zoom = EsriConfig.minZoom,
                              visibleBounds =
                                  mapController.camera.visibleBounds,
                            },
                            onPositionChanged: _onPositionChanged,
                            onLongPress: (tapPosition, point) => (),
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
                            BuildingMarker(
                              buildingsData: buildingsData,
                              selectedObjectId: _selectedObjectId,
                              selectedShapeType: _selectedShapeType,
                              onLongPressContextMenu: _showContextMenu,
                              attributeLegend: attributeLegend,
                            ),
                            EntranceMarker(
                              entranceData: entranceData,
                              onTap: handleEntranceTap,
                              selectedObjectId: _selectedObjectId,
                              selectedShapeType: _selectedShapeType,
                              mapController: mapController,
                              highilghGlobalIds: highilghGlobalIds,
                              onLongPressContextMenu: _showContextMenu,
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
                          top: 20,
                          right: 20,
                          child: CombinedLegendWidget(
                            buildingLegends: buildingLegends,
                            initialBuildingAttribute: 'quality',
                            entranceLegends: entranceLegends,
                            onChange: onLegendChangeAttribute,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _isPropertyVisibile,
                    child: Expanded(
                      flex: _isDwellingVisible ? 5 : 1,
                      child: _isDwellingVisible
                          ? DwellingForm(
                              selectedShapeType: ShapeType.point,
                              entranceGlobalId:
                                  _initialData['GlobalID']?.toString(),
                              //entranceGlobalId:  _initialData['EntBldGlobalID']?.toString(),
                              onBack: () {
                                setState(() {
                                  _isDwellingVisible = false;
                                });
                              },
                            )
                          : TabletElementAttribute(
                              schema: _schema,
                              selectedShapeType: _selectedShapeType,
                              // entranceGlobalId:
                              //     _initialData['GlobalID']?.toString(),
                              initialData: _initialData,
                              save: _onSave,
                              onClose: () {
                                setState(() {
                                  _isPropertyVisibile = false;
                                  _isDrawing = false;
                                });
                              },
                              onOpenDwelling: () {
                                setState(() {
                                  _isDwellingVisible = true;
                                });
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
