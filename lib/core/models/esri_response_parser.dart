class EsriResponseParser {
  static bool isSuccess(dynamic data) {
    try {
      if (data is Map &&
          data.containsKey('addResults') &&
          data['addResults'] is List &&
          data['addResults'].isNotEmpty) {
        return data['addResults'][0]['success'] == true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static String? extractGlobalId(dynamic data) {
    try {
      if (isSuccess(data)) {
        return data['addResults'][0]['globalId'];
      }
    } catch (_) {}
    return null;
  }

  static bool isError(dynamic data) {
    return data is Map &&
        data.containsKey('error') &&
        data['error'] is Map &&
        data['error']['code'] != null;
  }

  static String? extractErrorMessage(dynamic data) {
    if (isError(data)) {
      return data['error']['message'] ?? 'Unknown error';
    }
    return null;
  }

  static List<String> extractErrorDetails(dynamic data) {
    if (isError(data)) {
      final details = data['error']['details'];
      if (details is List) {
        return List<String>.from(details);
      }
    }
    return [];
  }
}