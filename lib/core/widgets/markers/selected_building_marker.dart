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
      Color.fromRGBO(255, 255, 0, 1); // Colors.red with alpha 0.7
  static const Color _borderColor = Color.fromRGBO(130, 127, 0, 1);
  static const double _borderWidth = 12.0;

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
            highlightBuildingGlobalId == null) {
          return false;
        }

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
        if ((selectedBuildingGlobalId == null &&
                highlightBuildingGlobalId == null) ||
            state is! Buildings) {
          return const SizedBox.shrink();
        }

        final polygons = <Polygon>[];

        // Determine which building to draw
        final idToUse = highlightBuildingGlobalId ?? selectedBuildingGlobalId;
        final building = _findBuilding(state.buildings, idToUse!);

        if (building != null &&
            building.coordinates.isNotEmpty &&
            building.coordinates.first.isNotEmpty) {
          final isHighlighted = highlightBuildingGlobalId != null &&
              highlightBuildingGlobalId == building.globalId;

          polygons.add(
            Polygon(
              hitValue: building.globalId,
              points: building.coordinates.first,
              color: _fillColor, // always yellow
              borderStrokeWidth: isHighlighted ? 0 : _borderWidth,
              borderColor: isHighlighted ? Colors.transparent : _borderColor,
            ),
          );
        }

        if (polygons.isEmpty) return const SizedBox.shrink();
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
