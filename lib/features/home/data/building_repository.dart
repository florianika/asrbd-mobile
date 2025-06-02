import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/building_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuildingRepository {
  final BuildingService buildingService;

  BuildingRepository(this.buildingService);

  Future<Map<String, dynamic>> getBuildings(
      LatLngBounds bounds, double zoom, int municipalityId) async {
    return await buildingService.getBuildings(bounds, zoom, municipalityId);
  }

  Future<List<FieldSchema>> getBuildingAttributes() async {
    return await buildingService.getBuildingAttributes();
  }

  Future<bool> addBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    return await buildingService.addBuildingFeature(attributes, points);
  }

  Future<bool> updateBuildingFeature(
      Map<String, dynamic> attributes) async {
    return await buildingService.updateBuildingFeature(attributes);
  }
}
