import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/entrance_service.dart';

class EntranceRepository {
  final EntranceService entranceService;

  EntranceRepository(this.entranceService);

  // Login method
  Future<Map<String, dynamic>> getEntrances() async {
    return await entranceService.getEntrances();
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    return await entranceService.getEntranceAttributes();
  }
}
