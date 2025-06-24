import 'dart:async';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/helpers/string_helper.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/widgets/chat/notes_modal.dart';
import 'package:asrdb/core/widgets/dialog_box.dart';
import 'package:asrdb/core/widgets/element_attribute/dwelling/dwellings_form.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute.dart';
import 'package:asrdb/core/widgets/legend/legend_widget.dart';
import 'package:asrdb/core/widgets/loading_indicator.dart';
import 'package:asrdb/core/widgets/map_events/map_action_buttons.dart';
import 'package:asrdb/core/widgets/map_events/map_action_events.dart';
import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/loading_cubit.dart';
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
  List<dynamic> highlightMarkersGlobalId = [];
  String? highlightedBuildingIds;
  String attributeLegend = 'quality';
  LatLng currentPosition = const LatLng(40.534406, 19.6338131);
  bool isLoading = false;
  LatLngBounds? visibleBounds;
  double zoom = 0;

  Timer? _debounce;

  Map<String, List<Legend>> buildingLegends = {};
  List<Legend> entranceLegends = [];
  bool _entranceOutsideVisibleArea = false;

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
    context.read<BuildingCubit>().getBuildingAttributes();
    context.read<EntranceCubit>().getEntranceAttributes();

    buildingLegends = {
      'quality':
          legendService.getLegendForStyle(LegendType.building, 'quality'),
      'review': legendService.getLegendForStyle(LegendType.building, 'review'),
      'status': legendService.getLegendForStyle(LegendType.building, 'status'),
      'centroidStatus': legendService.getLegendForStyle(
          LegendType.building, 'centroidStatus'),
    };
    entranceLegends =
        legendService.getLegendForStyle(LegendType.entrance, 'quality');
  }

  Future<void> _onSave(Map<String, dynamic> attributes) async {
    final loadingCubit = context.read<LoadingCubit>();
    final geometryCubit = context.read<NewGeometryCubit>();
    final attributesCubit = context.read<AttributesCubit>();
    final buildingCubit = context.read<BuildingCubit>();
    final dwellingCubit = context.read<DwellingCubit>();
    final entranceCubit = context.read<EntranceCubit>();
    final userService = sl<UserService>();

    loadingCubit.show();

    final isNew = attributes['GlobalID'] == null;

    try {
      if (attributesCubit.shapeType == ShapeType.point) {
        if (isNew) {
          final storageResponsitory = sl<StorageRepository>();
          String? buildingGlobalId = await storageResponsitory.getString(
            boxName: HiveBoxes.selectedBuilding,
            key: 'currentBuildingGlobalId',
          );

          attributes[EntranceFields.entBldGlobalID] = buildingGlobalId;
          attributes['external_creator'] = '{${userService.userInfo?.nameId}}';
          attributes['external_creator_date'] =
              DateTime.now().millisecondsSinceEpoch;
          attributes['EntLatitude'] = geometryCubit.points.first.latitude;
          attributes['EntLongitude'] = geometryCubit.points.first.longitude;
          await entranceCubit.addEntranceFeature(
              attributes, geometryCubit.points);
        } else {
          attributes['external_editor'] = '{${userService.userInfo?.nameId}}';
          attributes['external_editor_date'] =
              DateTime.now().millisecondsSinceEpoch;
          await entranceCubit.updateEntranceFeature(attributes);
        }
      } else if (attributesCubit.shapeType == ShapeType.polygon) {
        if (isNew) {
          final centroid =
              GeometryHelper.getPolygonCentroid(geometryCubit.points);
          attributes['BldMunicipality'] = userService.userInfo?.municipality;
          attributes['external_creator'] = '{${userService.userInfo?.nameId}}';
          attributes['external_creator_date'] =
              DateTime.now().millisecondsSinceEpoch;
          attributes['BldLatitude'] = centroid.latitude;
          attributes['BldLongitude'] = centroid.longitude;

          await buildingCubit.addBuildingFeature(
              attributes, geometryCubit.points);
        } else {
          attributes['external_editor'] = '{${userService.userInfo?.nameId}}';
          attributes['external_editor_date'] =
              DateTime.now().millisecondsSinceEpoch;
          await buildingCubit.updateBuildingFeature(attributes);
        }
      } else if (attributesCubit.shapeType == ShapeType.noShape) {
        if (isNew) {
          attributes['DwlEntGlobalID'] = entranceCubit.selectedEntranceGlobalId;
          attributes['external_creator'] = '{${userService.userInfo?.nameId}}';
          attributes['external_creator_date'] =
              DateTime.now().millisecondsSinceEpoch;
          await dwellingCubit.addDwellingFeature(attributes);
        } else {
          attributes['external_editor'] = '{${userService.userInfo?.nameId}}';
          attributes['external_editor_date'] =
              DateTime.now().millisecondsSinceEpoch;
          await dwellingCubit.updateDwellingFeature(attributes);
        }
      }
      geometryCubit.setDrawing(false);
      geometryCubit.clearPoints();
      //trick to trigger fetch of data again
      mapController.move(
          mapController.camera.center, mapController.camera.zoom + 0.01);
    } finally {
      loadingCubit.hide();
    }
  }

  Future<void> _startReviewing(String globalId) async {
    final loadingCubit = context.read<LoadingCubit>();
    final buildingCubit = context.read<BuildingCubit>();
    try {
      loadingCubit.show();
      await buildingCubit.startReviewing(globalId, 4);
    } finally {
      loadingCubit.hide();
    }
  }

  Future<void> _finishReviewing(String globalId) async {
    final loadingCubit = context.read<LoadingCubit>();
    final buildingUseCases = sl<BuildingUseCases>();
    final buildingCubit = context.read<BuildingCubit>();

    // if BldQuality == 9 show message 'You cant proceed without first validating the building
    // else {
    // show a modal to add a comment and if bldQuality = 1 and no comments added set BldReview = 2 else BldReview = 3
    //}

    try {
      loadingCubit.show();
      var buildingDetails = await buildingUseCases.getBuildingDetails(globalId);
      var attributes = buildingDetails['attributes'];

      if (attributes['BldQuality'] == 9 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "You cant proceed without first validating the building")),
        );
      } else {
        if (!mounted) return;

        final confirmed = await showConfirmationDialog(
          context: context,
          title: 'Add note',
          content: 'Doni te shtoni nje shenim?',
        );

        if (confirmed && mounted) {
          if (attributes['BldQuality'] == 1 /* && no notes found */) {
            attributes['BldReview'] = 2;
          } else {
            attributes['BldReview'] = 3;
          }
          await buildingCubit.updateBuildingFeature(attributes);
        }
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      loadingCubit.hide();
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
      body: BlocBuilder<LoadingCubit, LoadingState>(
        builder: (context, state) {
          return LoadingIndicator(
            isLoading: state.isLoading,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      AsrdbMap(
                        mapController: mapController,
                        attributeLegend: attributeLegend,
                        onEntranceVisibilityChange: (value) {
                          setState(() {
                            _entranceOutsideVisibleArea = value;
                          });
                        },
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
                BlocListener<BuildingCubit, BuildingState>(
                  listener: (context, state) {
                    if (state is BuildingError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is BuildingAddResponse ||
                        state is BuildingUpdateResponse) {
                      final id = StringHelper.removeCurlyBracesFromString(
                          (state as BuildingAddResponse).globalId);
                      context
                          .read<AttributesCubit>()
                          .showBuildingAttributes(id);
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
                BlocListener<EntranceCubit, EntranceState>(
                  listener: (context, state) {
                    if (state is EntranceError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is EntranceAddResponse ||
                        state is EntranceUpdateResponse) {
                      final id = StringHelper.removeCurlyBracesFromString(
                          (state as EntranceAddResponse).buildingGlboalId);
                      context
                          .read<AttributesCubit>()
                          .showBuildingAttributes(id);
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
                BlocListener<DwellingCubit, DwellingState>(
                  listener: (context, state) {
                    if (state is DwellingError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is DwellingUpdateResponse) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.isAdded
                                ? "Dwelling updated successfully"
                                : "Dwelling could not be updated",
                          ),
                        ),
                      );
                    } else if (state is DwellingAddResponse) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.isAdded
                                ? "Dwelling added successfully"
                                : "Dwelling could not be added",
                          ),
                        ),
                      );
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
                const DwellingForm(),
                BlocConsumer<AttributesCubit, AttributesState>(
                  listener: (context, state) {
                    if (state is AttributesError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return (state is AttributesVisibility &&
                            !state.showAttributes)
                        ? const SizedBox.shrink()
                        : ViewAttribute(
                            schema: state is Attributes ? state.schema : [],
                            selectedShapeType: state is Attributes
                                ? state.shapeType
                                : ShapeType.point,
                            entranceOutsideVisibleArea:
                                _entranceOutsideVisibleArea,
                            initialData:
                                state is Attributes ? state.initialData : {},
                            isLoading: state is AttributesLoading || isLoading,
                            save: _onSave,
                            startReviewing: _startReviewing,
                            onClose: () {
                              context
                                  .read<AttributesCubit>()
                                  .showAttributes(false);
                              setState(() {
                                highlightedBuildingIds = null;
                                highlightMarkersGlobalId = [];
                              });
                            },
                            finishReviewing: _finishReviewing,
                          );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
