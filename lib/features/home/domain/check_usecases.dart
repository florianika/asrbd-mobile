import 'package:asrdb/features/home/data/check_repository.dart';

class CheckUseCases {
  final CheckRepository _checkRepository;

  CheckUseCases(this._checkRepository);

  Future<bool> checkAutomatic(String buildingGlobalId) async {  
    return await _checkRepository.checkAutomatic(buildingGlobalId);
  }

  Future<bool> checkBuildings(String buildingGlobalId) async {
    return await _checkRepository.checkBuildings(buildingGlobalId);
  }
}
