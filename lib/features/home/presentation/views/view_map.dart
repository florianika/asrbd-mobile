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
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute_shimmer.dart';
import 'package:asrdb/core/widgets/legend/legend_widget.dart';
import 'package:asrdb/core/widgets/map_events/map_action_buttons.dart';
import 'package:asrdb/core/widgets/map_events/map_action_events.dart';
import 'package:asrdb/core/widgets/markers/building_marker.dart';
import 'package:asrdb/core/widgets/markers/entrance_marker.dart';
import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:asrdb/features/home/presentation/widget/asrdb_map.dart';
import 'package:asrdb/features/home/presentation/widget/map_app_bar.dart';
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
  MapController mapController = MapController();
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
  LatLng currentPosition = const LatLng(40.534406, 19.6338131);

  LatLngBounds? visibleBounds;
  double zoom = 0;

  Timer? _debounce;

  List<FieldSchema> _schema = [];
  Map<String, dynamic> _initialData = {};

  ShapeType _selectedShapeType = ShapeType.point;
  String? _selectedGlobalId;
  String? _selectedBuildingId;

  Map<String, List<Legend>> buildingLegends = {};
  List<Legend> entranceLegends = [];

  bool _isPropertyVisibile = false;
  bool _showLocationMarker = false;
  bool _isDwellingVisible = false;
  final legendService = sl<LegendService>();
  LatLng? _userLocation;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // _goToCurrentLocation();
    context.read<BuildingCubit>().attributesCubit;
    context.read<EntranceCubit>().getEntranceAttributes();

    buildingLegends = {
      'quality':
          legendService.getLegendForStyle(LegendType.building, 'quality'),
      'review': legendService.getLegendForStyle(LegendType.building, 'review'),
    };

    entranceLegends =
        legendService.getLegendForStyle(LegendType.entrance, 'quality');
  }

  // void _onAddShape(LatLng position) {
  //   if (_selectedShapeType == ShapeType.point &&
  //       _newPolygonPoints.length == 1) {
  //     return;
  //   }

  //   setState(() {
  //     _undoStack.add(List.from(_newPolygonPoints)); // Save current state
  //     _redoStack.clear(); // Clear redo on new action
  //     _newPolygonPoints.add(position);
  //   });
  // }

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
    final userService = sl<UserService>();
    final geometryCubit = context.read<NewGeometryCubit>();
    final buildingCubit = context.read<BuildingCubit>();
    final shapeType =
        geometryCubit.points.length > 1 ? ShapeType.polygon : ShapeType.point;

    if (shapeType == ShapeType.point) {
      final entranceCubit = context.read<EntranceCubit>();
      // buildingCubit.globalId

      if (isNew) {
        attributes[EntranceFields.entBldGlobalID] = buildingCubit.globalId;
        attributes[EntranceFields.entLatitude] =
            geometryCubit.points.first.latitude;
        attributes[EntranceFields.entLongitude] =
            geometryCubit.points.first.longitude;
        attributes['external_creator'] = userService.userInfo?.nameId;
        entranceCubit.addEntranceFeature(attributes, geometryCubit.points);
      } else {
        entranceCubit.updateEntranceFeature(attributes);
      }
    } else if (shapeType == ShapeType.polygon) {
      if (isNew) {
        // attributes['external_creator'] = '{${userService.userInfo?.nameId}}';
        attributes['BldMunicipality'] = userService.userInfo?.municipality;
        buildingCubit.addBuildingFeature(attributes, geometryCubit.points);
      } else {
        buildingCubit.updateBuildingFeature(attributes);
      }
    }
  }

  void onLegendChangeAttribute(String seletedAttribute) {
    setState(() {
      attributeLegend = seletedAttribute;
    });
  }

  // void _handleResponse(BuildContext context, bool isAdded, String actionName,
  //     int municipalityId) {
  //   _showSnackBar(
  //     context,
  //     isAdded ? "$actionName u krye" : "$actionName dështoi",
  //   );
  //   if (isAdded) {
  //     context
  //         .read<BuildingCubit>()
  //         .getBuildings(visibleBounds, zoom, municipalityId);
  //     setState(() => _newPolygonPoints.clear());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final userService = sl<UserService>();
    return Scaffold(
      appBar: const MapAppBar(),
      drawer: const SideMenu(),
      body: Row(
        children: [
          Expanded(
            flex: _isPropertyVisibile ? 3 : 2,
            child: Stack(
              children: [
                AsrdbMap(
                  mapController: mapController,
                ),
                BlocConsumer<NewGeometryCubit, NewGeometryState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return (state as NewGeometry).isDrawing
                          ? MapActionEvents(
                              mapController: mapController,
                              onSave: _onSave,
                            )
                          : MapActionButtons(
                              mapController: mapController,
                              enableDrawing: (ShapeType type) {
                                enableDrawing(type);
                                setState(() {
                                  _showLocationMarker = false;
                                });
                              },
                              onLocateMe: () => {},
                              selectedBuildingId: _selectedBuildingId);
                    }),
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
          BlocConsumer<AttributesCubit, AttributesState>(
              listener: (context, state) {
            if (state is AttributesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          }, builder: (context, state) {
            return (state is AttributesVisibility &&
                    state.showAttributes == false)
                ? const SizedBox()
                : Visibility(
                    visible: true,
                    child: ViewAttribute(
                      schema: state is Attributes ? state.schema : [],
                      selectedShapeType: state is Attributes
                          ? state.shapeType
                          : ShapeType.point,
                      initialData: state is Attributes ? state.initialData : {},
                      isLoading: state is AttributesLoading,
                      save: _onSave,
                      onClose: () {
                        context.read<AttributesCubit>().showAttributes(false);
                        setState(() {
                          _isDrawing = false;
                          _selectedGlobalId = null;
                          highlightedBuildingIds = null;
                          highlightMarkersGlobalId = [];
                        });
                      },
                      onOpenDwelling: () {
                        setState(() {
                          context.read<AttributesCubit>().showAttributes(false);
                          _isDwellingVisible = true;
                        });
                      },
                    ),
                  );
          })
        ],
      ),
    );
  }
}
