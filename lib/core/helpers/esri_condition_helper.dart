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
