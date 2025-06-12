import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/data/building_repository.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuildingUseCases {
  final BuildingRepository _buildingRepository;
  final CheckUseCases _checkUseCases;

  BuildingUseCases(
    this._buildingRepository,
    this._checkUseCases,
  );

  // Use case for logging in
  Future<Map<String, dynamic>> getBuildings(
      LatLngBounds? bounds, double zoom, int municipalityId) async {
    if (bounds == null) {
      return {};
    }

    if (zoom < EsriConfig.buildingMinZoom) {
      return {};
    }
    return await _buildingRepository.getBuildings(bounds, zoom, municipalityId);
  }

  Future<Map<String, dynamic>> getBuildingDetails(String globalId) async {
    return await _buildingRepository.getBuildingDetails(globalId);
  }

  Future<List<FieldSchema>> getBuildingAttibutes() async {
    return await _buildingRepository.getBuildingAttributes();
  }

  Future<String> addBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    final globalId =
        await _buildingRepository.addBuildingFeature(attributes, points);
    await _checkUseCases.checkAutomatic(
        globalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return globalId;
  }

  Future<String> updateBuildingFeature(Map<String, dynamic> attributes) async {
    final globalId = attributes['GlobalID'];

    await _buildingRepository.updateBuildingFeature(attributes);
    await _checkUseCases.checkAutomatic(
        globalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return globalId;
  }
}
