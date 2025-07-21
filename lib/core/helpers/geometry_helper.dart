import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart' show Geodesy;
import 'package:latlong2/latlong.dart';
import 'dart:math';

class GeometryHelper {
  static bool isPointInsideBounds(LatLng point, LatLngBounds bounds) {
    return bounds.contains(point);
  }

// Add this method to PolygonHitDetector
  static Map<String, dynamic>? getPolygonGeometryById(
      Map<String, dynamic> geoJson, String globalId) {
    final features = List<Map<String, dynamic>>.from(geoJson['features'] ?? []);
    for (final feature in features) {
      if (feature['properties']?['GlobalID']?.toString() == globalId) {
        return feature['geometry'];
      }
    }
    return null;
  }

  static List<LatLng> getPolygonPoints(Map<String, dynamic> geometry) {
    final String type = geometry['type'];
    final coordinates = geometry['coordinates'];

    if (coordinates == null) return [];

    switch (type) {
      case 'Polygon':
        return _parseRing(coordinates[0]); // Exterior ring only
      case 'MultiPolygon':
        if (coordinates.isNotEmpty && coordinates[0].isNotEmpty) {
          return _parseRing(coordinates[0][0]); // First polygon, exterior ring
        }
        return [];
      default:
        return [];
    }
  }

  static List<LatLng> _parseRing(List<dynamic> ringCoords) {
    return ringCoords
        .whereType<List>()
        .where((point) => point.length >= 2)
        .map((point) => LatLng(point[1].toDouble(), point[0].toDouble()))
        .toList();
  }

  static bool anyPointOutsideBounds(List<LatLng> points, LatLngBounds bounds) {
    for (final point in points) {
      if (!isPointInsideBounds(point, bounds)) {
        return true;
      }
    }
    return false;
  }

  static double _degToRad(double deg) => deg * pi / 180.0;
  static const double _earthRadius = 6378137.0;

