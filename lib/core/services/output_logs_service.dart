import 'package:asrdb/core/api/output_logs_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/validation/process_output_log_response.dart';
import 'package:asrdb/core/services/storage_service.dart';

class OutputLogsService {
  final OutputLogsApi outputLogsApi;
  OutputLogsService(this.outputLogsApi);

  final StorageService _storage = StorageService();

  Future<ProcessOutputLogResponse> getOutputLogs(
      String buildingGlobalId) async {
    try {
      String? accessToken = await _storage.getString(StorageKeys.accessToken);

      if (accessToken == null) throw Exception('Login failed:');

      final response =
          await outputLogsApi.getOutputLogs(accessToken, buildingGlobalId);
      if (response.statusCode == 200) {
        return ProcessOutputLogResponse.fromJson(response.data);
      }
      throw Exception('Get ouptut logs');
    } catch (e) {
      throw Exception('Get ouptut logs: $e');
    }
  }
}
