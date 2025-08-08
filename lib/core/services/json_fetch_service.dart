import 'dart:convert';
import 'package:asrdb/core/api/building_api.dart';
import 'package:asrdb/core/api/entrance_api.dart';
import 'package:asrdb/core/api/dwelling_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/services/storage_service.dart';

class JsonFetchService {
  final BuildingApi buildingApi;
  final EntranceApi entranceApi;
  final DwellingApi dwellingApi;

  JsonFetchService(this.buildingApi, this.entranceApi, this.dwellingApi);

  final StorageService _storage = StorageService();


  Future<String> getBuildingJson() async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await buildingApi.getBuildingAttributesJson(esriToken);

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
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await entranceApi.getEntranceAttributesJson(esriToken);

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
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await dwellingApi.getDwellingAttributesJson(esriToken);

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
}
