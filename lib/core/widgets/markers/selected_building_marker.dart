import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class SelectedBuildingMarker extends StatelessWidget {
  final String? selectedBuildingGlobalId;

  const SelectedBuildingMarker({
    super.key,
    required this.selectedBuildingGlobalId,
  });

  // ✅ Static styling properties to avoid recreation
  static const Color _fillColor =
      Color.fromRGBO(255, 0, 0, 0.7); // Colors.red with alpha 0.7
  static const Color _borderColor = Color.fromRGBO(215, 25, 11, 0.3);
  static const double _borderWidth = 8.0;

  @override
  Widget build(BuildContext context) {
    // ✅ Early return if no building selected
    if (selectedBuildingGlobalId == null) {
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
        // Don't rebuild if no building is selected
        if (selectedBuildingGlobalId == null) return false;

        // Only rebuild if the state type changes or the selected building data changes
        if (previous.runtimeType != current.runtimeType) return true;

        if (previous is Buildings && current is Buildings) {
          // Find the selected building in both states
          final prevBuilding =
              _findBuilding(previous.buildings, selectedBuildingGlobalId!);
          final currentBuilding =
              _findBuilding(current.buildings, selectedBuildingGlobalId!);

          // Rebuild only if the selected building changed (added, removed, or modified)
          return prevBuilding != currentBuilding;
        }

        return false;
      },
      builder: (context, state) {
        // ✅ Double-check null safety in builder
        if (selectedBuildingGlobalId == null || state is! Buildings) {
          return const SizedBox.shrink();
        }

        // ✅ Safe building lookup with null-safe globalId
        final building =
            _findBuilding(state.buildings, selectedBuildingGlobalId!);
        if (building == null) {
          return const SizedBox.shrink();
        }

        // ✅ Validate building has coordinates
        if (building.coordinates.isEmpty ||
            building.coordinates.first.isEmpty) {
          return const SizedBox.shrink();
        }

        return PolygonLayer(
          polygons: [
            Polygon(
              hitValue: building.globalId,
              points: building.coordinates.first,
              color: _fillColor,
              borderStrokeWidth: _borderWidth,
              borderColor: _borderColor,
            ),
          ],
        );
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
