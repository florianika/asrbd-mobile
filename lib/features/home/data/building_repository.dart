import 'package:asrdb/core/services/building_service.dart';

class BuildingRepository {
  final BuildingService buildingService;

  BuildingRepository(this.buildingService);

  Future<Map<String, dynamic>> getBuildings() async {
    return await buildingService.getBuildings();
  }
}
