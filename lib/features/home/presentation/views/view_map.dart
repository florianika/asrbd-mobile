import 'dart:async';
import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/helpers/polygon_hit_detection.dart';
import 'package:asrdb/core/helpers/string_helper.dart';
import 'package:asrdb/core/models/build_fields.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/general_fields.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/note_service.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/widgets/element_attribute/dwelling/dwellings_form.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute.dart';
import 'package:asrdb/core/widgets/legend/legend_widget.dart';
import 'package:asrdb/core/widgets/loading_indicator.dart';
import 'package:asrdb/core/widgets/map_events/map_action_buttons.dart';
import 'package:asrdb/core/widgets/map_events/map_action_events.dart';
import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/loading_cubit.dart';
import 'package:asrdb/features/home/presentation/municipality_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:asrdb/features/home/presentation/widget/asrdb_map.dart';
import 'package:asrdb/features/home/presentation/widget/map_app_bar.dart';
import 'package:asrdb/localization/keys.dart';
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

    loadingCubit.show();

    try {
      final isNew = attributes[EntranceFields.globalID] == null;

      bool isValidShape = GeometryHelper.isPointOrValidPolygon(geometryCubit.points);

      if (!isValidShape) {
        NotifierService.showMessage(
          context,
          messageKey: Keys.invalidShape,
          type: MessageType.error,
        );
        return;
      }

      // Check if geometry is outside municipality
      if (!await _validateMunicipalityBounds(geometryCubit) && mounted) {
        NotifierService.showMessage(
          context,
          messageKey: Keys.outsideMunicipality,
          type: MessageType.warning,
        );
        return;
      }

      // Process based on shape type
      await _saveEntity(
        attributes,
        geometryCubit,
        attributesCubit,
        isNew,
      );

      // Clean up after successful save
      _cleanupAfterSave(geometryCubit);

      if (mounted) {
        NotifierService.showMessage(
          context,
          messageKey: Keys.successGeneral,
          type: MessageType.success,
        );
      }
    } catch (e) {
      _handleSaveError(e);
    } finally {
      loadingCubit.hide();
    }
  }

  Future<bool> _validateMunicipalityBounds(
      NewGeometryCubit geometryCubit) async {
    bool isOutsideMunicipality = false;

    final state = context.read<MunicipalityCubit>().state;

    if (state is Municipality && geometryCubit.points.isNotEmpty) {
      final municipality = state.municipality;
      isOutsideMunicipality = PolygonHitDetector.hasPointOutsideMultiPolygon(
          municipality![GeneralFields.features][0][GeneralFields.geometry],
          geometryCubit.points);
    }

    if (isOutsideMunicipality && geometryCubit.points.isNotEmpty) {
      NotifierService.showMessage(
        context,
        messageKey: Keys.outsideMunicipality,
        type: MessageType.warning,
      );
      return false;
    }

    return true;
  }

  Future<void> _saveEntity(
    Map<String, dynamic> attributes,
    NewGeometryCubit geometryCubit,
    AttributesCubit attributesCubit,
    bool isNew,
  ) async {
    switch (attributesCubit.shapeType) {
      case ShapeType.point:
        final entranceUseCase = sl<EntranceUseCases>();
        final entranceCubit = context.read<EntranceCubit>();
        final outputLogsCubit = context.read<OutputLogsCubit>();

        await entranceUseCase.saveEntrance(
          attributes,
          geometryCubit,
          outputLogsCubit,
          entranceCubit,
          isNew,
        );
        break;

      case ShapeType.polygon:
        final buildingUseCase = sl<BuildingUseCases>();
        final buildingCubit = context.read<BuildingCubit>();
        String? response = await buildingUseCase.saveBuilding(
            attributes, geometryCubit, buildingCubit, isNew);

        if (response != null && mounted) {
          NotifierService.showMessage(
            context,
            message: response.toString(),
            type: MessageType.error,
          );
        }
        break;
      case ShapeType.noShape:
        final dwellingUseCase = sl<DwellingUseCases>();
        final dwellingCubit = context.read<DwellingCubit>();
        final entranceCubit = context.read<EntranceCubit>();
        final outputLogsCubit = context.read<OutputLogsCubit>();

        final storageResponsitory = sl<StorageRepository>();
        String? buildingGlobalId = await storageResponsitory.getString(
          boxName: HiveBoxes.selectedBuilding,
          key: 'currentBuildingGlobalId',
        );

        // _selectedBuildingGlobalId = globalId;

        await dwellingUseCase.saveDwelling(attributes, dwellingCubit,
            entranceCubit, outputLogsCubit, buildingGlobalId!, isNew);
        break;
    }
  }

  void _cleanupAfterSave(NewGeometryCubit geometryCubit) {
    geometryCubit.setDrawing(false);
    geometryCubit.clearPoints();

    // Trick to trigger fetch of data again
    mapController.move(
        mapController.camera.center, mapController.camera.zoom + 0.01);
  }

  void _handleSaveError(dynamic error) {
    if (mounted) {
      NotifierService.showMessage(
        context,
        message: error.toString(),
        type: MessageType.error,
      );
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

    try {
      loadingCubit.show();
      final buildingDetails =
          await buildingUseCases.getBuildingDetails(globalId);
      final attributes =
          buildingDetails[GeneralFields.features][0][GeneralFields.properties];
      if (attributes[BuildFields.bldQuality] == DefaultData.untestedData &&
          mounted) {
        NotifierService.showMessage(
          context,
          messageKey: Keys.finishReviewWarning,
          type: MessageType.warning,
        );
        return;
      }

      if (mounted) {
        final building = context.read<AttributesCubit>();
        final buildingGlobalId = building.currentBuildingGlobalId!;

        final result = await sl<NoteService>().getNotes(buildingGlobalId);
        final noteCount = result.notes.length;
        if (attributes[BuildFields.bldQuality] ==
                DefaultData.dataWithoutErrors &&
            noteCount == 0) {
          attributes[BuildFields.bldReview] = DefaultData.reviewApproved;
        } else {
          attributes[BuildFields.bldReview] = DefaultData.reviewExecuted;
        }

        await buildingCubit.updateBuildingFeature(attributes, null);
      }
    } catch (e) {
      debugPrint("Error in _finishReviewing: $e");
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
                      NotifierService.showMessage(
                        context,
                        message: state.message,
                        type: MessageType.error,
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
                      NotifierService.showMessage(
                        context,
                        message: state.message,
                        type: MessageType.error,
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
                      NotifierService.showMessage(
                        context,
                        message: state.message,
                        type: MessageType.error,
                      );
                    } else if (state is DwellingUpdateResponse) {
                      NotifierService.showMessage(
                        context,
                        messageKey: state.isAdded
                            ? Keys.dwellingUpdated
                            : Keys.dwellingCouldNotUpdated,
                        type: state.isAdded
                            ? MessageType.success
                            : MessageType.warning,
                      );
                    } else if (state is DwellingAddResponse) {
                      NotifierService.showMessage(
                        context,
                        messageKey: state.isAdded
                            ? Keys.dwellingAdded
                            : Keys.dwellingCouldNotAdd,
                        type: state.isAdded
                            ? MessageType.success
                            : MessageType.warning,
                      );
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
                const DwellingForm(),
                BlocConsumer<AttributesCubit, AttributesState>(
                  listener: (context, state) {
                    if (state is AttributesError) {
                      NotifierService.showMessage(
                        context,
                        message: state.message,
                        type: MessageType.error,
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