  static bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; j = i++) {
      if (((polygon[i].latitude > point.latitude) !=
              (polygon[j].latitude > point.latitude)) &&
          (point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (point.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        inside = !inside;
      }
    }
    return inside;
  }

  static bool compareLatLngLists(List<LatLng> list1, List<LatLng> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].latitude != list2[i].latitude ||
          list1[i].longitude != list2[i].longitude) {
        return false;
      }
    }
    return true;
  }

  static Map<String, dynamic>? findPolygonPropertiesByCoordinates(
      Map<String, dynamic> geoJson, List<LatLng> searchCoordinates) {
    for (var feature in geoJson['features']) {
      var geom = feature['geometry'];

      if (geom['type'] == 'Polygon') {
        var polygonCoordinates = geom['coordinates'][0];

        List<LatLng> polygonLatLngList = polygonCoordinates
            .map<LatLng>((coords) => LatLng(coords[1], coords[0]))
            .toList();

        if (compareLatLngLists(polygonLatLngList, searchCoordinates)) {
          return feature;
        }
      }
    }
    return null;
  }

  static List<LatLng> parseCoordinates(Map<String, dynamic> geometry) {
    if (geometry['type'] == 'Polygon') {
      final List coords = geometry['coordinates'][0];
      return coords.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
    } else if (geometry['type'] == 'Point') {
      final coord = geometry['coordinates'];
      return [LatLng(coord[1], coord[0])];
    } else {
      throw UnsupportedError(
          'Geometry type not supported: ${geometry['type']}');
    }
  }

  static bool doPolygonsIntersect(List<LatLng> poly1, List<LatLng> poly2) {
    if (poly1.length < 3 || poly2.length < 3) return false;
    if (_areSamePolygon(poly1, poly2)) return false;
    if (!_boundingBoxesOverlap(poly1, poly2)) return false;

    for (int i = 0; i < poly1.length; i++) {
      final a1 = poly1[i];
      final a2 = poly1[(i + 1) % poly1.length];

      for (int j = 0; j < poly2.length; j++) {
        final b1 = poly2[j];
        final b2 = poly2[(j + 1) % poly2.length];

        if (_doEdgesIntersect(a1, a2, b1, b2)) return true;
      }
    }
    return false;
  }

  static bool _areSamePolygon(List<LatLng> a, List<LatLng> b) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      final latDiff = (a[i].latitude - b[i].latitude).abs();
      final lngDiff = (a[i].longitude - b[i].longitude).abs();

      if (latDiff > 1e-9 || lngDiff > 1e-9) {
        return false;
      }
    }
    return true;
  }

  /// Projected vector math helper (treats LatLng as 2D points)
  static LatLng _closestPointOnSegment(LatLng p, LatLng a, LatLng b) {
    double x = p.longitude;
    double y = p.latitude;

    double x1 = a.longitude;
    double y1 = a.latitude;
    double x2 = b.longitude;
    double y2 = b.latitude;

    double dx = x2 - x1;
    double dy = y2 - y1;

    if (dx == 0 && dy == 0) return a; // segment is a point

    double t = ((x - x1) * dx + (y - y1) * dy) / (dx * dx + dy * dy);
    t = t.clamp(0.0, 1.0); // clamp to segment

    return LatLng(y1 + t * dy, x1 + t * dx);
  }

  static void injectPointIntoPolygon(List<LatLng> polygon, LatLng newPoint) {
    final geodesy = Geodesy();
    num minDistance = double.infinity;
    int insertIndex = 0;

    for (int i = 0; i < polygon.length - 1; i++) {
      LatLng a = polygon[i];
      LatLng b = polygon[i + 1];

      // Get closest point on the line from a to b
      final closest = _closestPointOnSegment(newPoint, a, b);
      final dist = geodesy.distanceBetweenTwoGeoPoints(newPoint, closest);

      if (dist < minDistance) {
        minDistance = dist;
        insertIndex = i + 1;
      }
    }

    // Optional: check also the closing edge if polygon is closed
    if (polygon.first != polygon.last) {
      LatLng a = polygon.last;
      LatLng b = polygon.first;
      final closest = _closestPointOnSegment(newPoint, a, b);
      final dist = geodesy.distanceBetweenTwoGeoPoints(newPoint, closest);
      if (dist < minDistance) {
        insertIndex = polygon.length; // insert at the end
      }
    }

    polygon.insert(insertIndex, newPoint);
  }

  static bool _boundingBoxesOverlap(List<LatLng> a, List<LatLng> b) {
    double minAx = a.map((p) => p.latitude).reduce((x, y) => x < y ? x : y);
    double maxAx = a.map((p) => p.latitude).reduce((x, y) => x > y ? x : y);
    double minAy = a.map((p) => p.longitude).reduce((x, y) => x < y ? x : y);
    double maxAy = a.map((p) => p.longitude).reduce((x, y) => x > y ? x : y);
    double minBx = b.map((p) => p.latitude).reduce((x, y) => x < y ? x : y);
    double maxBx = b.map((p) => p.latitude).reduce((x, y) => x > y ? x : y);
    double minBy = b.map((p) => p.longitude).reduce((x, y) => x < y ? x : y);
    double maxBy = b.map((p) => p.longitude).reduce((x, y) => x > y ? x : y);

    return !(minAx > maxBx || maxAx < minBx || minAy > maxBy || maxAy < minBy);
  }

  static bool _doEdgesIntersect(LatLng p1, LatLng p2, LatLng q1, LatLng q2) {
    final o1 = _orientation(p1, p2, q1);
    final o2 = _orientation(p1, p2, q2);
    final o3 = _orientation(q1, q2, p1);
    final o4 = _orientation(q1, q2, p2);

    return (o1 != o2) && (o3 != o4);
  }

  static double _orientation(LatLng a, LatLng b, LatLng c) {
    return (b.longitude - a.longitude) * (c.latitude - a.latitude) -
        (b.latitude - a.latitude) * (c.longitude - a.longitude);
  }

  static double calculatePolygonArea(List<LatLng> polygon) {
    if (polygon.length < 3) return 0.0;

    double area = 0.0;

    for (int i = 0; i < polygon.length; i++) {
      final LatLng p1 = polygon[i];
      final LatLng p2 = polygon[(i + 1) % polygon.length];

      final double lat1 = _degToRad(p1.latitude);
      final double lon1 = _degToRad(p1.longitude);
      final double lat2 = _degToRad(p2.latitude);
      final double lon2 = _degToRad(p2.longitude);

      area += (lon2 - lon1) * (2 + sin(lat1) + sin(lat2));
    }

    return (area * _earthRadius * _earthRadius / 2.0).abs();
  }

  static LatLng getPolygonCentroid(List<LatLng> polygon) {
    double sumLat = 0.0;
    double sumLng = 0.0;

    for (final point in polygon) {
      sumLat += point.latitude;
      sumLng += point.longitude;
    }

    final double centroidLat = sumLat / polygon.length;
    final double centroidLng = sumLng / polygon.length;

    return LatLng(centroidLat, centroidLng);
  }
}
