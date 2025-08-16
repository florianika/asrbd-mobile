import 'dart:convert';

import 'package:asrdb/core/api/dwelling_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/data/dto/dwelling_dto.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';

class DwellingService {
  final DwellingApi dwellingApi;
  DwellingService(this.dwellingApi);

  final StorageService _storage = StorageService();

  Future<List<DwellingEntity>> getDwellings(String? entranceGlobalId) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);

      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await dwellingApi.getDwellings(esriToken, entranceGlobalId);
      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching dwellings: ${mapData['error']['message']}');
        } else {
          final data = response.data as Map<String, dynamic>;
          final features = data['features'] as List<dynamic>? ?? [];

          final List<DwellingDto> dwellingDtos = features
              .map((feature) => DwellingDto.fromGeoJsonFeature(
                  feature as Map<String, dynamic>))
              .toList();

          final dwellingEntities =
              dwellingDtos.map((dto) => dto.toEntity()).toList();

          return dwellingEntities;
        }
      } else {
        throw Exception('Get dwellings error');
      }
    } catch (e) {
      throw Exception('Get dwellings: $e');
    }
  }

  Future<List<FieldSchema>> getDwellingAttributes() async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await dwellingApi.getDwellingAttributes(esriToken);
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
      throw Exception('Get dwelling attributes: $e');
    }
  }

  Future<DwellingEntity> getDwellingDetails(int objectId) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await dwellingApi.getDwellingDetails(esriToken, objectId);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching entrance details: ${mapData['error']['message']}');
        } else {
          final features = mapData['features'] as List<dynamic>? ?? [];
          final List<DwellingDto> entranceDto = features
              .map((feature) => DwellingDto.fromGeoJsonFeature(
                  feature as Map<String, dynamic>))
              .toList();

          if (entranceDto.isNotEmpty) {
            return entranceDto[0].toEntity();
          } else {
            throw Exception('No dwelling found with globalId: $objectId');
          }
        }
      } else {
        throw Exception('Get entrance details');
      }
    } catch (e) {
      throw Exception('Get dwelling details: $e');
    }
  }

  Future<String> addDwellingFeature(DwellingEntity dwelling) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await dwellingApi.addDwellingFeature(esriToken, dwelling);
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
      throw Exception('Add dwelling feature: $e');
    }
  }

  Future<bool> updateDwellingFeature(DwellingEntity dwelling) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await dwellingApi.updateDwellingFeature(esriToken, dwelling);
      if (response.statusCode == 200) {
        // Ensure response data is decoded
        final dynamic rawData = response.data;
        final Map<String, dynamic> mapData = rawData is String
            ? jsonDecode(rawData)
            : rawData as Map<String, dynamic>;

        // Check for top-level error
        if (mapData.containsKey('error')) {
          final errorMsg = mapData['error']['message'] ?? 'Unknown error';
          final details = mapData['error']['details']?.join(', ') ?? '';
          throw Exception('Server error: $errorMsg. $details');
        }

        // Check updateResults for success
        final updateResults = mapData['updateResults'];
        if (updateResults is List && updateResults.isNotEmpty) {
          final result = updateResults[0];
          if (result is Map && result['success'] == true) {
            return true;
          } else {
            throw Exception(
                'Feature update failed: ${result['error']?['message'] ?? 'Unknown reason'}');
          }
        }

        throw Exception('Unexpected response format.');
      } else {
        throw Exception('Failed request: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('update dwelling feature: $e');
    }
  }
}
