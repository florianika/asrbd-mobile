import 'package:asrdb/core/widgets/button/floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapActionEvents extends StatefulWidget {
  final Function? onUndo;
  final Function? onRedo;
  final Function? onSave;
  final Function? onClose;
  final List<LatLng> newPolygonPoints;
  final MapController mapController;
  final bool isEntrance;
  final void Function(LatLng position) onMarkerPlaced;

  const MapActionEvents({
    super.key,
    this.onUndo,
    this.onRedo,
    this.onSave,
    this.onClose,
    this.newPolygonPoints = const [],
    required this.mapController,
    required this.isEntrance,
    required this.onMarkerPlaced,
  });

  @override
  State<MapActionEvents> createState() => _MapActionEventsState();
}

class _MapActionEventsState extends State<MapActionEvents> {
  bool _isDrawingMarker = true;

  void _placeMarker() {
    final center = widget.mapController.camera.center;
    widget.onMarkerPlaced(center);
    if (widget.isEntrance) {
      setState(() {
        _isDrawingMarker = false;
      });
    }
  }

  void _save() {
    // setState(() {
    //   _isDrawingMarker = false;
    // });
    if (widget.onSave != null) widget.onSave!();
  }

  @override
  Widget build(BuildContext context) {
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
                    color: widget.isEntrance ? Colors.red : Colors.blue,
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
                onPressed:
                    widget.newPolygonPoints.isNotEmpty && widget.onUndo != null
                        ? () => widget.onUndo!()
                        : null,
                isEnabled: widget.newPolygonPoints.isNotEmpty,
              ),
              const SizedBox(height: 20),
              FloatingButton(
                icon: Icons.redo,
                heroTag: 'redo',
                isEnabled: true,
                onPressed:
                    widget.newPolygonPoints.isNotEmpty && widget.onRedo != null
                        ? () => widget.onRedo!()
                        : null,
              ),
              const SizedBox(height: 20),
              FloatingButton(
                icon: Icons.check,
                heroTag: 'done',
                onPressed: () => ((widget.newPolygonPoints.length > 2 &&
                            !widget.isEntrance) ||
                        widget.isEntrance)
                    ? {
                        if (widget.isEntrance) {_placeMarker()},
                        _save()
                      }
                    : null,
                isEnabled: ((widget.newPolygonPoints.length > 2 &&
                        !widget.isEntrance) ||
                    widget.isEntrance),
              ),
              if (!widget.isEntrance) ...[
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
                onPressed:
                    widget.onClose != null ? () => widget.onClose!() : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
