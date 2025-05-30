import 'dart:async';
import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/esri_condition_helper.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute.dart';
import 'package:asrdb/core/widgets/legend/legend_widget.dart';
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
  List<dynamic> highlightMarkersGlobalId = [];
  String? highlightedBuildingIds;
  String attributeLegend = 'quality';

  LatLngBounds? visibleBounds;
  double zoom = 0;

  Timer? _debounce;

  final GlobalKey _appBarKey = GlobalKey();

  List<FieldSchema> _schema = [];
  Map<String, dynamic> _initialData = {};

  ShapeType _selectedShapeType = ShapeType.point;
  String? _selectedGlobalId;
  String? _selectedBuildingId;

  Map<String, List<Legend>> buildingLegends = {};
  List<Legend> entranceLegends = [];

  MapController mapController = MapController();

  bool _isPropertyVisibile = false;
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
      _selectedGlobalId = data[EntranceFields.globalID];

      if (_selectedGlobalId == null) return;

      highlightMarkersGlobalId = [];
      _schema = _entranceSchema;
      _selectedShapeType = ShapeType.point;

      context.read<EntranceCubit>().getEntranceDetails(_selectedGlobalId!);

      final bldGlobalId = data['EntBldGlobalID'];

      setState(() {
        highlightedBuildingIds = bldGlobalId;
      });
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
        highlightMarkersGlobalId = [];
      } else {
        _schema = _entranceSchema;
        highlightedBuildingIds = _selectedBuildingId;
      }
      _isDrawing = true;
      _selectedShapeType = type;
      _isPropertyVisibile = false;
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

    if (_selectedShapeType == ShapeType.polygon) {
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
    }
    setState(() {
      // _isDrawing = false;
      _initialData = {};
      if (_selectedShapeType == ShapeType.point) {
        _initialData['EntLatitude'] = _newPolygonPoints[0].latitude;
        _initialData['EntLongitude'] = _newPolygonPoints[0].longitude;
        _initialData['EntBldGlobalID'] = _selectedBuildingId;
      } else {
        //initialize with centroid of polygon
        //   _initialData['BldLatitude']= newPoint.latitude;
        // _initialData['BldLongitude']= newPoint.longitude;
      }
      _isPropertyVisibile = true;
    });
  }

  void _onSave(Map<String, dynamic> attributes) {
    final isNew = attributes['GlobalID'] == null;
    final shapeType = _selectedShapeType;
    final scaffold = ScaffoldMessenger.of(context);

    if (shapeType == ShapeType.point) {
      scaffold.showSnackBar(
        SnackBar(content: Text(isNew ? 'add entrance' : 'update entrance')),
      );

      final entranceCubit = context.read<EntranceCubit>();

      if (isNew) {
        entranceCubit.addEntranceFeature(attributes, _newPolygonPoints);
      } else {
        final entranceFeatures = entranceData!['features'] as List<dynamic>;
        final feature = entranceFeatures.firstWhere(
          (f) =>
              (f['properties']?['GlobalID']?.toString() ?? '') ==
              attributes['GlobalID'],
          orElse: () => null,
        );

        if (feature != null) {
          final coords = feature['geometry']['coordinates'] as List<dynamic>;
          final latLng = LatLng(coords[0] as double, coords[1] as double);
          entranceCubit.updateEntranceFeature(attributes, [latLng]);
        }
      }
    } else if (shapeType == ShapeType.polygon) {
      scaffold.showSnackBar(
        SnackBar(content: Text(isNew ? 'add building' : 'update building')),
      );

      final buildingCubit = context.read<BuildingCubit>();

      if (isNew) {
        buildingCubit.addBuildingFeature(attributes, _newPolygonPoints);
      } else {
        final buildingFeatures = buildingsData!['features'] as List<dynamic>;
        final feature = buildingFeatures.firstWhere(
          (f) =>
              (f['properties']?['GlobalID']?.toString() ?? '') ==
              attributes['GlobalID'],
          orElse: () => null,
        );

        if (feature != null) {
          final coordinates =
              feature['geometry']['coordinates'] as List<dynamic>;
          final latLngList = coordinates
              .map<LatLng>(
                  (coord) => LatLng(coord[0] as double, coord[1] as double))
              .toList();

          buildingCubit.updateBuildingFeature(attributes, latLngList);
        }
      }
    }

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
      final globalId = props[EntranceFields.globalID];

      setState(() {
        _selectedShapeType = ShapeType.polygon;
        _selectedGlobalId = globalId;
        // _isDwellingVisible = false;
        highlightedBuildingIds = null;
        highlightMarkersGlobalId = [];
        _selectedBuildingId = globalId;

        //find entrances of the selected building
        if (entranceData != null) {
          final entranceFeatures = entranceData?['features'] as List<dynamic>?;

          if (entranceFeatures != null) {
            highlightMarkersGlobalId = entranceFeatures
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
                .map((feature) => feature['properties']?['GlobalID'])
                .where((id) => id != null)
                .toList();
          }
        }

        _schema = _buildingSchema;
        _isPropertyVisibile = true;
        _initialData = props;
      });
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
        child: GestureDetector(
          onTap: () => handleEntranceTap(_initialData),
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
    visibleBounds = mapController.camera.visibleBounds;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onLegendChangeAttribute(String seletedAttribute) {
    setState(() {
      attributeLegend = seletedAttribute;
    });
  }

  void _handleResponse(BuildContext context, bool isAdded, String actionName,
      int municipalityId) {
    _showSnackBar(
      context,
      isAdded ? "$actionName u krye" : "$actionName dështoi",
    );
    if (isAdded) {
      context
          .read<BuildingCubit>()
          .getBuildings(visibleBounds, zoom, municipalityId);
      setState(() => _newPolygonPoints.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = sl<UserService>();
    return Scaffold(
      appBar: AppBar(
        key: _appBarKey,
        title: Text(
            "Map -${userService.userInfo != null ? userService.userInfo!.familyName : 'unknown'}"),
      ),
      drawer: const SideMenu(),
      body: BlocConsumer<BuildingCubit, BuildingState>(
        listener: (context, state) {
          if (state is Buildings) {
            if (state.buildings.isNotEmpty) {
              buildingsData = state.buildings;
              context.read<EntranceCubit>().getEntrances(
                  zoom,
                  EsriConditionHelper.getPropertiesAsList(
                      'GlobalID', state.buildings));
            }
          } else if (state is BuildingAttributes) {
            _buildingSchema = state.attributes;
          } else if (state is BuildingAddResponse) {
            _handleResponse(context, state.isAdded, "Shtimi i nderteses",
                userService.userInfo!.municipality);
          } else if (state is BuildingUpdateResponse) {
            _handleResponse(context, state.isAdded, "Perditesimi i nderteses",
                userService.userInfo!.municipality);
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
                      _isPropertyVisibile = true;
                    }
                  }
                case EntranceAttributes(:final attributes):
                  _entranceSchema = attributes;
                case EntranceAddResponse(:final isAdded):
                  _handleResponse(context, isAdded, "Shtimi i hyrjes",
                      userService.userInfo!.municipality);
                case EntranceUpdateResponse(:final isAdded):
                  _handleResponse(context, isAdded, "Perditesimi i hyrjes",
                      userService.userInfo!.municipality);
                case EntranceDeleteResponse(:final isAdded):
                  _handleResponse(context, isAdded, "Fshirja e hyrjes",
                      userService.userInfo!.municipality);
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
                            initialZoom: EsriConfig.initZoom,
                            onMapReady: () => {
                              context.read<BuildingCubit>().getBuildings(
                                  mapController.camera.visibleBounds,
                                  EsriConfig.buildingMinZoom,
                                  userService.userInfo!.municipality),
                              // context.read<EntranceCubit>().getEntrances(
                              //     mapController.camera.visibleBounds,
                              //     EsriConfig.entranceMinZoom,),
                              // zoom = EsriConfig.initZoom,
                              visibleBounds =
                                  mapController.camera.visibleBounds,
                            },
                            onPositionChanged:
                                (MapCamera camera, bool hasGesture) =>
                                    _onPositionChanged(camera, hasGesture,
                                        userService.userInfo!.municipality),
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
                              selectedGlobalID: _selectedGlobalId,
                              selectedShapeType: _selectedShapeType,
                              attributeLegend: attributeLegend,
                              highlightedBuildingIds: highlightedBuildingIds,
                            ),
                            entranceData != null && entranceData!.isNotEmpty
                                ? EntranceMarker(
                                    entranceData: entranceData,
                                    onTap: handleEntranceTap,
                                    selectedGlobalId: _selectedGlobalId,
                                    selectedShapeType: _selectedShapeType,
                                    mapController: mapController,
                                    highilghGlobalIds: highlightMarkersGlobalId,
                                  )
                                : const SizedBox(),
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
                                selectedBuildingId: _selectedBuildingId),
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
                        Visibility(
                          visible: false,
                          child: Positioned(
                            top: 20,
                            right: 150,
                            child: FloatingActionButton(
                              onPressed: () => {},
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF374151),
                              elevation: 3,
                              child: const Icon(
                                Icons.layers,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _isPropertyVisibile,
                    child: ViewAttribute(
                      schema: _schema,
                      selectedShapeType: _selectedShapeType,
                      initialData: _initialData,
                      save: _onSave,
                      onClose: () {
                        setState(() {
                          _isPropertyVisibile = false;
                          _isDrawing = false;
                        });
                      },
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
