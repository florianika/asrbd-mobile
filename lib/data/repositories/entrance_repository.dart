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

  Future<List<EntranceEntity>> getEntrancesByBuildingIdOnline(String entBldGlobalID) async {
    return await entranceService.getEntrancesByBuildingId(entBldGlobalID);
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
  Future<void> updateEntranceOffline(EntrancesCompanion entrance) =>
      _dao.entranceDao.updateEntrance(entrance);


  @override
  Future<Entrance?> getEntranceById(String globalId, int downloadId) =>
      _dao.entranceDao.getEntranceById(globalId, downloadId);

  @override
  Future<List<Entrance>> getEntrancesByBuildingId(
      List<String> buildingGlobalIds, int downloadId) async {
    return await _dao.entranceDao
        .getEntrancesByBuildingId(buildingGlobalIds, downloadId);
  }

  @override
  Future<String> insertEntrance(EntrancesCompanion entrance) async {
    return await _dao.entranceDao.insertEntrance(entrance);
  }

  @override
  Future<void> insertEntrances(List<EntrancesCompanion> entranceList) async {
    await _dao.entranceDao.insertEntrances(entranceList);
  }

  @override
  Future<void> updateEntranceEntBldGlobalID(
      {required String globalId,
      required String newEntBldGlobalID,
      required int downloadId}) async {
    await _dao.entranceDao.updateEntranceEntBldGlobalID(
      globalId: globalId,
      newEntBldGlobalID: newEntBldGlobalID,
      downloadId: downloadId,
    );
  }

  @override
  Future<void> updateEntranceGlobalID(
      {required int id, required String newGlobalId}) async {
    await _dao.entranceDao
        .updateEntranceGlobalID(id: id, newGlobalId: newGlobalId);
  }

  @override
  Future<List<Entrance>> getUnsyncedEntrances(int downloadId) =>
      _dao.entranceDao.getUnsyncedEntrances(downloadId);

  @override
  Future<int> deleteUnmodified(int downloadId) =>
      _dao.entranceDao.deleteUnmodifiedEntrances(downloadId);

  @override
  Future<int> deleteByDownloadId(int downloadId) =>
      _dao.entranceDao.deleteEntrancesByDownloadId(downloadId);

  @override
  Future<void> markAsUnchanged(String globalId, int downloadId) async {
    await _dao.entranceDao.markAsUnmodified(globalId, downloadId);
  }
}
