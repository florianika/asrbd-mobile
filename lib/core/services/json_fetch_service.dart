import 'dart:convert';
import 'package:asrdb/core/api/building_api.dart';
import 'package:asrdb/core/api/entrance_api.dart';
import 'package:asrdb/core/api/dwelling_api.dart';
import 'package:asrdb/core/api/schema_api.dart';

class JsonFetchService {
  final BuildingApi buildingApi;
  final EntranceApi entranceApi;
  final DwellingApi dwellingApi;
  final SchemaApi schemaApi;

  JsonFetchService(this.buildingApi, this.entranceApi, this.dwellingApi, this.schemaApi);

  Future<String> getBuildingJson() async {
    try {
      final response = await buildingApi.getBuildingAttributes();

      if (response.statusCode == 200) {
        final data = response.data;
        return jsonEncode(data);
      } else {
        throw Exception(
            'Schema fetch failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      throw Exception('Get building JSON: $e');
    }
  }

  Future<String> getEntranceJson() async {
    try {
      final response = await entranceApi.getEntranceAttributes();

      if (response.statusCode == 200) {
        final data = response.data;
        return jsonEncode(data);
      } else {
        throw Exception(
            'Schema fetch failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      throw Exception('Get entrance JSON: $e');
    }
  }

  Future<String> getDwellingJson() async {
    try {
      final response = await dwellingApi.getDwellingAttributes();

      if (response.statusCode == 200) {
        final data = response.data;
        return jsonEncode(data);
      } else {
        throw Exception(
            'Schema fetch failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      throw Exception('Get dwelling JSON: $e');
    }
  }

  Future<String> getEntranceSchemaJson() async {
    try {
      final response = await schemaApi.getEntranceSchema();

      if (response.statusCode == 200) {
        final data = response.data;
        return jsonEncode(data);
      } else {
        throw Exception(
            'Entrance schema fetch failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      throw Exception('Get entrance schema JSON: $e');
    }
  }

  Future<String> getBuildingSchemaJson() async {
    try {
      final response = await schemaApi.getBuildingSchema();

      if (response.statusCode == 200) {
        final data = response.data;
        return jsonEncode(data);
      } else {
        throw Exception(
            'Building schema fetch failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      throw Exception('Get building schema JSON: $e');
    }
  }

  Future<String> getDwellingSchemaJson() async {
    try {
      final response = await schemaApi.getDwellingSchema();

      if (response.statusCode == 200) {
        final data = response.data;
        return jsonEncode(data);
      } else {
        throw Exception(
            'Dwelling schema fetch failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      throw Exception('Get dwelling schema JSON: $e');
    }
  }
}
