import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

abstract class IBuildingRepository {
  /// Local DB Operations
  Future<List<Building>> getAllBuildings();

  Future<void> insertBuilding(Building building);

  Future<void> insertBuildings(List<Building> buildings);

  // Future<void> deleteBuilding(String globalId);

  Future<void> deleteAllBuildings();

  Future<Building?> getBuildingById(String globalId);

  Future<void> updateBuildingGlobalId(int objectId, String newGlobalId);

  /// Remote / Service Operations
  Future<Map<String, dynamic>> getBuildings(
      LatLngBounds bounds, double zoom, int municipalityId);

  Future<Map<String, dynamic>> getBuildingDetails(String globalId);

  Future<List<FieldSchema>> getBuildingAttributes();

  Future<String> addBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points);

  Future<bool> updateBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng>? points);
}
