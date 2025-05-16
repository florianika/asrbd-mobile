import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class DwellingApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getDwellings(String esriToken, String? entranceGlobalId) async {
    return await _apiClient
        .get('${ApiEndpoints.getEsriDwellings(entranceGlobalId)}&token=$esriToken');
  }

  Future<Response> getDwellingAttributes(String esriToken) async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/2?f=json&token=$esriToken');
  }
}
