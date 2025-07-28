import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/widgets/button/floating_button.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class MapActionEvents extends StatefulWidget {
  final MapController mapController;

  const MapActionEvents({
    super.key,
    required this.mapController,
  });

  @override
  State<MapActionEvents> createState() => _MapActionEventsState();
}

class _MapActionEventsState extends State<MapActionEvents> {
  final _isDrawingMarker = true;

  void _placeMarker() {
    final center = widget.mapController.camera.center;
    context.read<NewGeometryCubit>().addPoint(center);
  }

  @override
  Widget build(BuildContext context) {
    final currentBuildingGlobalId =
        context.watch<AttributesCubit>().currentBuildingGlobalId;
    return BlocConsumer<NewGeometryCubit, NewGeometryState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Stack(
            children: [
              if (_isDrawingMarker &&
                  !((state as NewGeometry).isMovingPoint &&
                      (state).type == ShapeType.point))
                IgnorePointer(
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.2),
                        border: Border.all(
                          color: (state as NewGeometry).type == ShapeType.point
                              ? Colors.red
                              : Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingButton(
                      icon: Icons.undo,
                      heroTag: 'undo',
                      onPressed: context.read<NewGeometryCubit>().undo,
                      isEnabled: ((state as NewGeometry)).points.isNotEmpty,
                    ),
                    const SizedBox(height: 20),
                    FloatingButton(
                      icon: Icons.redo,
                      heroTag: 'redo',
                      isEnabled: true,
                      onPressed: context.read<NewGeometryCubit>().redo,
                    ),
                    const SizedBox(height: 20),
                    FloatingButton(
                      icon: Icons.check,
                      heroTag: 'done',
                      onPressed: () => {
                        context.read<NewGeometryCubit>().setDrawing(false),
                        context.read<NewGeometryCubit>().setMovingPoint(false),
                        if (state.type == ShapeType.point)
                          {
                            _placeMarker(),
                            context
                                .read<AttributesCubit>()
                                .showEntranceAttributes(
                                    null, currentBuildingGlobalId)
                          }
                        else if (state.type == ShapeType.polygon)
                          {
                            context
                                .read<AttributesCubit>()
                                .showBuildingAttributes(currentBuildingGlobalId)
                          },
                      },
                      isEnabled: (((state).points.length > 2 &&
                              (state).type != ShapeType.point) ||
                          (state).type == ShapeType.point),
                      isVisible: !((state).isMovingPoint &&
                          (state).type == ShapeType.point),
                    ),
                    if (state.type == ShapeType.polygon) ...[
                      const SizedBox(height: 20),
                      FloatingButton(
                        icon: Icons.add_location_alt_outlined,
                        heroTag: 'pin',
                        isEnabled: true,
                        onPressed: _placeMarker,
                      ),
                    ],
                    const SizedBox(height: 20),
                    FloatingButton(
                        icon: Icons.delete,
                        heroTag: 'x',
                        isEnabled: true,
                        onPressed: () => {
                              context.read<NewGeometryCubit>().clearPoints(),
                              context
                                  .read<NewGeometryCubit>()
                                  .setDrawing(false),
                              context
                                  .read<NewGeometryCubit>()
                                  .setMovingPoint(false),
                            }),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
