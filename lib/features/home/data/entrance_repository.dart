import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/entrance_service.dart';
import 'package:latlong2/latlong.dart';

class EntranceRepository {
  final EntranceService entranceService;

  EntranceRepository(this.entranceService);

  Future<Map<String, dynamic>> getEntrances(
      double zoom, List<String> entBldGlobalID) async {
    return await entranceService.getEntrances(zoom, entBldGlobalID);
  }

  Future<Map<String, dynamic>> getEntranceDetails(String globalId) async {
    return await entranceService.getEntranceDetails(globalId);
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    return await entranceService.getEntranceAttributes();
  }

  Future<bool> addEntranceFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    return await entranceService.addEntranceFeature(attributes, points);
  }

  Future<bool> updateEntranceFeature(
      Map<String, dynamic> attributes) async {
    return await entranceService.updateEntranceFeature(attributes);
  }

  Future<bool> deleteEntranceFeature(String objectId) async {
    return await entranceService.deleteEntranceFeature(objectId);
  }
}
