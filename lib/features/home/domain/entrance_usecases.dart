import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/data/entrance_repository.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EntranceUseCases {
  final EntranceRepository _entranceRepository;

  EntranceUseCases(this._entranceRepository);

  Future<Map<String, dynamic>> getEntrances(
      LatLngBounds? bounds, double zoom) async {
    if (bounds == null) {
      return {};
    }

    if (zoom < EsriConfig.minZoom) {
      return {};
    }

    return await _entranceRepository.getEntrances(bounds, zoom);
  }

  Future<Map<String, dynamic>> getEntranceDetails(String globalId) async {
    return await _entranceRepository.getEntranceDetails(globalId);
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    return await _entranceRepository.getEntranceAttributes();
  }

  Future<bool> addEntranceFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    return await _entranceRepository.addEntranceFeature(attributes, points);
  }

  Future<bool> updateEntranceFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    return await _entranceRepository.updateEntranceFeature(attributes, points);
  }

  Future<bool> deleteEntranceFeature(String objectId) async {
    return await _entranceRepository.deleteEntranceFeature(objectId);
  }
}
