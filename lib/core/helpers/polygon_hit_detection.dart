import 'package:asrdb/data/dto/building_dto.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:geodesy/geodesy.dart';

class PolygonHitDetector {
  static BuildingEntity? getBuildingByTapLocation(
    List<BuildingEntity> buildings,
    LatLng tapPoint,
  ) {
    Geodesy geodesy = Geodesy();

    for (var building in buildings) {
      bool isInside = geodesy.isGeoPointInPolygon(
        tapPoint,
        building.coordinates.first,
      );

      if (isInside) return building; // Return the first matching polygon
    }

    return null;
  }

  /// Returns true if any point in the list falls outside the MultiPolygon
  static bool hasPointOutsideMultiPolygon(
    Map<String, dynamic> multiPolygonGeometry,
    List<LatLng> points,
  ) {
    final String type = multiPolygonGeometry['type'] ?? '';
    final coordinates = multiPolygonGeometry['coordinates'];

    if (type != 'MultiPolygon' || coordinates == null || points.isEmpty) {
      return true; // Treat as invalid => outside
    }

    for (final point in points) {
      bool isInsideAnyPolygon = false;

      // Check against each polygon in the MultiPolygon
      for (final polygonCoords in coordinates) {
        if (_isPointInPolygonCoordinates(point, polygonCoords)) {
          isInsideAnyPolygon = true;
          break;
        }
      }

      // If point is not inside any polygon, return true
      if (!isInsideAnyPolygon) {
        return true;
      }
    }

    return false; // All points are inside
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
extension PolygonHitDetectionExtension on List<BuildingEntity> {
  BuildingEntity? getBuildingByTapLocation(LatLng tapPoint) {
    return PolygonHitDetector.getBuildingByTapLocation(this, tapPoint);
  }
}
