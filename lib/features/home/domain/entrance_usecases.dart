import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/data/entrance_repository.dart';

class EntranceUseCases {
  final EntranceRepository _entranceRepository;

  EntranceUseCases(this._entranceRepository);

  // Use case for logging in
  Future<Map<String, dynamic>> getEntrances() async {
    return await _entranceRepository.getEntrances();
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    return await _entranceRepository.getEntranceAttributes();
  }
}
