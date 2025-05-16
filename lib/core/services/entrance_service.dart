import 'package:asrdb/core/api/entrance_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EntranceService {
  final EntranceApi entranceApi;
  EntranceService(this.entranceApi);

  final StorageService _storage = StorageService();
  // Login method
  Future<Map<String, dynamic>> getEntrances(
      LatLngBounds bounds, double zoom) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final bbox =
          '${bounds.west},${bounds.south},${bounds.east},${bounds.north}';
      final response = await entranceApi.getEntrances(esriToken, bbox);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching entrances: ${mapData['error']['message']}');
        } else {
          return mapData;
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await entranceApi.getEntranceAttributes(esriToken);

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

  Future<bool> addEntranceFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await entranceApi.addEntranceFeature(esriToken, attributes, points);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> updateEntranceFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await entranceApi.updateEntranceFeature(
          esriToken, attributes, points);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> deleteEntranceFeature(String objectId) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await entranceApi.deleteEntranceFeature(esriToken, objectId);
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
