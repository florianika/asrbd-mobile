import 'dart:convert';

import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:asrdb/core/enums/entity_type.dart';
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
 
   Future<Response> getDwellingAttributesJson(String esriToken) async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/2?f=pjson&token=$esriToken');
   }

 
    Future<Response> addDwellingFeature(String esriToken,
      Map<String, dynamic> attributes, ) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final Map<String, dynamic> feature = {
      'attributes': attributes,
    };

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([feature]),
      'rollbackOnFailure': 'true',
      'token': esriToken
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.addEsriFeauture(EntityType.dwelling),
        data: payload);
  }
  
  Future<Response> getDwellingDetails(String esriToken, int objectId) async {
    return await _apiClient.get(
        '${ApiEndpoints.getEsriDwellingsByObjectId(objectId)}&token=$esriToken');
  }

   Future<Response> updateDwellingFeature(String esriToken,
      Map<String, dynamic> attributes) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final Map<String, dynamic> feature = {
      'attributes': attributes,
    };

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([feature]),
      'rollbackOnFailure': 'true',
      'token': esriToken
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);
    return _apiClient.post(ApiEndpoints.updateEsriFeauture(EntityType.dwelling),
        data: payload);
  }
}
