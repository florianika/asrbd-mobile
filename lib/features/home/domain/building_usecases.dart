import 'package:asrdb/features/home/data/building_repository.dart';

class BuildingUseCases {
  final BuildingRepository _buildingRepository;

  BuildingUseCases(this._buildingRepository);

  // Use case for logging in
  Future<Map<String, dynamic>> getBuildings() async {
    return await _buildingRepository.getBuildings();
  }
}
