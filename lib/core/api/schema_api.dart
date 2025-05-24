import 'package:asrdb/core/api/api_client.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class SchemaApi {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getEntranceSchema() async {
    return await _apiClient.get(ApiEndpoints.entranceSchema);
  }

  Future<Response> getBuildingSchema() async {
    return await _apiClient.get(ApiEndpoints.buildingSchema);
  }

  Future<Response> getDwellingSchema() async {
    return await _apiClient.get(ApiEndpoints.dwellingSchema);
  }
}
