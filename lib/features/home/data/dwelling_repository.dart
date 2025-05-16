import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/dwelling_service.dart';


class DwellingRepository {
  final DwellingService dwellingService;

  DwellingRepository(this.dwellingService);

  Future<Map<String, dynamic>> getDwellings(String? entranceGlobalId) async {
    return await dwellingService.getDwellings(entranceGlobalId);
  }

  Future<List<FieldSchema>> getDwellingAttributes() async {
    return await dwellingService.getDwellingAttributes();
  }
}
