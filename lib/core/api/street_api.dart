import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class StreetApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getStreets(String esriToken, int municipalityId) async {
    return await _apiClient
        .get('${ApiEndpoints.getEsriStreets(municipalityId)}&token=$esriToken');
  }
}
