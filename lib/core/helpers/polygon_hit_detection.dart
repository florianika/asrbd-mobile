import 'package:latlong2/latlong.dart';

class PolygonHitDetector {
  /// Efficiently finds which polygon contains the tapped point
  /// Returns the GlobalID of the polygon, or null if no polygon contains the point
  static String? getPolygonIdAtPoint(
    Map<String, dynamic> geoJsonData,
    LatLng tapPoint,
  ) {
    final features =
        List<Map<String, dynamic>>.from(geoJsonData['features'] ?? []);

    // Early exit if no features
    if (features.isEmpty) return null;

    for (final feature in features) {
      final geometry = feature['geometry'];
      final properties = feature['properties'];

      if (geometry == null || properties == null) continue;

      final globalId = properties['GlobalID']?.toString();
      if (globalId == null) continue;

      // Check if point is within this polygon
      if (_isPointInPolygon(tapPoint, geometry)) {
        return globalId;
      }
    }

    return null;
  }

  /// Checks if a point is inside a polygon using ray casting algorithm
  /// Handles both Polygon and MultiPolygon geometries
  static bool _isPointInPolygon(LatLng point, Map<String, dynamic> geometry) {
    final String type = geometry['type'] ?? '';
    final coordinates = geometry['coordinates'];

    if (coordinates == null) return false;

    switch (type) {
      case 'Polygon':
        return _isPointInPolygonCoordinates(point, coordinates);
      case 'MultiPolygon':
        // Check each polygon in the MultiPolygon
        for (final polygonCoords in coordinates) {
          if (_isPointInPolygonCoordinates(point, polygonCoords)) {
            return true;
          }
        }
        return false;
      default:
        return false;
    }
  }

  /// Checks if point is in polygon coordinates (handles holes)
  static bool _isPointInPolygonCoordinates(
      LatLng point, List<dynamic> coordinates) {
    if (coordinates.isEmpty) return false;

    // First ring is exterior, rest are holes
    final exterior = coordinates[0];

    // Check if point is in exterior ring
    if (!_isPointInRing(point, exterior)) {
      return false;
    }

    // Check if point is in any hole (if so, it's not in the polygon)
    for (int i = 1; i < coordinates.length; i++) {
      if (_isPointInRing(point, coordinates[i])) {
        return false; // Point is in a hole
      }
    }

    return true;
  }

  /// Ray casting algorithm to check if point is inside a ring
  /// Optimized version with early bounds checking
  static bool _isPointInRing(LatLng point, List<dynamic> ring) {
    if (ring.length < 3) return false;

    final double x = point.longitude;
    final double y = point.latitude;

    // Quick bounds check for efficiency
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    // Convert coordinates and find bounds
    final List<List<double>> points = [];
    for (final coord in ring) {
      if (coord is List && coord.length >= 2) {
        final double lng = coord[0].toDouble();
        final double lat = coord[1].toDouble();

        points.add([lng, lat]);

        if (lng < minX) minX = lng;
        if (lng > maxX) maxX = lng;
        if (lat < minY) minY = lat;
        if (lat > maxY) maxY = lat;
      }
    }

    // Quick bounds check - if point is outside bounding box, it's not inside
    if (x < minX || x > maxX || y < minY || y > maxY) {
      return false;
    }

    // Ray casting algorithm
    bool inside = false;
    int j = points.length - 1;

    for (int i = 0; i < points.length; i++) {
      final double xi = points[i][0];
      final double yi = points[i][1];
      final double xj = points[j][0];
      final double yj = points[j][1];

      if (((yi > y) != (yj > y)) &&
          (x < (xj - xi) * (y - yi) / (yj - yi) + xi)) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }
}

// Extension method for easy access
extension PolygonHitDetectionExtension on Map<String, dynamic> {
  String? getPolygonIdAtPoint(LatLng tapPoint) {
    return PolygonHitDetector.getPolygonIdAtPoint(this, tapPoint);
  }
}
