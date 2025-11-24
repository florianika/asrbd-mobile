import 'dart:convert';

import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/data/dto/building_dto.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class BuildingApi {
  final EsriApiClient _apiClient = EsriApiClient();

  Future<Response> getBuildings(String geometry, int municipalityId) async {
    return await _apiClient.get(
        ApiEndpoints.getEsriBulding(geometry, municipalityId));
  }

  Future<Response> getBuildingsCount(
      String geometry, int municipalityId) async {
    return await _apiClient.get(
        ApiEndpoints.getEsriBuildingsCount(geometry, municipalityId));
  }

  Future<Response> getBuildingIntersection(
      Map<String, dynamic> geometry) async {
    return await _apiClient.get(
        ApiEndpoints.getEsriBuildingInteresections(geometry));
  }

  Future<Response> getBuildingDetails(String globalId) async {
    return await _apiClient.get(
        ApiEndpoints.getEsriBuildingByGlobalId(globalId));
  }

  Future<Response> getBuildingAttributes() async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/1?f=json');
  }


  Future<Response> addBuildingFeature(BuildingEntity building) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    BuildingDto buildingDto = BuildingDto.fromEntity(building);

    final payload = {
      'f': 'json',
      'features': jsonEncode([buildingDto.toGeoJsonFeature()]),
      'rollbackOnFailure': 'true',
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.addEsriFeauture(EntityType.building),
        data: payload);
  }

  Future<Response> updateBuildingFeature(BuildingDto building) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([building.toGeoJsonFeature()]),
      'rollbackOnFailure': 'true',
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.updateEsriFeauture(EntityType.building),
        data: payload);
  }
}
