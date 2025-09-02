import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:asrdb/features/home/cubit/building_geometry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EditBuildingMarker extends StatelessWidget {
  final MapController mapController;
  final GlobalKey mapKey;

  final draggedMarkerSize = 40.0;

  const EditBuildingMarker({
    super.key,
    required this.mapController,
    required this.mapKey,
  });

  List<Marker> _buildMarkers(List<LatLng> points, BuildContext context) {
    return points.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      final isFirstPoint = index == 0;
      const opacity = 0.5;

      return Marker(
        width: 32,
        height: 32,
        point: point,
        child: Draggable<MapDragData>(
          data: MapDragData(index: index, point: point),
          onDragStarted: () {
            // Set moving state through GeometryEditorCubit
            final geometryEditor = context.read<GeometryEditorCubit>();
            geometryEditor.setBuildingMoving(true);
          },
          onDragEnd: (details) {
            // Reset moving state through GeometryEditorCubit
            final geometryEditor = context.read<GeometryEditorCubit>();
            geometryEditor.setBuildingMoving(false);
          },
          feedback: Transform.translate(
            offset: const Offset(0, -60),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: draggedMarkerSize,
                height: draggedMarkerSize,
                decoration: BoxDecoration(
                  color: isFirstPoint
                      ? const Color(0xFF2196F3).withValues(alpha: opacity)
                      : const Color(0xFF4CAF50).withValues(alpha: opacity),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  isFirstPoint ? Icons.flag : Icons.circle,
                  color: Colors.white.withValues(alpha: opacity),
                  size: isFirstPoint ? 20 : 16,
                ),
              ),
            ),
          ),
          feedbackOffset: const Offset(0, 0),
          childWhenDragging: Container(
            decoration: BoxDecoration(
              color: (isFirstPoint
                      ? const Color(0xFF2196F3).withValues(alpha: opacity)
                      : const Color(0xFF4CAF50).withValues(alpha: opacity))
                  .withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Icon(
              isFirstPoint ? Icons.flag : Icons.circle,
              color: Colors.white.withValues(alpha: opacity),
              size: isFirstPoint ? 16 : 12,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isFirstPoint
                  ? const Color(0xFF2196F3).withValues(alpha: opacity)
                  : const Color(0xFF4CAF50).withValues(alpha: opacity),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isFirstPoint ? Icons.flag : Icons.circle,
              color: Colors.white.withValues(alpha: opacity),
              size: isFirstPoint ? 16 : 12,
            ),
          ),
        ),
      );
    }).toList();
  }

  // Create markers for midpoints between existing points (for adding new points)
  List<Marker> _buildMidpointMarkers(
      List<LatLng> points, BuildContext context) {
    if (points.length < 2) return [];

    List<Marker> midpointMarkers = [];

    for (int i = 0; i < points.length; i++) {
      final currentPoint = points[i];
      final nextPoint =
          points[(i + 1) % points.length]; // Wrap around for polygon

      // Calculate midpoint
      final midLat = (currentPoint.latitude + nextPoint.latitude) / 2;
      final midLng = (currentPoint.longitude + nextPoint.longitude) / 2;
      final midpoint = LatLng(midLat, midLng);

      midpointMarkers.add(
        Marker(
          width: 20,
          height: 20,
          point: midpoint,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // Add new point at midpoint position
              final geometryEditor = context.read<GeometryEditorCubit>();
              final buildingCubit = geometryEditor.buildingCubit;

              // Create new points list with the new point inserted
              final newPoints = List<LatLng>.from(buildingCubit.points);
              newPoints.insert(i + 1, midpoint);

              buildingCubit.setState(points: newPoints, saveToUndo: true);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ),
      );
    }

    return midpointMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeometryEditorCubit, GeometryEditorState>(
      builder: (context, editorState) {
        final geometryEditor = context.read<GeometryEditorCubit>();

        // Only show building editing when building is selected
        if (geometryEditor.selectedType != EntityType.building) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<BuildingGeometryCubit, BuildingGeometryState>(
          bloc: geometryEditor.buildingCubit,
          builder: (context, buildingState) {
            if (buildingState is BuildingGeometry) {
              final points = geometryEditor.buildingCubit.points;

              if (points.isEmpty) {
                return const SizedBox.shrink();
              }

              return Stack(
                children: [
                  // Drop target for the entire map area
                  DragTarget<MapDragData>(
                    onAcceptWithDetails: (details) {
                      final RenderBox? renderBox = mapKey.currentContext
                          ?.findRenderObject() as RenderBox?;
                      if (renderBox != null) {
                        final localPosition =
                            renderBox.globalToLocal(details.offset);

                        // Fix drop offset to match where the marker appears during drag
                        final adjustedPosition = localPosition.translate(
                            draggedMarkerSize / 2, -60 + draggedMarkerSize / 2);

                        final latLng =
                            mapController.camera.offsetToCrs(adjustedPosition);

                        // Update the building point position through GeometryEditorCubit
                        geometryEditor.updateBuildingPoint(
                          details.data.index,
                          latLng,
                          saveToUndo: true,
                        );
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Stack(
                        children: [
                          // Polygon layer
                          if (points.isNotEmpty)
                            PolygonLayer(
                              polygons: [
                                Polygon(
                                  points: points,
                                  color: const Color(0xFF2196F3)
                                      .withValues(alpha: 0.15),
                                  borderStrokeWidth: 2.5,
                                  borderColor: const Color(0xFF1976D2),
                                  pattern: points.length < 3
                                      ? StrokePattern.dashed(
                                          segments: const [8, 4])
                                      : const StrokePattern.solid(),
                                ),
                              ],
                            ),

                          // Main point markers
                          MarkerLayer(markers: _buildMarkers(points, context)),

                          // Midpoint markers for adding new points (only if more than 2 points)
                          // if (points.length >= 3 &&
                          //     !geometryEditor.buildingCubit.isMovingPoint)
                          if (points.length >= 3)
                            MarkerLayer(
                                markers:
                                    _buildMidpointMarkers(points, context)),
                        ],
                      );
                    },
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

// Helper class for drag data
class MapDragData {
  final int index;
  final LatLng point;

  MapDragData({required this.index, required this.point});
}
