import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class BuildingApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getBuildings(String esriToken) async {
    return await _apiClient.get('${ApiEndpoints.esriBulding}&token=$esriToken');
  }
}
