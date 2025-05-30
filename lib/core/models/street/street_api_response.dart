import 'dart:convert';

import 'package:asrdb/core/models/street/street.dart';

class StreetApiResponse {
  final String objectIdFieldName;
  final String globalIdFieldName;
  final List<dynamic> fields;
  final List<Street> streets;

  const StreetApiResponse({
    required this.objectIdFieldName,
    required this.globalIdFieldName,
    required this.fields,
    required this.streets,
  });

  // Factory constructor to parse the full API response
  factory StreetApiResponse.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final featuresJson = json['features'] as List<dynamic>;

    final streets = featuresJson
        .map((feature) => feature['attributes'] as Map<String, dynamic>)
        .map((attributes) => Street.fromJson(attributes))
        .toList();

    return StreetApiResponse(
      objectIdFieldName: json['objectIdFieldName'] as String,
      globalIdFieldName: json['globalIdFieldName'] as String,
      fields: json['fields'] as List<dynamic>,
      streets: streets,
    );
  }

  // Static method to directly get list of Street from API response
  static List<Street> parseStreets(Map<String, dynamic> json) {
    final featuresJson = json['features'] as List<dynamic>;

    return featuresJson
        .map((feature) => feature['attributes'] as Map<String, dynamic>)
        .map((attributes) => Street.fromJson(attributes))
        .toList();
  }
}
