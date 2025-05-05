import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/building_service.dart';

class BuildingRepository {
  final BuildingService buildingService;

  BuildingRepository(this.buildingService);

  Future<Map<String, dynamic>> getBuildings() async {
    return await buildingService.getBuildings();
  }

  Future<List<FieldSchema>> getBuildingAttributes() async {
    return await buildingService.getBuildingAttributes();
  }
}
