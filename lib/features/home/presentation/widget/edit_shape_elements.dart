import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EditShapeElements extends StatelessWidget {
  final Function handleEntranceTap;
  final Map<String, dynamic> initialData;
  final MapController mapController;
  final GlobalKey mapKey;

  final draggedMarkerSize = 40.0;

  const EditShapeElements({
    super.key,
    required this.handleEntranceTap,
    required this.initialData,
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
        child: Draggable<int>(
          data: index,
          feedback: Transform.translate(
            offset: const Offset(0, -60), // Move 60px above finger
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: draggedMarkerSize,
                height: draggedMarkerSize,
                decoration: BoxDecoration(
                  color: isFirstPoint
                      ? const Color(0xFF2196F3).withOpacity(opacity)
                      : const Color(0xFF4CAF50).withOpacity(opacity),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  isFirstPoint ? Icons.flag : Icons.circle,
                  color: Colors.white.withOpacity(opacity),
                  size: isFirstPoint ? 20 : 16,
                ),
              ),
            ),
          ),
          feedbackOffset: const Offset(0, 0),
          childWhenDragging: Container(
            decoration: BoxDecoration(
              color: (isFirstPoint
                      ? const Color(0xFF2196F3).withOpacity(opacity)
                      : const Color(0xFF4CAF50).withOpacity(opacity))
                  .withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              isFirstPoint ? Icons.flag : Icons.circle,
              color: Colors.white.withOpacity(opacity),
              size: isFirstPoint ? 16 : 12,
            ),
          ),
          child: GestureDetector(
            onTap: () => handleEntranceTap(initialData),
            child: Container(
              decoration: BoxDecoration(
                color: isFirstPoint
                    ? const Color(0xFF2196F3).withOpacity(opacity)
                    : const Color(0xFF4CAF50).withOpacity(opacity),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isFirstPoint ? Icons.flag : Icons.circle,
                color: Colors.white.withOpacity(opacity),
                size: isFirstPoint ? 16 : 12,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewGeometryCubit, NewGeometryState>(
      builder: (context, state) {
        final points = (state as NewGeometry).points;

        return Stack(
          children: [
            // Drop target for the entire map area
            DragTarget<int>(
              onAcceptWithDetails: (details) {
                final RenderBox? renderBox =
                    mapKey.currentContext?.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  final localPosition = renderBox.globalToLocal(details.offset);

                  // Fix drop offset to match where the marker appears during drag
                  final adjustedPosition = localPosition.translate(
                      draggedMarkerSize / 2,
                      -60 + draggedMarkerSize / 2); // 16 = 32 / 2

                  final latLng =
                      mapController.camera.offsetToCrs(adjustedPosition);

                  context
                      .read<NewGeometryCubit>()
                      .updatePointPosition(details.data, latLng);
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Stack(
                  children: [
                    if (points.isNotEmpty)
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: points,
                            color: const Color(0xFF2196F3).withOpacity(0.15),
                            borderStrokeWidth: 2.5,
                            borderColor: const Color(0xFF1976D2),
                            pattern: points.length < 3
                                ? StrokePattern.dashed(segments: const [8, 4])
                                : const StrokePattern.solid(),
                          ),
                        ],
                      ),
                    MarkerLayer(markers: _buildMarkers(points, context)),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
