import 'package:asrdb/core/api/api_client.dart';
import 'package:asrdb/core/api/api_endpoints.dart';
import 'package:asrdb/core/config/app_config.dart';
import 'package:dio/dio.dart';

class CheckApi {
  final ApiClient _apiClient = ApiClient(baseUrl: AppConfig.apiBaseUrl);

  Future<Response> checkAutomatic(
      String authToken, String buildingGlobalId) async {
    Map<String, String> authHeader = <String, String>{
      "Authorization": 'Bearer $authToken'
    };
    _apiClient.clearHeaders();
    _apiClient.setHeaders(authHeader);
    return await _apiClient.post(ApiEndpoints.checkAutomatic, data: {
      "buildingIds": [buildingGlobalId]
    });
  }

  Future<Response> checkBuildings(
      String authToken, String buildingGlobalId) async {
    Map<String, String> authHeader = <String, String>{
      "Authorization": 'Bearer $authToken'
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(authHeader);
    return await _apiClient.post(ApiEndpoints.checkBuilding, data: {
      "buildingIds": [buildingGlobalId]
    });
  }
}
