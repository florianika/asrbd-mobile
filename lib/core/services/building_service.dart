import 'package:asrdb/core/api/building_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuildingService {
  final BuildingApi buildingApi;
  BuildingService(this.buildingApi);

  final StorageService _storage = StorageService();

  Future<Map<String, dynamic>> getBuildings(
      LatLngBounds bounds, double zoom, int municipalityId) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      final bbox =
          '${bounds.west},${bounds.south},${bounds.east},${bounds.north}';
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await buildingApi.getBuildings(esriToken, bbox, municipalityId);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<List<FieldSchema>> getBuildingAttributes() async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await buildingApi.getBuildingAttributes(esriToken);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['fields'] == null) {
          throw Exception('Missing "fields" key in response: $data');
        }

        return (data['fields'] as List)
            .map((e) => FieldSchema.fromJson(e))
            .toList();
      } else {
        throw Exception(
            'Schema fetch failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> addBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await buildingApi.addBuildingFeature(esriToken, attributes, points);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> updateBuildingFeature(
      Map<String, dynamic> attributes) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await buildingApi.updateBuildingFeature(
          esriToken, attributes);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
