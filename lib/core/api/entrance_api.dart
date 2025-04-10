import 'package:asrdb/core/config/esri_config.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class EntranceApi {
  final ApiClient _apiClient = ApiClient(EsriConfig.portalBaseUrl);

  Future<Response> getEntrances() async {
    return await _apiClient.get(ApiEndpoints.esriEntrance);
  }
}
