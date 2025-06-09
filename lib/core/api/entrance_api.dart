import 'dart:convert';

import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'api_endpoints.dart';

class EntranceApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getEntrances(
      String esriToken, List<String> entBldGlobalID) async {
    return await _apiClient.get(
        '${ApiEndpoints.getEsriEntrance(entBldGlobalID)}&token=$esriToken');
  }

  Future<Response> getEntranceDetails(String esriToken, String globalId) async {
    return await _apiClient.get(
        '${ApiEndpoints.getEsriEntranceByGlobalId(globalId)}&token=$esriToken');
  }

  Future<Response> getEntranceAttributes(String esriToken) async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/0?f=json&token=$esriToken');
  }

  Future<Response> addEntranceFeature(String esriToken,
      Map<String, dynamic> attributes, List<LatLng> points) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final Map<String, dynamic> feature = {
      'geometry': {
        'x': points[0].longitude,
        'y': points[0].latitude,
        'spatialReference': {'wkid': 4326},
      },
      'properties': attributes,
    };

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([feature]),
      'rollbackOnFailure': 'true',
      'token': esriToken
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.addEsriFeauture(EntityType.entrance),
        data: payload);
  }

  Future<Response> updateEntranceFeature(String esriToken,
      Map<String, dynamic> attributes) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final Map<String, dynamic> feature = {
      // 'geometry': {
      //   'x': points[0].longitude,
      //   'y': points[0].latitude,
      //   'spatialReference': {'wkid': 4326},
      // },
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

    return _apiClient.post(ApiEndpoints.updateEsriFeauture(EntityType.entrance),
        data: payload);
  }

  Future<Response> deleteEntranceFeature(
      String esriToken, String objectId) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final payload = {
      'objectIds': objectId,
      'where': '',
      'geometry': '',
      'inSR': '',
      'spatialRel': 'esriSpatialRelIntersects',
      'gdbVersion': '',
      'rollbackOnFailure': 'true',
      'returnDeleteResults': 'false',
      'async': 'false',
      'f': 'pjson',
      'token': esriToken
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.deleteEsriFeauture(EntityType.entrance),
        data: payload);
  }
}
