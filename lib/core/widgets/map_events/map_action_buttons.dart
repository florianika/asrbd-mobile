import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/widgets/button/floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapActionButtons extends StatelessWidget {
  final MapController mapController;
  final Function enableDrawing;
  final String? selectedBuildingId;
  const MapActionButtons({
    super.key,
    required this.mapController,
    required this.enableDrawing,
    this.selectedBuildingId,
  });

  Future<void> _goToCurrentLocation(BuildContext context) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services.')),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied.')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Location permissions permanently denied.')),
          );
        }
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final userLatLng = LatLng(pos.latitude, pos.longitude);
      mapController.move(userLatLng, 15.0);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching location: $e')),
        );
      }
    }
  }

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
              onPressed: () => _goToCurrentLocation(context),
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
