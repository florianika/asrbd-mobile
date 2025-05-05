import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/data/building_repository.dart';

class BuildingUseCases {
  final BuildingRepository _buildingRepository;

  BuildingUseCases(this._buildingRepository);

  // Use case for logging in
  Future<Map<String, dynamic>> getBuildings() async {
    return await _buildingRepository.getBuildings();
  }
 
  Future<List<FieldSchema>> getBuildingAttibutes() async {
    return await _buildingRepository.getBuildingAttributes();
  }
}
