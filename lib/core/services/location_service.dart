import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static Future<LatLng> getCurrentLocation() async {
    await _ensureLocationServiceEnabled();
    await _ensureLocationPermissionGranted();

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }

  static Future<void> _ensureLocationServiceEnabled() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Please enable location services.');
    }
  }

  static Future<void> _ensureLocationPermissionGranted() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }
  }
}
