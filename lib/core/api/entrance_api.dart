import 'dart:convert';

import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/data/dto/entrance_dto.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class EntranceApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getEntrances(List<String> entBldGlobalID) async {
    return await _apiClient.get(ApiEndpoints.getEsriEntrance(entBldGlobalID));
  }

  Future<Response> getEntrancesByBuildingId(String entBldGlobalID) async {
    return await _apiClient.get(
        ApiEndpoints.getEsriEntrancesByGlobalId(entBldGlobalID));
  }

  Future<Response> getEntranceDetails(String globalId) async {
    return await _apiClient.get(ApiEndpoints.getEsriEntranceByGlobalId(globalId));
  }

  Future<Response> getEntranceAttributes() async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/0?f=json');
  }

  Future<Response> addEntranceFeature(EntranceEntity entrance) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    EntranceDto entranceDto = EntranceDto.fromEntity(entrance);

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([entranceDto.toGeoJsonFeature()]),
      'rollbackOnFailure': 'true',
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.addEsriFeauture(EntityType.entrance),
        data: payload);
  }

  Future<Response> updateEntranceFeature(EntranceEntity entrance) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    EntranceDto entranceDto = EntranceDto.fromEntity(entrance);

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([entranceDto.toGeoJsonFeature()]),
      'rollbackOnFailure': 'true',
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.updateEsriFeauture(EntityType.entrance),
        data: payload);
  }

  Future<Response> deleteEntranceFeature(String objectId) async {
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
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.deleteEsriFeauture(EntityType.entrance),
        data: payload);
  }
}
