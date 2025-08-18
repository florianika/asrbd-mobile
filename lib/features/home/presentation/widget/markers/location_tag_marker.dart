import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MarkerType { entrance, building }

class LocationTagMarker extends StatelessWidget {
  final bool isActive;

  const LocationTagMarker({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Use BlocBuilder to listen to state changes
    return BlocBuilder<GeometryEditorCubit, GeometryEditorState>(
      builder: (context, state) {
        final geometryCubit = context.read<GeometryEditorCubit>();

        // Don't show marker in view mode or edit mode for entrance
        if (geometryCubit.mode == EditorMode.view ||
            (geometryCubit.mode == EditorMode.edit &&
                geometryCubit.selectedType == EntityType.entrance)) {
          return const SizedBox.shrink();
        }

        final borderColor = geometryCubit.selectedType == EntityType.entrance
            ? Colors.green
            : Colors.blue;
        final fillColor = geometryCubit.selectedType == EntityType.entrance
            ? Colors.green.withValues(alpha: 0.3)
            : Colors.blue.withValues(alpha: 0.3);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing ring when active
            if (isActive)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.2),
                duration: const Duration(milliseconds: 1000),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Main circular marker
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 3,
                ),
                color: fillColor,
                boxShadow: [
                  BoxShadow(
                    color: isActive
                        ? borderColor.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.2),
                    blurRadius: isActive ? 20 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Horizontal line of cross
                  Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                  // Vertical line of cross
                  Container(
                    width: 3,
                    height: 24,
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
