import 'package:asrdb/core/api/entrance_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/services/storage_service.dart';

class EntranceService {
  final EntranceApi entranceApi;
  EntranceService(this.entranceApi);
  final StorageService _storage = StorageService();
  // Login method
  Future<Map<String, dynamic>> getEntrances() async {
    try {
      String? esriToken = await _storage.getString(StorageKeys.esriAccessToken);
      if (esriToken == null) throw Exception('Login failed:');

      final response = await entranceApi.getEntrances(esriToken);

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
}
