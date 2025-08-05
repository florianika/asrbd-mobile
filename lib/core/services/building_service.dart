import 'dart:convert';
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
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
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
      throw Exception('Get buildings failed: $e');
    }
  }

  Future<List<FieldSchema>> getBuildingAttributes() async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
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
      throw Exception('Get buildings attributes: $e');
    }
  }

  Future<String> addBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      // bool intersected = await getBuildingIntersections(EsriConditionHelper.createEsriPolygonGeometry(points));

      // if (intersected) throw Exception("Polygon is intersected with other one");

      final response =
          await buildingApi.addBuildingFeature(esriToken, attributes, points);
      if (response.statusCode == 200) {
        // Ensure response data is decoded
        final dynamic rawData = response.data;
        final Map<String, dynamic> mapData = rawData is String
            ? jsonDecode(rawData)
            : rawData as Map<String, dynamic>;

        if (mapData.containsKey('error')) {
          final errorMsg = mapData['error']['message'] ?? 'Unknown error';
          final details = mapData['error']['details']?.join(', ') ?? '';
          throw Exception('Server error: $errorMsg. $details');
        }

        // Check the 'success' value in addResults
        final addResults = mapData['addResults'];
        if (addResults is List && addResults.isNotEmpty) {
          final result = addResults[0];
          if (result is Map && result['success'] == true) {
            return result['globalId'];
          } else {
            throw Exception(
                'Feature add failed: ${result['error']?['message'] ?? 'Unknown reason'}');
          }
        }

        throw Exception('Unexpected response format.');
      } else {
        throw Exception('Failed request: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Add building feature: $e');
    }
  }

  Future<bool> updateBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng>? points) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await buildingApi.updateBuildingFeature(
          esriToken, attributes, points);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Update building feature: $e');
    }
  }

  Future<Map<String, dynamic>> getBuildingDetails(String globalId) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await buildingApi.getBuildingDetails(esriToken, globalId);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching entrance details: ${mapData['error']['message']}');
        } else {
          return mapData;
        }
      } else {
        throw Exception('Get building details error');
      }
    } catch (e) {
      throw Exception('Get building details: $e');
    }
  }

  Future<bool> getBuildingIntersections(Map<String, dynamic> geometry) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await buildingApi.getBuildingIntersection(esriToken, geometry);

      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching entrance details: ${mapData['error']['message']}');
        } else {
          return mapData.isNotEmpty;
        }
      } else {
        throw Exception('Get building intersection');
      }
    } catch (e) {
      throw Exception('Get building intersection: $e');
    }
  }

  Future<int> getBuildingsCount(LatLngBounds bounds, int municipalityId) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      final bbox =
          '${bounds.west},${bounds.south},${bounds.east},${bounds.north}';
      if (esriToken == null) throw Exception('Login failed: missing token');

      final response =
          await buildingApi.getBuildingsCount(esriToken, bbox, municipalityId);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['count'] != null) {
          return data['count'] as int;
        } else {
          throw Exception('Count not found in response');
        }
      } else {
        throw Exception(
            'Failed to get buildings. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Get buildings failed: $e');
    }
  }
}
