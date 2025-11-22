import 'package:asrdb/core/api/check_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/services/secure_storage_service.dart';

class CheckService {
  final CheckApi checkApi;
  CheckService(this.checkApi);

  final SecureStorageService _secureStorage = SecureStorageService();

  Future<bool> checkAutomatic(String buildingGlobalId) async {
    try {
      String? accessToken =
          await _secureStorage.read(key: StorageKeys.accessToken);

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
          await _secureStorage.read(key: StorageKeys.accessToken);

      if (accessToken == null) throw Exception('Login failed:');

      final response =
          await checkApi.checkBuildings(accessToken, buildingGlobalId);
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Check buildings: $e');
    }
  }
}
