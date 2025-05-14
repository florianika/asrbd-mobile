import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/dwelling_service.dart';
import 'package:flutter_map/flutter_map.dart';

class DwellingRepository {
  final DwellingService buildingService;

  DwellingRepository(this.buildingService);

  Future<Map<String, dynamic>> getDwellings(LatLngBounds bounds, double zoom) async {
    return await buildingService.getDwellings(bounds, zoom);
  }

  Future<List<FieldSchema>> getDwellingAttributes() async {
    return await buildingService.getDwellingAttributes();
  }
}
