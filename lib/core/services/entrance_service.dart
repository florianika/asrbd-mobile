import 'package:asrdb/core/api/entrance_api.dart';

class EntranceService {
  final EntranceApi entranceApi;
  EntranceService(this.entranceApi);
  // Login method
  Future<Map<String, dynamic>> getEntrances() async {
    try {
      final response = await entranceApi.getEntrances();

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
