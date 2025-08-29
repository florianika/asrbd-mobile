import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/building_service.dart';
import 'package:asrdb/core/services/database_service.dart';
import 'package:asrdb/data/dto/building_dto.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
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
  Future<void> updateBuildingGlobalId(int id, String newGlobalId) =>
      _dao.buildingDao.updateGlobalIdById(id: id, globalId: newGlobalId);

  @override
  Future<List<BuildingEntity>> getBuildings(LatLngBounds bounds, double zoom,
      int municipalityId, bool isOnline) async {
    return await buildingService.getBuildings(bounds, zoom, municipalityId);
  }

  @override
  Future<BuildingEntity> getBuildingDetails(String globalId) async {
    return await buildingService.getBuildingDetails(globalId);
  }

  @override
  Future<List<FieldSchema>> getBuildingAttributes() async {
    return await buildingService.getBuildingAttributes();
  }

  @override
  Future<String> addBuildingFeature(BuildingEntity building) async {
    return await buildingService.addBuildingFeature(building);
  }

  @override
  Future<bool> updateBuildingFeature(BuildingEntity building) async {
    return await buildingService.updateBuildingFeature(building);
  }

  @override
  Future<int> getBuildingsCount(LatLngBounds bounds, int municipalityId) async {
    return await buildingService.getBuildingsCount(bounds, municipalityId);
  }

  @override
  Future<List<Building>> getBuildingsByDownloadId(int? downloadId) {
    return _dao.buildingDao.getBuildingsByDownloadId(downloadId);
  }
}
