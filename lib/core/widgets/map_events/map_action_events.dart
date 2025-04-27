import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapActionEvents extends StatelessWidget {
  final Function? onUndo;
  final Function? onRedo;
  final Function? onSave;
  final Function? onClose;
  final List<LatLng> newPolygonPoints;

  const MapActionEvents(
      {super.key,
      this.onUndo,
      this.onRedo,
      this.onSave,
      this.onClose,
      this.newPolygonPoints = const []});

  void onUndoHandler() {
    List<LatLng> points = List.from(newPolygonPoints);
    if (points.isEmpty) {
      return;
    }

    points.removeLast();
    if (onUndo != null) {
      onUndo!(points);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: 'undo',
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor:
              newPolygonPoints.isNotEmpty ? Colors.black : Colors.grey,
          onPressed: onUndoHandler,
          child: const Icon(Icons.undo),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'redo',
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () {},
          child: const Icon(Icons.redo),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'save',
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () => {},
          child: const Icon(Icons.save),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'x',
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: onClose != null ? () => onClose!() : null,
          child: const Icon(Icons.close),
        ),
      ],
    );
  }
}
