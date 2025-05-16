import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/data/dwelling_repository.dart';
import 'package:flutter_map/flutter_map.dart';

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
}
