import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/enums/message_type.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/notifier_service.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class BuildingsMarker extends StatelessWidget {
  final String attributeLegend;
  final MapController mapController;

  const BuildingsMarker({
    super.key,
    required this.attributeLegend,
    required this.mapController,
  });

  static final _legendService = sl<LegendService>();

  // ✅ Add polygon caching to prevent recreation
  static final Map<String, Polygon> _polygonCache = {};

  // ✅ Track last known building list to avoid unnecessary entrance calls
  static List<String>? _lastBuildingIds;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BuildingCubit, BuildingState>(
      listener: (context, state) {
        if (state is BuildingError) {
          NotifierService.showMessage(
            context,
            message: state.message,
            type: MessageType.error,
          );
        } else if (state is Buildings && state.buildings.isNotEmpty) {
          final buildingIds = state.buildings
              .map((building) => building.globalId)
              .whereType<String>()
              .where((id) => id.isNotEmpty)
              .toList();

          // ✅ Only call getEntrances if building list actually changed
          if (buildingIds.isNotEmpty &&
              !_listEquals(buildingIds, _lastBuildingIds)) {
            _lastBuildingIds = List.from(buildingIds);

            // ✅ Debounce entrance calls to avoid rapid fire
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                context.read<EntranceCubit>().getEntrances(
                      mapController.camera.zoom,
                      buildingIds,
                    );
              }
            });
          }
        }
      },
      // ✅ Much stricter buildWhen - only rebuild when building data meaningfully changes
      buildWhen: (previous, current) {
        // Don't rebuild on loading states
        if (current is BuildingLoading) return false;

        if (previous is Buildings && current is Buildings) {
          // Only rebuild if:
          // 1. Number of buildings changed significantly
          // 2. Building IDs actually changed (not just reordered)
          if ((previous.buildings.length - current.buildings.length).abs() >
              2) {
            return true;
          }

          // Check if building IDs are actually different
          final prevIds = previous.buildings.map((b) => b.globalId).toSet();
          final currIds = current.buildings.map((b) => b.globalId).toSet();

          return prevIds.length != currIds.length ||
              !prevIds.containsAll(currIds);
        }

        // Only rebuild when going from empty to data or vice versa
        return (previous is! Buildings && current is Buildings) ||
            (previous is Buildings && current is! Buildings);
      },
      builder: (context, state) {
        if (state is! Buildings || state.buildings.isEmpty) {
          // ✅ Clear cache when no buildings
          _polygonCache.clear();
          return const SizedBox.shrink();
        }

        final validBuildings = state.buildings
            .where((building) =>
                building.coordinates.isNotEmpty &&
                building.coordinates.first.isNotEmpty &&
                building.globalId != null)
            .toList();

        if (validBuildings.isEmpty) {
          return const SizedBox.shrink();
        }

        return PolygonLayer(
          polygons: validBuildings
              .map((building) => _getCachedPolygon(building, context))
              .where((polygon) => polygon.points.isNotEmpty)
              .toList(),
        );
      },
    );
  }

  // ✅ Cached polygon creation
  Polygon _getCachedPolygon(dynamic building, BuildContext context) {
    final value =
        attributeLegend == 'quality' ? building.bldQuality : building.bldReview;

    if (value == null) {
      return Polygon(points: []);
    }

    // ✅ Create cache key that includes both building and attribute legend
    final cacheKey = '${building.globalId}_${attributeLegend}_$value';

    return _polygonCache.putIfAbsent(cacheKey, () {
      try {
        final fillColor = (_legendService.getColorForValue(
                  LegendType.building,
                  attributeLegend,
                  value,
                ) ??
                Colors.black)
            .withValues(alpha: 0.5);

        return Polygon(
          hitValue: building.globalId,
          points: building.coordinates.first,
          color: fillColor,
          borderStrokeWidth: 1.0,
          borderColor: Colors.blue.withValues(alpha: 0.3),
        );
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            NotifierService.showMessage(
              context,
              message: 'Error rendering building: ${e.toString()}',
              type: MessageType.error,
            );
          }
        });
        return Polygon(points: []);
      }
    });
  }

  // ✅ Helper to compare lists
  bool _listEquals(List<String>? list1, List<String>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;

    final set1 = list1.toSet();
    final set2 = list2.toSet();
    return set1.length == set2.length && set1.containsAll(set2);
  }

  // ✅ Call this method periodically to prevent memory leaks
  static void clearCache() {
    _polygonCache.clear();
    _lastBuildingIds = null;
  }
}
