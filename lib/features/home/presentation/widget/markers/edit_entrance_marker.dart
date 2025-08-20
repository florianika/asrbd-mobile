import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:asrdb/features/home/cubit/entrance_geometry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EditEntranceMarker extends StatelessWidget {
  final MapController mapController;
  final GlobalKey mapKey;

  final draggedMarkerSize = 40.0;

  const EditEntranceMarker({
    super.key,
    required this.mapController,
    required this.mapKey,
  });

  Marker _buildMarkers(LatLng point, BuildContext context) {
    const opacity = 0.5;

    return Marker(
      width: 32,
      height: 32,
      point: point,
      child: Draggable<LatLng>(
        data: point,
        onDragStarted: () {
          // ✅ Use GeometryEditorCubit to set moving state
          final geometryEditor = context.read<GeometryEditorCubit>();
          geometryEditor.entranceCubit.setMovingPoint(true);
        },
        onDragEnd: (details) {
          // ✅ Reset moving state through GeometryEditorCubit
          final geometryEditor = context.read<GeometryEditorCubit>();
          geometryEditor.entranceCubit.setMovingPoint(false);
        },
        feedback: Transform.translate(
          offset: const Offset(0, -60),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: draggedMarkerSize,
              height: draggedMarkerSize,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withValues(alpha: opacity),
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
                Icons.flag,
                color: Colors.white.withValues(alpha: opacity),
                size: 20,
              ),
            ),
          ),
        ),
        feedbackOffset: const Offset(0, 0),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withValues(alpha: opacity * 0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.flag,
            color: Colors.white.withValues(alpha: opacity),
            size: 16,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withValues(alpha: opacity),
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
            Icons.flag,
            color: Colors.white.withValues(alpha: opacity),
            size: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeometryEditorCubit, GeometryEditorState>(
      builder: (context, editorState) {
        final geometryEditor = context.watch<GeometryEditorCubit>();

        // Only show entrance editing when entrance is selected
        if (geometryEditor.selectedType != EntityType.entrance) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<EntranceGeometryCubit, EntranceGeometryState>(
          bloc: geometryEditor.entranceCubit,
          builder: (context, entranceState) {
            if (entranceState is EntranceGeometry) {
              // ✅ Get point from the entrance cubit through geometry editor
              final point = geometryEditor.entranceCubit.point;

              if (point == null) {
                return const SizedBox.shrink();
              }

              return Stack(
                children: [
                  // Drop target for the entire map area
                  DragTarget<LatLng>(
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

                        // ✅ Update the entrance point position through GeometryEditorCubit
                        geometryEditor.entranceCubit.updatePoint(latLng);
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return MarkerLayer(
                        markers: [
                          _buildMarkers(point, context),
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
