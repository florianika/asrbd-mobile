import 'package:asrdb/core/api/api_client.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class MunicipalityApi {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getMunicipality(int municipalityId) async {
    _apiClient.clearHeaders();
    return await _apiClient
        .get(ApiEndpoints.getEsriMunicipality(municipalityId));
  }
}
