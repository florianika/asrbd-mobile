import 'package:asrdb/core/api/street_api.dart';
import 'package:asrdb/core/db/street_database.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/street/street.dart';
import 'package:asrdb/core/models/street/street_api_response.dart';
import 'package:asrdb/core/services/storage_service.dart';

class StreetService {
  final StreetApi buildingApi;
  StreetService(this.buildingApi);

  final StorageService _storage = StorageService();

  Future<List<Street>> getStreets(int municipalityId) async {
    try {
      String? esriToken =
          await _storage.getString(key: StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await buildingApi.getStreets(esriToken, municipalityId);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        return StreetApiResponse.fromJson(response.data).streets;
      } else {
        throw Exception('Get streets');
      }
    } catch (e) {
      throw Exception('Get streets: $e');
    }
  }

  void saveStreets(List<Street> streets) async {
    await StreetDatabase.insertStreetsBatch(streets);
  }

  Future<Street?> getStreetByGlobalId(String globalId) async {
    return await StreetDatabase.getStreetByGlobalId(globalId);
  }

  Future<void> clearAllStreets() async {
    await StreetDatabase.clearAllStreets();
  }
}
