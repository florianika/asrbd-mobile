import 'package:latlong2/latlong.dart';

class GeometryHelper {
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

  // Helper function to compare two lists of LatLng objects
  static bool compareLatLngLists(List<LatLng> list1, List<LatLng> list2) {
    if (list1.length != list2.length) return false;

    // Compare each LatLng element
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
        var polygonCoordinates =
            geom['coordinates'][0]; // Outer boundary coordinates

        // Convert polygon coordinates to LatLng list
        List<LatLng> polygonLatLngList = polygonCoordinates
            .map<LatLng>((coords) => LatLng(coords[1],
                coords[0])) // Converting [longitude, latitude] to LatLng
            .toList();

        // Compare the LatLng list (ignoring the order for simplicity)
        if (compareLatLngLists(polygonLatLngList, searchCoordinates)) {
          return feature;
        }
      }
    }
    return null; // Return null if no matching polygon is found
  }

  static List<LatLng> parseCoordinates(Map<String, dynamic> geometry) {
    if (geometry['type'] == 'Polygon') {
      // GeoJSON polygons are List<List<List<double>>>
      final List coords =
          geometry['coordinates'][0]; // First ring (outer boundary)
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

}
