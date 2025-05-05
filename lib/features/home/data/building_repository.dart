import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/building_service.dart';
import 'package:flutter_map/flutter_map.dart';

class BuildingRepository {
  final BuildingService buildingService;

  BuildingRepository(this.buildingService);

  Future<Map<String, dynamic>> getBuildings(LatLngBounds bounds, double zoom) async {
    return await buildingService.getBuildings(bounds, zoom);
  }

  Future<List<FieldSchema>> getBuildingAttributes() async {
    return await buildingService.getBuildingAttributes();
  }
}
