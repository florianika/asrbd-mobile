import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/widgets/button/floating_button.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class MapActionEvents extends StatefulWidget {
  final MapController mapController;
  final Function onSave;

  const MapActionEvents({
    super.key,
    required this.mapController,
    required this.onSave,
  });

  @override
  State<MapActionEvents> createState() => _MapActionEventsState();
}

class _MapActionEventsState extends State<MapActionEvents> {
  bool _isDrawingMarker = true;

  void _placeMarker() {
    final center = widget.mapController.camera.center;

    context.read<NewGeometryCubit>().addPoint(center);
  }

  void _save() {
    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewGeometryCubit, NewGeometryState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Stack(
            children: [
              if (_isDrawingMarker)
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
                      //  widget.newPolygonPoints.isNotEmpty &&
                      //         widget.onUndo != null
                      //     ? () => widget.onUndo!()
                      //     : null,
                      isEnabled: ((state as NewGeometry))
                          .points
                          .isNotEmpty, // widget.newPolygonPoints.isNotEmpty,
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
                        _placeMarker(),
                        context
                            .read<AttributesCubit>()
                            .showBuildingAttributes(null),
                        context
                            .read<AttributesCubit>()
                            .showEntranceAttributes(null),
                        // if (state.type == ShapeType.point)
                        //   _save()
                        // else if (state.points.length > 2)
                        //   _save()
                      },
                      isEnabled: (((state).points.length > 2 &&
                              (state).type != ShapeType.point) ||
                          (state).type == ShapeType.point),
                    ),
                    if (state.type == ShapeType.polygon) ...[
                      const SizedBox(height: 20),
                      FloatingButton(
                        icon: Icons.edit_location_alt,
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
                            }),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
