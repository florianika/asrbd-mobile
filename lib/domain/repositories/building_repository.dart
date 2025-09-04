import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class IBuildingRepository {
  /// Local DB Operations
  Future<List<Building>> getBuildingsOffline();

  Future<List<Building>> getUnsyncedBuildings(int downloadId);

  Future<List<BuildingEntity>> getBuildingsOnline(
      LatLngBounds bounds, double zoom, int municipalityId);

  Future<void> updateBuildingOffline(BuildingsCompanion building);

  Future<List<Building>> getBuildingsByDownloadId(int downloadId);

  Future<void> insertBuilding(BuildingsCompanion building);

  Future<void> insertBuildings(List<BuildingsCompanion> buildings);

  Future<void> markAsUnchanged(String globalId);

  // Future<void> deleteBuilding(String globalId);

  Future<void> deleteAllBuildings();

  Future<Building?> getBuildingById(String globalId);

  Future<void> updateBuildingGlobalId(String oldGlobalId, String newGlobalId);

  Future<BuildingEntity> getBuildingDetails(String globalId);

  Future<List<FieldSchema>> getBuildingAttributes();

  Future<String> addBuildingFeature(BuildingEntity building);

  Future<bool> updateBuildingFeature(BuildingEntity building);

  Future<int> getBuildingsCount(LatLngBounds bounds, int municipalityId);
}
