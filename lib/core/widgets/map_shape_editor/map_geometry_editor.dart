import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/cubit/location_accuracy_cubit.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/widgets/button/floating_button.dart';
import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
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

              final localizations = AppLocalizations.of(context);
              String tooltip;
              if (!isIdle) {
                tooltip =
                    localizations.translate(Keys.tooltipFinishEdit);
              } else if (hasOpenForm) {
                tooltip =
                    localizations.translate(Keys.tooltipCloseForm);
              } else {
                tooltip = localizations.translate(Keys.tooltipAddBuilding);
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

              // Button is enabled when a building is selected, regardless of GPS accuracy
              // GPS accuracy may be needed when placing the point, but not for initial button activation
              final isEnabled = isEditingEntrance || hasBuildingSelected;

              final localizations = AppLocalizations.of(context);
              String tooltip;
              if (!hasBuildingSelected && !isEditingEntrance) {
                tooltip =
                    localizations.translate(Keys.tooltipSelectBuildingForEntrance);
              } else {
                tooltip = localizations.translate(Keys.tooltipAddEntrance);
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
