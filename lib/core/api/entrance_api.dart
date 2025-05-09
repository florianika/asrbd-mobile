import 'dart:convert';

import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class EntranceApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getEntrances(String esriToken, String geometry) async {
    return await _apiClient
        .get('${ApiEndpoints.getEsriEntrance(geometry)}&token=$esriToken');
  }

  Future<Response> getEntranceAttributes(String esriToken) async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/0?f=json&token=$esriToken');
  }

  Future<Response> addEntranceFeauture(
      String esriToken, Map<String, dynamic> data) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final payload = {
      'f': 'json',
      'adds': jsonEncode(data),
      'token': esriToken
    };

    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.addEsriFeauture(EntityType.entrance),
        data: payload);
  }
}
