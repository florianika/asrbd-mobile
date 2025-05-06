import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/data/building_repository.dart';
import 'package:flutter_map/flutter_map.dart';

class BuildingUseCases {
  final BuildingRepository _buildingRepository;

  BuildingUseCases(this._buildingRepository);

  // Use case for logging in
  Future<Map<String, dynamic>> getBuildings(
      LatLngBounds? bounds, double zoom) async {
    if (bounds == null) {
      return {};
    }

    if (zoom < EsriConfig.minZoom) {
      return {};
    }
    return await _buildingRepository.getBuildings(bounds, zoom);
  }

  Future<List<FieldSchema>> getBuildingAttibutes() async {
    return await _buildingRepository.getBuildingAttributes();
  }
}
