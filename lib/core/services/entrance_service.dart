import 'dart:convert';
import 'package:asrdb/core/api/entrance_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/data/dto/entrance_dto.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';

class EntranceService {
  final EntranceApi entranceApi;
  EntranceService(this.entranceApi);

  final StorageService _storage = StorageService();

  Future<List<EntranceEntity>> getEntrancesByBuildingId(
      String buildingGlobalId) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await entranceApi.getEntrancesByBuildingId(esriToken, buildingGlobalId);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching entrances: ${mapData['error']['message']}');
        } else {
          final data = response.data as Map<String, dynamic>;
          final features = data['features'] as List<dynamic>? ?? [];

          final List<EntranceDto> entranceDtos = features
              .map((feature) => EntranceDto.fromGeoJsonFeature(
                  feature as Map<String, dynamic>))
              .toList();

          final entranceEntites =
              entranceDtos.map((dto) => dto.toEntity()).toList();

          return entranceEntites;
        }
      } else {
        throw Exception('Get entrances');
      }
    } catch (e) {
      throw Exception('Get entrances: $e');
    }
  }

  // Login method
  Future<List<EntranceEntity>> getEntrances(
      List<String> entBldGlobalID) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await entranceApi.getEntrances(esriToken, entBldGlobalID);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching entrances: ${mapData['error']['message']}');
        } else {
          final data = response.data as Map<String, dynamic>;
          final features = data['features'] as List<dynamic>? ?? [];

          final List<EntranceDto> entranceDtos = features
              .map((feature) => EntranceDto.fromGeoJsonFeature(
                  feature as Map<String, dynamic>))
              .toList();

          final entranceEntites =
              entranceDtos.map((dto) => dto.toEntity()).toList();

          return entranceEntites;
        }
      } else {
        throw Exception('Get entrances');
      }
    } catch (e) {
      throw Exception('Get entrances: $e');
    }
  }

  Future<EntranceEntity> getEntranceDetails(String globalId) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await entranceApi.getEntranceDetails(esriToken, globalId);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching entrance details: ${mapData['error']['message']}');
        } else {
          final features = mapData['features'] as List<dynamic>? ?? [];
          final List<EntranceDto> entranceDto = features
              .map((feature) => EntranceDto.fromGeoJsonFeature(
                  feature as Map<String, dynamic>))
              .toList();

          if (entranceDto.isNotEmpty) {
            return entranceDto[0].toEntity();
          } else {
            throw Exception('No building found with globalId: $globalId');
          }
        }
      } else {
        throw Exception('Get entrance details');
      }
    } catch (e) {
      throw Exception('Get entrance details: $e');
    }
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
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
      throw Exception('Get entrance attributes: $e');
    }
  }

  Future<String> addEntranceFeature(EntranceEntity entrance) async {
    try {
      final esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Missing Esri token');

      final response = await entranceApi.addEntranceFeature(
        esriToken,
        entrance,
      );

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
      throw Exception('Add entrance feature failed: $e');
    }
  }

  Future<bool> updateEntranceFeature(EntranceEntity entrance) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await entranceApi.updateEntranceFeature(esriToken, entrance);
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
      throw Exception('Update entrance feature: $e');
    }
  }

  Future<bool> deleteEntranceFeature(String objectId) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await entranceApi.deleteEntranceFeature(esriToken, objectId);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('delete entrance feature: $e');
    }
  }
}
