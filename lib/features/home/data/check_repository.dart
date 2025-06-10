import 'package:asrdb/core/services/check_service.dart';

class CheckRepository {
  final CheckService checkService;

  CheckRepository(this.checkService);

  Future<bool> checkAutomatic(String buildingGlobalId) async {
    return await checkService.checkAutomatic(buildingGlobalId);
  }

  Future<bool> checkBuildings(String buildingGlobalId) async {
    return await checkService.checkBuildings(buildingGlobalId);
  }
}
