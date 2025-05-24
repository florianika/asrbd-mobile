import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/data/dwelling_repository.dart';

class DwellingUseCases {
  final DwellingRepository _dwellingRepository;

  DwellingUseCases(this._dwellingRepository);
  Future<Map<String, dynamic>> getDwellings(
      String? entranceGlobalId) async {
  
    return await _dwellingRepository.getDwellings(entranceGlobalId);
  }

  Future<List<FieldSchema>> getDwellingAttibutes() async {
    return await _dwellingRepository.getDwellingAttributes();
  }

    Future<bool> addDwellingFeature(
      Map<String, dynamic> attributes) async {
    return await _dwellingRepository.addDwellingFeature(attributes);
  }

    Future<Map<String, dynamic>> getDwellingDetails(int objectId) async {
    return await _dwellingRepository.getDwellingDetails(objectId);
  }

   Future<bool> updateDwellingFeature(
      Map<String, dynamic> attributes) async {
    return await _dwellingRepository.updateDwellingFeature(attributes);
  }
}
