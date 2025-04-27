import 'package:asrdb/core/enums/shape_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapActionButtons extends StatelessWidget {
  final MapController mapController;
  final Function enableDrawing;
  const MapActionButtons(
      {super.key, required this.mapController, required this.enableDrawing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: 'zoom_in',
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () {
            mapController.move(
                mapController.camera.center, mapController.camera.zoom + 1);
          },
          child: const Icon(Icons.zoom_in),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'zoom_out',
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () {
            mapController.move(
                mapController.camera.center, mapController.camera.zoom - 1);
          },
          child: const Icon(Icons.zoom_out),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'rectangle',
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () => enableDrawing(ShapeType.polygon),
          child: const Icon(Icons.rectangle_outlined),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'entrance',
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () => enableDrawing(ShapeType.point),
          child: const Icon(Icons.sensor_door_outlined),
        ),
      ],
    );
  }
}
