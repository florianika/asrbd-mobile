import 'package:asrdb/core/api/api_client.dart';
import 'package:asrdb/core/api/api_endpoints.dart';
import 'package:asrdb/core/config/app_config.dart';
import 'package:dio/dio.dart';

class OutputLogsApi {
  final ApiClient _apiClient = ApiClient(baseUrl: AppConfig.apiBaseUrl);

  Future<Response> getOutputLogs(
      String authToken, String buildingGlobalId) async {
    Map<String, String> authHeader = <String, String>{
      "Authorization": 'Bearer $authToken'
    };
    _apiClient.clearHeaders();
    _apiClient.setHeaders(authHeader);
    return await _apiClient.get('${ApiEndpoints.outputLogs}/$buildingGlobalId');
  }
}
