import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class EntranceApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getEntrances(String esriToken) async {
    return await _apiClient
        .get('${ApiEndpoints.esriEntrance}&token=$esriToken');
  }
}
