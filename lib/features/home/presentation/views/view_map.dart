import 'dart:async';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute.dart';
import 'package:asrdb/core/widgets/legend/legend_widget.dart';
import 'package:asrdb/core/widgets/map_events/map_action_buttons.dart';
import 'package:asrdb/core/widgets/map_events/map_action_events.dart';
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

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  MapController mapController = MapController();
  late String tileDirPath = '';

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

  void _onSave(Map<String, dynamic> attributes) {
    final isNew = attributes['GlobalID'] == null;
    final userService = sl<UserService>();
    final geometryCubit = context.read<NewGeometryCubit>();
    final buildingCubit = context.read<BuildingCubit>();
    // final attributesCubit = context.read<AttributesCubit>();

    String msg =
        'New: $isNew, type: ${geometryCubit.type}, NoPoints: ${geometryCubit.points.length}, municip: ${userService.userInfo?.municipality}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );

    if (geometryCubit.type == ShapeType.point) {
      final entranceCubit = context.read<EntranceCubit>();
      if (isNew) {
        attributes[EntranceFields.entBldGlobalID] = buildingCubit.globalId;
        attributes['external_creator'] = '{${userService.userInfo?.nameId}}';
        attributes['external_creator_date'] =
            DateTime.now().millisecondsSinceEpoch;
        entranceCubit.addEntranceFeature(attributes, geometryCubit.points);
      } else {
        attributes['external_editor'] = '{${userService.userInfo?.nameId}}';
        attributes['external_editor_date'] =
            DateTime.now().millisecondsSinceEpoch;
        entranceCubit.updateEntranceFeature(attributes);
      }
    } else if (geometryCubit.type == ShapeType.polygon) {
      if (isNew) {
        attributes['BldMunicipality'] = userService.userInfo?.municipality;
        attributes['external_creator'] = '{${userService.userInfo?.nameId}}';
        attributes['external_creator_date'] =
            DateTime.now().millisecondsSinceEpoch;
        buildingCubit.addBuildingFeature(attributes, geometryCubit.points);
      } else {
        attributes['external_editor'] = '{${userService.userInfo?.nameId}}';
        attributes['external_editor_date'] =
            DateTime.now().millisecondsSinceEpoch;
        buildingCubit.updateBuildingFeature(attributes);
      }
    }
  }

  void onLegendChangeAttribute(String seletedAttribute) {
    setState(() {
      attributeLegend = seletedAttribute;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  attributeLegend: attributeLegend,
                ),
                BlocConsumer<NewGeometryCubit, NewGeometryState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return (state as NewGeometry).isDrawing
                          ? MapActionEvents(
                              mapController: mapController,
                            )
                          : MapActionButtons(
                              mapController: mapController,
                            );
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
            return (state is AttributesVisibility && !state.showAttributes)
                ? const SizedBox()
                : ViewAttribute(
                    schema: state is Attributes ? state.schema : [],
                    selectedShapeType:
                        state is Attributes ? state.shapeType : ShapeType.point,
                    initialData: state is Attributes ? state.initialData : {},
                    isLoading: state is AttributesLoading,
                    save: _onSave,
                    onClose: () {
                      context.read<AttributesCubit>().showAttributes(false);
                      setState(() {
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
                  );
          })
        ],
      ),
    );
  }
}
