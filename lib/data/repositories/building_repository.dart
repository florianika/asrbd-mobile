import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/building_service.dart';
import 'package:asrdb/core/services/database_service.dart';
import 'package:asrdb/domain/repositories/building_repository.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuildingRepository implements IBuildingRepository {
  final DatabaseService _dao;
  final BuildingService buildingService;

  BuildingRepository(this._dao, this.buildingService);

  @override
  Future<List<Building>> getAllBuildings() =>
      _dao.buildingDao.getAllBuildings();

  @override
  Future<void> insertBuilding(Building building) =>
      _dao.buildingDao.insertBuilding(building);

  @override
  Future<void> insertBuildings(List<Building> buildings) =>
      _dao.buildingDao.insertBuildings(buildings);

  // Future<void> deleteBuilding(String globalId) => _dao.deleteBuilding(globalId);

  @override
  Future<void> deleteAllBuildings() => _dao.buildingDao.deleteAllBuildings();

  @override
  Future<Building?> getBuildingById(String globalId) =>
      _dao.buildingDao.getBuildingById(globalId);

  @override
  Future<void> updateBuildingGlobalId(int objectId, String newGlobalId) =>
      _dao.buildingDao
          .updateGlobalIdByObjectId(objectId: objectId, globalId: newGlobalId);

  @override
  Future<Map<String, dynamic>> getBuildings(
      LatLngBounds bounds, double zoom, int municipalityId) async {
    return await buildingService.getBuildings(bounds, zoom, municipalityId);
  }

  @override
  Future<Map<String, dynamic>> getBuildingDetails(String globalId) async {
    return await buildingService.getBuildingDetails(globalId);
  }

  @override
  Future<List<FieldSchema>> getBuildingAttributes() async {
    return await buildingService.getBuildingAttributes();
  }

  @override
  Future<String> addBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    return await buildingService.addBuildingFeature(attributes, points);
  }

  @override
  Future<bool> updateBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng>? points) async {
    return await buildingService.updateBuildingFeature(attributes, points);
  }
}
