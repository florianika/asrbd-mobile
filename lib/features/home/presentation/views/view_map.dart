import 'dart:async';
import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/string_helper.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/note_service.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/widgets/element_attribute/dwelling/dwellings_form.dart';
import 'package:asrdb/core/widgets/element_attribute/view_attribute.dart';
import 'package:asrdb/core/widgets/legend/legend_widget.dart';
import 'package:asrdb/core/widgets/loading_indicator.dart';
import 'package:asrdb/core/widgets/map_shape_editor/map_geometry_editor.dart';
import 'package:asrdb/core/widgets/map_shape_editor/map_action_events.dart';
import 'package:asrdb/core/widgets/side_menu.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/domain/entities/save_result.dart';
import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/loading_cubit.dart';
import 'package:asrdb/features/home/presentation/widget/asrdb_map.dart';
import 'package:asrdb/features/home/presentation/widget/map_app_bar.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
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

    loadingCubit.show();

    try {
      if (attributes['GeometryType'] == 'Polygon') {
        final building = BuildingEntity.fromMap(attributes);
        await _saveBuilding(building);
      } else if (attributes['GeometryType'] == 'Point') {
        final entrance = EntranceEntity.fromMap(attributes);
        await _saveEntrance(entrance);
      } else if (attributes['GeometryType'] == null) {
        final dwelling = DwellingEntity.fromMap(attributes);
        await _saveDwelling(dwelling);
      } else {
        NotifierService.showMessage(
          context,
          message: "unsupported geometry type: ${attributes['GeometryType']}",
          type: MessageType.error,
        );
        return;
      }

      // Clean up after successful save
      _cleanupAfterSave();
    } catch (e) {
      _handleSaveError(e);
    } finally {
      loadingCubit.hide();
    }
  }

  Future<void> _saveDwelling(DwellingEntity dwelling) async {
    final entranceUseCase = sl<DwellingUseCases>();
    final attributeCubit = sl<AttributesCubit>();
    final checkUseCase = sl<CheckUseCases>();
    final offlineMode = false;

    try {
      NotifierService.showMessage(
        context,
        message: attributeCubit.currentEntranceGlobalId.toString(),
        type: MessageType.info,
      );
      dwelling.dwlEntGlobalID ??= attributeCubit.currentEntranceGlobalId;
      SaveResult response = await entranceUseCase.saveDwelling(
        dwelling,
        offlineMode,
      );
      if (mounted) {
        await checkUseCase.checkAutomatic(attributeCubit
            .currentEntrance!.entBldGlobalID
            .removeCurlyBraces()!);
      }

      if (mounted) {
        NotifierService.showMessage(
          context,
          message:
              '${AppLocalizations.of(context).translate(response.key)} ${response.data != null ? '- Referenca: ${response.data}' : ''}',
          type: response.success ? MessageType.success : MessageType.error,
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  Future<void> _saveEntrance(EntranceEntity entrance) async {
    final entranceUseCase = sl<EntranceUseCases>();
    final checkUseCase = sl<CheckUseCases>();
    final offlineMode = false;

    try {
      SaveResult response =
          await entranceUseCase.saveEntrance(entrance, offlineMode);

      await checkUseCase
          .checkAutomatic(entrance.entBldGlobalID.removeCurlyBraces()!);

      if (mounted) {
        NotifierService.showMessage(
          context,
          message:
              '${AppLocalizations.of(context).translate(response.key)} ${response.data != null ? '- Referenca: ${response.data}' : ''}',
          type: response.success ? MessageType.success : MessageType.error,
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  Future<void> _saveBuilding(BuildingEntity building) async {
    final buildingUseCase = sl<BuildingUseCases>();
    final checkUseCase = sl<CheckUseCases>();
    final buildingCubit = context.read<BuildingCubit>();
    final offlineMode = false;

    try {
      final buildings = (buildingCubit.state as Buildings).buildings;

      if (buildingUseCase.intersectsWithOtherBuildings(building, buildings)) {
        // Show dialog asking user to confirm intersection
        final shouldProceed = await _showIntersectionDialog();

        if (!shouldProceed) {
          // User cancelled, don't proceed with saving
          return;
        }
      }

      SaveResult response = await buildingUseCase.saveBuilding(
        building,
        offlineMode,
      );

      await checkUseCase.checkAutomatic(building.globalId.removeCurlyBraces()!);

      if (mounted) {
        NotifierService.showMessage(
          context,
          message:
              '${AppLocalizations.of(context).translate(response.key)} ${response.data != null ? '- Referenca: ${response.data}' : ''}',
          type: response.success ? MessageType.success : MessageType.error,
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  Future<bool> _showIntersectionDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // Prevent dismissing by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)
                  .translate(Keys.intersectionDetected)),
              content: Text(AppLocalizations.of(context)
                  .translate(Keys.intersectionMessage)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child:
                      Text(AppLocalizations.of(context).translate(Keys.cancel)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                      AppLocalizations.of(context).translate(Keys.proceed)),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }

  void _cleanupAfterSave() {
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
    final buildingUseCases = sl<BuildingUseCases>();
    try {
      loadingCubit.show();

      bool startedValidation =
          await buildingUseCases.startReviewing(globalId, 4);

      if (startedValidation && mounted) {
        NotifierService.showMessage(
          context,
          messageKey: Keys.startValidationSuccess,
          type: MessageType.success,
        );
      } else {
        if (mounted) {
          NotifierService.showMessage(
            context,
            messageKey: Keys.startValidationWarning,
            type: MessageType.warning,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        NotifierService.showMessage(
          context,
          message: e.toString(),
          type: MessageType.warning,
        );
      }
    } finally {
      loadingCubit.hide();
    }
  }

  Future<void> _finishReviewing(String globalId) async {
    final loadingCubit = context.read<LoadingCubit>();
    final buildingUseCases = sl<BuildingUseCases>();

    try {
      loadingCubit.show();
      final buildingDetails =
          await buildingUseCases.getBuildingDetails(globalId);

      if (buildingDetails.bldQuality == DefaultData.untestedData && mounted) {
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

        if (buildingDetails.bldQuality == DefaultData.dataWithoutErrors &&
            noteCount == 0) {
          buildingDetails.bldReview = DefaultData.reviewApproved;
        } else {
          buildingDetails.bldReview = DefaultData.reviewExecuted;
        }

        await buildingUseCases.updateBuildingFeature(buildingDetails);
      }

      if (mounted) {
        NotifierService.showMessage(
          context,
          messageKey: Keys.finishReviewingSuccess,
          type: MessageType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        NotifierService.showMessage(
          context,
          message: e.toString(),
          type: MessageType.warning,
        );
      }
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
      appBar: MapAppBar(msg: ''),
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
                      BlocBuilder<GeometryEditorCubit, GeometryEditorState>(
                        builder: (context, state) {
                          return context.read<GeometryEditorCubit>().isEditing
                              ? MapActionEvents(mapController: mapController)
                              : MapGeometryEditor(mapController: mapController);
                        },
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
                // BlocListener<EntranceCubit, EntranceState>(
                //   listener: (context, state) {
                //     if (state is EntranceError) {
                //       NotifierService.showMessage(
                //         context,
                //         message: state.message,
                //         type: MessageType.error,
                //       );
                //     } else if (state is EntranceAddResponse ||
                //         state is EntranceUpdateResponse) {
                //       final id = StringHelper.removeCurlyBracesFromString(
                //           (state as EntranceAddResponse).buildingGlboalId);
                //       context
                //           .read<AttributesCubit>()
                //           .showBuildingAttributes(id);
                //     }
                //   },
                //   child: const SizedBox.shrink(),
                // ),
                // BlocListener<DwellingCubit, DwellingState>(
                //   listener: (context, state) {
                //     if (state is DwellingError) {
                //       NotifierService.showMessage(
                //         context,
                //         message: state.message,
                //         type: MessageType.error,
                //       );
                //     } else if (state is DwellingUpdateResponse) {
                //       NotifierService.showMessage(
                //         context,
                //         messageKey: state.isAdded
                //             ? Keys.dwellingUpdated
                //             : Keys.dwellingCouldNotUpdated,
                //         type: state.isAdded
                //             ? MessageType.success
                //             : MessageType.warning,
                //       );
                //     } else if (state is DwellingAddResponse) {
                //       NotifierService.showMessage(
                //         context,
                //         messageKey: state.isAdded
                //             ? Keys.dwellingAdded
                //             : Keys.dwellingCouldNotAdd,
                //         type: state.isAdded
                //             ? MessageType.success
                //             : MessageType.warning,
                //       );
                //     }
                //   },
                //   child: const SizedBox.shrink(),
                // ),
                DwellingForm(onSave: _onSave),
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
                    return (state is Attributes && !state.showAttributes)
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
