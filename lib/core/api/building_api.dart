import 'dart:convert';

import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/data/dto/building_dto.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class BuildingApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getBuildings(
      String esriToken, String geometry, int municipalityId) async {
    return await _apiClient.get(
        '${ApiEndpoints.getEsriBulding(geometry, municipalityId)}&token=$esriToken');
  }

  Future<Response> getBuildingsCount(
      String esriToken, String geometry, int municipalityId) async {
    return await _apiClient.get(
        '${ApiEndpoints.getEsriBuildingsCount(geometry, municipalityId)}&token=$esriToken');
  }

  Future<Response> getBuildingIntersection(
      String esriToken, Map<String, dynamic> geometry) async {
    return await _apiClient.get(
        '${ApiEndpoints.getEsriBuildingInteresections(geometry)}&token=$esriToken');
  }

  Future<Response> getBuildingDetails(String esriToken, String globalId) async {
    return await _apiClient.get(
        '${ApiEndpoints.getEsriBuildingByGlobalId(globalId)}&token=$esriToken');
  }

  Future<Response> getBuildingAttributes(String esriToken) async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/1?f=json&token=$esriToken');
  }

  Future<Response> getBuildingAttributesJson(String esriToken) async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/1?f=pjson&token=$esriToken');
  }

  Future<Response> addBuildingFeature(
      String esriToken, BuildingEntity building) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    BuildingDto buildingDto = BuildingDto.fromEntity(building);

    final payload = {
      'f': 'json',
      'features': jsonEncode([buildingDto.toGeoJsonFeature()]),
      'rollbackOnFailure': 'true',
      'token': esriToken
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.addEsriFeauture(EntityType.building),
        data: payload);
  }

  Future<Response> updateBuildingFeature(
      String esriToken, BuildingDto building) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([building.toGeoJsonFeature()]),
      'rollbackOnFailure': 'true',
      'token': esriToken
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.updateEsriFeauture(EntityType.building),
        data: payload);
  }
}
