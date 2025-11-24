import 'dart:convert';

import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/data/dto/dwelling_dto.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class DwellingApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getDwellings(String? entranceGlobalId) async {
    return await _apiClient.get(ApiEndpoints.getEsriDwellings(entranceGlobalId));
  }

  Future<Response> getDwellingsFromEntrancesList(
      List<String> entrancesGlobalId) async {
    return await _apiClient.get(
        ApiEndpoints.getEsriDwellingsByEntranceList(entrancesGlobalId));
  }

  Future<Response> getDwellingAttributes() async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/2?f=json');
  }

  Future<Response> addDwellingFeature(DwellingEntity dwelling) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    DwellingDto dwellingDto = DwellingDto.fromEntity(dwelling);

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([dwellingDto.toGeoJsonFeature()]),
      'rollbackOnFailure': 'true',
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.addEsriFeauture(EntityType.dwelling),
        data: payload);
  }

  Future<Response> getDwellingDetails(int objectId) async {
    return await _apiClient.get(
        ApiEndpoints.getEsriDwellingsByObjectId(objectId));
  }

  Future<Response> updateDwellingFeature(DwellingEntity dwelling) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    DwellingDto dwellingDto = DwellingDto.fromEntity(dwelling);

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([dwellingDto.toGeoJsonFeature()]),
      'rollbackOnFailure': 'true',
    };
    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);
    return _apiClient.post(ApiEndpoints.updateEsriFeauture(EntityType.dwelling),
        data: payload);
  }
}
