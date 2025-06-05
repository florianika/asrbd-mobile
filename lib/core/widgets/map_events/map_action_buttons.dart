import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/services/location_service.dart';
import 'package:asrdb/core/widgets/button/floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapActionButtons extends StatelessWidget {
  final MapController mapController;
  final Function enableDrawing;
  final String? selectedBuildingId;
  final VoidCallback onLocateMe;
  const MapActionButtons({
    super.key,
    required this.mapController,
    required this.enableDrawing,
    this.selectedBuildingId,
    required this.onLocateMe,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 270,
          left: 20,
          child: FloatingButton(
            heroTag: 'zoom_in',
            isEnabled: true,
            onPressed: () {
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom + 1);
            },
            icon: Icons.zoom_in,
          ),
        ),
        Positioned(
          bottom: 210,
          left: 20,
          child: FloatingButton(
            heroTag: 'zoom_out',
            isEnabled: true,
            onPressed: () {
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom - 1);
            },
            icon: Icons.zoom_out,
          ),
        ),
        Positioned(
            bottom: 150,
            left: 20,
            child: FloatingButton(
              heroTag: 'locate_me',
              isEnabled: true,
              onPressed: onLocateMe,
              icon: Icons.my_location,
            )),
        Positioned(
          bottom: 90,
          left: 20,
          child: FloatingButton(
            heroTag: 'rectangle',
            isEnabled: true,
            onPressed: () => enableDrawing(ShapeType.polygon),
            icon: Icons.rectangle_outlined,
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          child: FloatingButton(
            heroTag: 'entrance',
            onPressed: () => enableDrawing(ShapeType.point),
            isEnabled: selectedBuildingId != null,
            icon: Icons.sensor_door_outlined,
          ),
        ),
      ],
    );
  }
}
