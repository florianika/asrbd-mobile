import 'package:asrdb/core/api/check_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/services/storage_service.dart';

class CheckService {
  final CheckApi checkApi;
  CheckService(this.checkApi);

  final StorageService _storage = StorageService();

  Future<bool> checkAutomatic(String buildingGlobalId) async {
    try {
      String? accessToken =
          await _storage.getString(key: StorageKeys.accessToken);

      if (accessToken == null) throw Exception('Login failed:');

      final response =
          await checkApi.checkAutomatic(accessToken, buildingGlobalId);
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Check automatic for building $buildingGlobalId: $e');
    }
  }

  Future<bool> checkBuildings(String buildingGlobalId) async {
    try {
      String? accessToken =
          await _storage.getString(key: StorageKeys.accessToken);

      if (accessToken == null) throw Exception('Login failed:');

      final response =
          await checkApi.checkBuildings(accessToken, buildingGlobalId);
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Check buildings: $e');
    }
  }
}
