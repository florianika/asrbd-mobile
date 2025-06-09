import 'package:latlong2/latlong.dart';

class EsriConditionHelper {
  static List<String> _formatGlobalIdsForEsri(List<String> globalIds) {
    if (globalIds.isEmpty) return [];

    // Wrap each GlobalID in single quotes for the SQL WHERE clause
    return globalIds.map((id) => "'$id'").toList();
  }

  static String buildWhereClause(String fieldName, List<String> ids) {
    final formattedIds = _formatGlobalIdsForEsri(ids);
    return "$fieldName IN (${formattedIds.join(', ')})";
  }

  static Map<String, dynamic> createEsriPolygonGeometry(List<LatLng> points) {
    // Convert LatLng to list of [longitude, latitude]
    List<List<double>> rings =
        points.map((p) => [p.longitude, p.latitude]).toList();

    // Ensure the polygon ring is closed (first point == last point)
    if (rings.isNotEmpty) {
      final first = rings.first;
      final last = rings.last;
      if (first[0] != last[0] || first[1] != last[1]) {
        rings.add([first[0], first[1]]);
      }
    }

    return {
      "rings": [rings],
      "spatialReference": {"wkid": 4326}
    };
  }

  static List<String> getPropertiesAsList(
      String propertyName, Map<String, dynamic> geoJson) {
    final features = geoJson['features'] as List<dynamic>?;

    if (features == null) return [];

    return features
        .map((feature) => feature['properties']?[propertyName] as String?)
        .where((globalId) => globalId != null)
        .cast<String>()
        .toList();
  }
}
