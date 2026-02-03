import 'package:asrdb/core/config/app_config.dart';import 'package:asrdb/core/cubit/location_accuracy_cubit.dart';import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/widgets/button/floating_button.dart';
import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class MapGeometryEditor extends StatelessWidget {
  final MapController mapController;
  const MapGeometryEditor({
    super.key,
    required this.mapController,
  });

  void _goToCurrentLocation() async {
    final location = await LocationService.getCurrentLocation();
    mapController.move(location, AppConfig.initZoom);
  }

  @override
  Widget build(BuildContext context) {
    final attributeContext = context.watch<AttributesCubit>();
    
    return Stack(
      children: [
        Positioned(
          bottom: 270,
          left: 20,
          child: FloatingButton(
            heroTag: 'zoom_in',
            isEnabled: true,
            onPressed: () {
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom + 1);
            },
            icon: Icons.zoom_in,
          ),
        ),
        Positioned(
          bottom: 210,
          left: 20,
          child: FloatingButton(
            heroTag: 'zoom_out',
            isEnabled: true,
            onPressed: () {
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom - 1);
            },
            icon: Icons.zoom_out,
          ),
        ),
        Positioned(
            bottom: 150,
            left: 20,
            child: FloatingButton(
              heroTag: 'locate_me',
              isEnabled: true,
              onPressed: _goToCurrentLocation,
              icon: Icons.my_location,
            )),
        Positioned(
          bottom: 90,
          left: 20,
          child: Builder(
            builder: (context) {
              final geometryEditor = context.watch<GeometryEditorCubit>();
              final hasOpenForm = attributeContext.isShowingAttributes;
              final isIdle = geometryEditor.mode == EditorMode.view;
              final isEnabled = isIdle && !hasOpenForm;

              String tooltip;
              if (!isIdle) {
                tooltip = 'Finish the current edit before adding a new building';
              } else if (hasOpenForm) {
                tooltip = 'Close the current form before adding a new building';
              } else {
                tooltip = 'Add Building';
              }

              return FloatingButton(
                heroTag: 'rectangle',
                isEnabled: isEnabled,
                onPressed: isEnabled
                    ? () {
                        context
                            .read<GeometryEditorCubit>()
                            .startCreatingBuilding();
                      }
                    : null,
                icon: Icons.hexagon_outlined,
                tooltip: tooltip,
              );
            },
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          child: Builder(
            builder: (context) {
              final geometryEditor = context.watch<GeometryEditorCubit>();
              final locationState = context.watch<LocationAccuracyCubit>().state;
              final isEditingEntrance =
                  geometryEditor.selectedType == EntityType.entrance;
              final hasBuildingSelected =
                  attributeContext.currentBuildingGlobalId != null &&
                      attributeContext.shapeType == ShapeType.polygon &&
                      attributeContext.isShowingAttributes;

              // Check GPS accuracy
              final hasAccurateGPS = locationState is LocationAccuracyUpdated &&
                  locationState.isAccurate;

              final isEnabled = (isEditingEntrance || hasBuildingSelected) && hasAccurateGPS;

              String tooltip;
              if (!hasBuildingSelected && !isEditingEntrance) {
                tooltip = 'Select a building first to add entrance';
              } else if (!hasAccurateGPS) {
                if (locationState is LocationAccuracyUpdated) {
                  tooltip = 'GPS accuracy too low (${locationState.accuracy.toStringAsFixed(1)}m). Need ≤10m';
                } else {
                  tooltip = 'Waiting for GPS signal...';
                }
              } else {
                tooltip = 'Add Entrance';
              }

              return FloatingButton(
                heroTag: 'entrance',
                onPressed: isEnabled
                    ? () {
                        if (!isEditingEntrance) {
                          context
                              .read<GeometryEditorCubit>()
                              .startCreatingEntrance();
                          context
                              .read<AttributesCubit>()
                              .toggleAttributesVisibility(false);
                        }
                      }
                    : null,
                isEnabled: isEnabled,
                icon: Icons.adjust,
                tooltip: tooltip,
              );
            },
          ),
        ),
      ],
    );
  }
}
