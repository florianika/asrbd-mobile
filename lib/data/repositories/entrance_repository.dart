import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/database_service.dart';
import 'package:asrdb/core/services/entrance_service.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/domain/repositories/entrance_repository.dart';

class EntranceRepository implements IEntranceRepository {
  final EntranceService entranceService;
  final DatabaseService _dao;

  EntranceRepository(this._dao, this.entranceService);

  Future<List<EntranceEntity>> getEntrances(List<String> entBldGlobalID) async {
    return await entranceService.getEntrances(entBldGlobalID);
  }

  Future<EntranceEntity> getEntranceDetails(String globalId) async {
    return await entranceService.getEntranceDetails(globalId);
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    return await entranceService.getEntranceAttributes();
  }

  Future<String> addEntranceFeature(EntranceEntity entrance) async {
    return await entranceService.addEntranceFeature(entrance);
  }

  Future<bool> updateEntranceFeature(EntranceEntity entrance) async {
    return await entranceService.updateEntranceFeature(entrance);
  }

  Future<bool> deleteEntranceFeature(String objectId) async {
    return await entranceService.deleteEntranceFeature(objectId);
  }

  @override
  Future<void> deleteEntrance(String globalId) async {
    await _dao.entranceDao.deleteEntrance(globalId);
  }

  @override
  Future<void> deleteEntrances() async {
    await _dao.entranceDao.deleteEntrances();
  }

  @override
  Future<Entrance?> getEntranceById(String globalId) =>
      _dao.entranceDao.getEntranceById(globalId);

  @override
  Future<List<Entrance>> getEntrancesByBuildingId(
      List<String> buildingGlobalIds) async {
    return await _dao.entranceDao.getEntrancesByBuildingId(buildingGlobalIds);
  }

  @override
  Future<void> insertEntrance(EntrancesCompanion entrance) async {
    await _dao.entranceDao.insertEntrance(entrance);
  }

  @override
  Future<void> insertEntrances(List<EntrancesCompanion> entranceList) async {
    await _dao.entranceDao.insertEntrances(entranceList);
  }

  @override
  Future<void> updateEntranceEntBldGlobalID(
      {required String globalId, required String newEntBldGlobalID}) async {
    await _dao.entranceDao.updateEntranceEntBldGlobalID(
        globalId: globalId, newEntBldGlobalID: newEntBldGlobalID);
  }

  @override
  Future<void> updateEntranceGlobalID(
      {required int id, required String newGlobalId}) async {
    await _dao.entranceDao
        .updateEntranceGlobalID(id: id, newGlobalId: newGlobalId);
  }
}
