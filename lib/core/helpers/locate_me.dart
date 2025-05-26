import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocateMe extends StatelessWidget {
  final MapController mapController;
  final double zoomLevel;

  /// [mapController] is the controller for your FlutterMap.
  /// [zoomLevel] is the zoom you want when centering on the user.
  const LocateMe({
    super.key,
    required this.mapController,
    this.zoomLevel = 15.0,
  });

  Future<void> _goToCurrentLocation(BuildContext context) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services.')),
        );
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied.')),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions permanently denied.')),
        );
        return;
      }
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final userLatLng = LatLng(pos.latitude, pos.longitude);
      mapController.move(userLatLng, zoomLevel);
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'locate_me',
      mini: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      onPressed: () => _goToCurrentLocation(context),
      tooltip: 'Locate Me',
      child: const Icon(Icons.my_location),
    );
  }
}
