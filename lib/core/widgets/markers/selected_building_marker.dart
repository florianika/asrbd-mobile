import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class SelectedBuildingMarker extends StatelessWidget {
  final String? selectedBuildingGlobalId;
  final String? highlightBuildingGlobalId;

  const SelectedBuildingMarker({
    super.key,
    required this.selectedBuildingGlobalId,
    this.highlightBuildingGlobalId,
  });

  // ✅ Static styling properties to avoid recreation
  static const Color _fillColor =
      Color.fromRGBO(255, 0, 0, 0.7); // Colors.red with alpha 0.7
  static const Color _borderColor = Color.fromRGBO(215, 25, 11, 0.3);
  static const double _borderWidth = 8.0;

  // ✅ Highlight styling properties
  static const Color _highlightBorderColor = Color.fromRGBO(255, 0, 0, 0.8);
  static const double _highlightBorderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    // ✅ Early return if no building selected or highlighted
    if (selectedBuildingGlobalId == null && highlightBuildingGlobalId == null) {
      return const SizedBox.shrink();
    }

    return BlocConsumer<BuildingCubit, BuildingState>(
      // ✅ Handle errors in listener
      listener: (context, state) {
        if (state is BuildingError) {
          NotifierService.showMessage(
            context,
            message: state.message,
            type: MessageType.error,
          );
        }
      },
      // ✅ Only rebuild when our specific building changes
      buildWhen: (previous, current) {
        // Don't rebuild if no building is selected or highlighted
        if (selectedBuildingGlobalId == null &&
            highlightBuildingGlobalId == null) return false;

        // Only rebuild if the state type changes or the selected/highlighted building data changes
        if (previous.runtimeType != current.runtimeType) return true;

        if (previous is Buildings && current is Buildings) {
          bool shouldRebuild = false;

          // Check if selected building changed
          if (selectedBuildingGlobalId != null) {
            final prevSelectedBuilding =
                _findBuilding(previous.buildings, selectedBuildingGlobalId!);
            final currentSelectedBuilding =
                _findBuilding(current.buildings, selectedBuildingGlobalId!);

            if (prevSelectedBuilding != currentSelectedBuilding) {
              shouldRebuild = true;
            }
          }

          // Check if highlighted building changed
          if (highlightBuildingGlobalId != null) {
            final prevHighlightBuilding =
                _findBuilding(previous.buildings, highlightBuildingGlobalId!);
            final currentHighlightBuilding =
                _findBuilding(current.buildings, highlightBuildingGlobalId!);

            if (prevHighlightBuilding != currentHighlightBuilding) {
              shouldRebuild = true;
            }
          }

          return shouldRebuild;
        }

        return false;
      },
      builder: (context, state) {
        // ✅ Double-check null safety in builder
        if ((selectedBuildingGlobalId == null &&
                highlightBuildingGlobalId == null) ||
            state is! Buildings) {
          return const SizedBox.shrink();
        }

        List<Polygon> polygons = [];

        // ✅ Handle selected building (existing logic)
        if (selectedBuildingGlobalId != null) {
          final selectedBuilding =
              _findBuilding(state.buildings, selectedBuildingGlobalId!);

          if (selectedBuilding != null &&
              selectedBuilding.coordinates.isNotEmpty &&
              selectedBuilding.coordinates.first.isNotEmpty) {
            polygons.add(
              Polygon(
                hitValue: selectedBuilding.globalId,
                points: selectedBuilding.coordinates.first,
                color: _fillColor,
                borderStrokeWidth: _borderWidth,
                borderColor: _borderColor,
              ),
            );
          }
        }

        // ✅ Handle highlighted building (new glow effect logic)
        if (highlightBuildingGlobalId != null) {
          final highlightBuilding =
              _findBuilding(state.buildings, highlightBuildingGlobalId!);

          if (highlightBuilding != null &&
              highlightBuilding.coordinates.isNotEmpty &&
              highlightBuilding.coordinates.first.isNotEmpty) {
            // Add multiple border glow layers (no fill color)
            // Outer glow layers with increasing border widths for stronger glow effect
            for (int i = 5; i >= 1; i--) {
              polygons.add(
                Polygon(
                  hitValue: highlightBuilding.globalId,
                  points: highlightBuilding.coordinates.first,
                  color: Colors.transparent, // No background fill
                  borderStrokeWidth: _highlightBorderWidth +
                      (i * 3.0), // Larger increments for stronger glow
                  borderColor: Color.fromRGBO(255, 0, 0,
                      0.6 - (i * 0.08)), // Higher opacity for stronger glow
                ),
              );
            }

            // Main highlighted polygon border (no fill)
            polygons.add(
              Polygon(
                hitValue: highlightBuilding.globalId,
                points: highlightBuilding.coordinates.first,
                color: Colors.transparent, // No background fill
                borderStrokeWidth: _highlightBorderWidth,
                borderColor: _highlightBorderColor,
              ),
            );
          }
        }

        // ✅ Return empty widget if no polygons to display
        if (polygons.isEmpty) {
          return const SizedBox.shrink();
        }

        return PolygonLayer(polygons: polygons);
      },
    );
  }

  // ✅ Safe building finder
  static BuildingEntity? _findBuilding(
      List<BuildingEntity> buildings, String globalId) {
    try {
      return buildings.firstWhere((building) => building.globalId == globalId);
    } catch (e) {
      return null; // Return null instead of throwing if not found
    }
  }
}
