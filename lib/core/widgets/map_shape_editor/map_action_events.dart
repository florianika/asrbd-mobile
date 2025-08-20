import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/core/widgets/button/floating_button.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/domain/entities/save_result.dart';
import 'package:asrdb/features/home/cubit/building_geometry_cubit.dart';
import 'package:asrdb/features/home/cubit/entrance_geometry_cubit.dart';
import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/loading_cubit.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class MapActionEvents extends StatefulWidget {
  final MapController mapController;

  const MapActionEvents({
    super.key,
    required this.mapController,
  });

  @override
  State<MapActionEvents> createState() => _MapActionEventsState();
}

class _MapActionEventsState extends State<MapActionEvents> {
  Future<void> _saveEntrance() async {
    final geometryEditor = context.read<GeometryEditorCubit>();
    final loadingCubit = context.read<LoadingCubit>();
    final attributeCubit = context.read<AttributesCubit>();

    loadingCubit.show();

    EntranceEntity? entrance = geometryEditor.entranceCubit.currentEntrance;
    entrance ??=
        EntranceEntity(coordinates: widget.mapController.camera.center);

    final entranceUseCase = sl<EntranceUseCases>();
    final offlineMode = false;

    try {
      SaveResult response =
          await entranceUseCase.saveEntrance(entrance, offlineMode);

      widget.mapController.move(widget.mapController.camera.center,
          widget.mapController.camera.zoom + 0.3);

      loadingCubit.hide();

      await attributeCubit.showEntranceAttributes(response.data, null);
      if (mounted) {
        NotifierService.showMessage(
          context,
          message:
              '${AppLocalizations.of(context).translate(response.key)} ${response.data != null ? '- Referenca: ${response.data}' : ''}',
          type: response.success ? MessageType.success : MessageType.error,
        );
      }
    } on Exception catch (e) {
      loadingCubit.hide();
      if (!mounted) return;
      NotifierService.showMessage(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
    } finally {
      geometryEditor.saveChanges();
    }
  }

  void _addPoint() {
    final geometryEditor = context.read<GeometryEditorCubit>();

    if (geometryEditor.selectedType == EntityType.building) {
      geometryEditor.buildingCubit.addPoint(widget.mapController.camera.center);
    } else if (geometryEditor.selectedType == EntityType.entrance) {
      geometryEditor.entranceCubit.addPoint(widget.mapController.camera.center);
    }
  }

  Future<void> _saveBuilding() async {
    final buildingUseCase = sl<BuildingUseCases>();
    final geometryEditor = context.read<GeometryEditorCubit>();
    final attributeCubit = context.read<AttributesCubit>();
    final loadingCubit = context.read<LoadingCubit>();
    final offlineMode = false;

    try {
      loadingCubit.show();
      BuildingEntity? building = geometryEditor.buildingCubit.currentBuilding;

      if (building == null) {
        NotifierService.showMessage(
          context,
          message: 'No building to save',
          type: MessageType.warning,
        );
        return;
      }

      SaveResult response = await buildingUseCase.saveBuilding(
        building,
        offlineMode,
      );

      widget.mapController.move(widget.mapController.camera.center,
          widget.mapController.camera.zoom + 0.3);

      loadingCubit.hide();

      await attributeCubit.showBuildingAttributes(response.data);

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
    } finally {
      geometryEditor.saveChanges();
    }
  }

  void _clearCurrentGeometry() {
    final geometryEditor = context.read<GeometryEditorCubit>();
    geometryEditor.deleteSelected();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeometryEditorCubit, GeometryEditorState>(
      builder: (context, editorState) {
        // Listen to both entrance and building cubit states for UI updates
        return BlocBuilder<EntranceGeometryCubit, EntranceGeometryState>(
          builder: (context, entranceState) {
            return BlocBuilder<BuildingGeometryCubit, BuildingGeometryState>(
              builder: (context, buildingState) {
                final geometryEditor = context.watch<GeometryEditorCubit>();

                // Determine current state based on selected type
                final isDrawing =
                    geometryEditor.selectedType == EntityType.entrance
                        ? (entranceState is EntranceGeometry
                            ? entranceState.isDrawing
                            : false)
                        : (buildingState is BuildingGeometry
                            ? buildingState.isDrawing
                            : false);

                final isMovingPoint =
                    geometryEditor.selectedType == EntityType.entrance
                        ? (entranceState is EntranceGeometry
                            ? entranceState.isMovingPoint
                            : false)
                        : (buildingState is BuildingGeometry
                            ? buildingState.isMovingPoint
                            : false);

                return Stack(
                  children: [
                    // Center crosshair for drawing
                    if (isDrawing && !isMovingPoint)
                      IgnorePointer(
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.2),
                              border: Border.all(
                                color: geometryEditor.selectedType ==
                                        EntityType.entrance
                                    ? Colors.red
                                    : Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Action buttons
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Undo button
                          FloatingButton(
                            icon: Icons.undo,
                            heroTag: 'undo',
                            onPressed: geometryEditor.canUndo
                                ? () => geometryEditor.undo()
                                : null,
                            isEnabled: geometryEditor.canUndo,
                          ),

                          const SizedBox(height: 20),

                          // Redo button
                          FloatingButton(
                            icon: Icons.redo,
                            heroTag: 'redo',
                            isEnabled: geometryEditor.canRedo,
                            onPressed: geometryEditor.canRedo
                                ? () => geometryEditor.redo()
                                : null,
                          ),

                          const SizedBox(height: 20),

                          // Done/Finish button
                          FloatingButton(
                            icon: Icons.save,
                            heroTag: 'save',
                            onPressed: () {
                              if (geometryEditor.selectedType ==
                                  EntityType.entrance) {
                                _saveEntrance();
                              } else if (geometryEditor.selectedType ==
                                  EntityType.building) {
                                _saveBuilding();
                              }
                            },
                            isEnabled: geometryEditor.canSave,
                          ),

                          const SizedBox(height: 20),
                          FloatingButton(
                            icon: Icons.add_location_alt_outlined,
                            heroTag: 'pin',
                            isEnabled: geometryEditor.canAddPoint,
                            onPressed: _addPoint,
                          ),

                          const SizedBox(height: 20),

                          // Delete/Clear button
                          FloatingButton(
                            icon: Icons.close,
                            heroTag: 'close',
                            isEnabled: true,
                            onPressed: _clearCurrentGeometry,
                          ),
                        ],
                      ),
                    ),

                    // Mode indicator (optional)
                    if (geometryEditor.isEditing)
                      Positioned(
                        top: 50,
                        left: 20,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${geometryEditor.selectedType == EntityType.entrance ? "Entrance" : "Building"} ${geometryEditor.mode == EditorMode.create ? "Creation" : "Edit"} Mode',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
