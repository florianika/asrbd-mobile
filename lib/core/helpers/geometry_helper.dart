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
          return feature['properties'];
        }
      }
    }
    return null; // Return null if no matching polygon is found
  }
}
