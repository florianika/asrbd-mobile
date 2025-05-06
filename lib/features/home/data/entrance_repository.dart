import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/entrance_service.dart';
import 'package:flutter_map/flutter_map.dart';

class EntranceRepository {
  final EntranceService entranceService;

  EntranceRepository(this.entranceService);

  // Login method
  Future<Map<String, dynamic>> getEntrances(LatLngBounds bounds, double zoom) async {
    return await entranceService.getEntrances(bounds, zoom);
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    return await entranceService.getEntranceAttributes();
  }
}
