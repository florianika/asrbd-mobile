import 'dart:convert';

import 'package:asrdb/core/api/esri_api_client.dart';
import 'package:asrdb/core/enums/entity_type.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
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
        '${ApiEndpoints.getEsriBuldingByGlobalId(globalId)}&token=$esriToken');
  }

  Future<Response> getBuildingAttributes(String esriToken) async {
    return await _apiClient.get(
        '${ApiEndpoints.esriBaseUri.toString()}/1?f=json&token=$esriToken');
  }

  Future<Response> getBuildingsCount(
      String esriToken, String geometry, int municipalityId) async {
    return await _apiClient.get(
        '${ApiEndpoints.getEsriBuildingsCount(geometry, municipalityId)}&token=$esriToken');
  }

  Future<Response> addBuildingFeature(String esriToken,
      Map<String, dynamic> attributes, List<LatLng> points) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    // Convert LatLng points to coordinate arrays for polygon geometry
    List<List<double>> coordinates =
        points.map((point) => [point.longitude, point.latitude]).toList();

    // Ensure the polygon is closed by adding the first point at the end if needed
    if (coordinates.isNotEmpty &&
        (coordinates.first[0] != coordinates.last[0] ||
            coordinates.first[1] != coordinates.last[1])) {
      coordinates.add([coordinates.first[0], coordinates.first[1]]);
    }

    final Map<String, dynamic> feature = {
      'geometry': {
        'rings': [coordinates],
        'spatialReference': {'wkid': 4326},
      },
      'attributes': attributes,
    };

    final payload = {
      'f': 'json',
      'features': jsonEncode([feature]),
      'rollbackOnFailure': 'true',
      'token': esriToken
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.addEsriFeauture(EntityType.building),
        data: payload);
  }

  Future<Response> updateBuildingFeature(String esriToken,
      Map<String, dynamic> attributes, List<LatLng>? points) async {
    Map<String, String> contentType = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    Map<String, dynamic> feature = {};
    if (points != null && points.isNotEmpty) {
      // Convert LatLng points to coordinate arrays for polygon geometry
      List<List<double>> coordinates =
          points.map((point) => [point.longitude, point.latitude]).toList();

      // Ensure the polygon is closed by adding the first point at the end if needed
      if (coordinates.isNotEmpty &&
          (coordinates.first[0] != coordinates.last[0] ||
              coordinates.first[1] != coordinates.last[1])) {
        coordinates.add([coordinates.first[0], coordinates.first[1]]);
      }

      feature = {
        'geometry': {
          'rings': [coordinates],
          'spatialReference': {'wkid': 4326},
        },
        'attributes': attributes,
      };
    } else {
      feature = {
        'attributes': attributes,
      };
    }

    final payload = {
      'f': 'pjson',
      'features': jsonEncode([feature]),
      'rollbackOnFailure': 'true',
      'token': esriToken
    };

    _apiClient.clearHeaders();
    _apiClient.setHeaders(contentType);

    return _apiClient.post(ApiEndpoints.updateEsriFeauture(EntityType.building),
        data: payload);
  }
}
