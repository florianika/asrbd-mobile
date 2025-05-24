import 'package:asrdb/core/api/dwelling_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/storage_service.dart';

class DwellingService {
  final DwellingApi dwellingApi;
  DwellingService(this.dwellingApi);

  final StorageService _storage = StorageService();

  Future<Map<String, dynamic>> getDwellings(
     String? entranceGlobalId) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
     
      if (esriToken == null) throw Exception('Login failed:');

      final response = await dwellingApi.getDwellings(esriToken, entranceGlobalId);
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<List<FieldSchema>> getDwellingAttributes() async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
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
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> getDwellingDetails(int objectId) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await dwellingApi.getDwellingDetails(esriToken, objectId);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching dwelling details: ${mapData['error']['message']}');
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
  
  Future<bool> addDwellingFeature(
      Map<String, dynamic> attributes) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response =
          await dwellingApi.addDwellingFeature(esriToken, attributes);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

   Future<bool> updateDwellingFeature(
      Map<String, dynamic> attributes) async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await dwellingApi.updateDwellingFeature(
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
