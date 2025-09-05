import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/database_service.dart';
import 'package:asrdb/core/services/dwelling_service.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/domain/repositories/dwelling_repository.dart';

class DwellingRepository implements IDwellingRepository {
  final DatabaseService _dao;
  final DwellingService dwellingService;

  DwellingRepository(this._dao, this.dwellingService);

  @override
  Future<void> deleteDwelling(String globalId) async {
    await _dao.dwellingDao.deleteDwelling(globalId);
  }

  @override
  Future<void> deleteDwellings() async {
    await _dao.dwellingDao.deleteDwellings();
  }

  @override
  Future<List<Dwelling>> getDwellingsByEntranceId(
      String entranceGlobalId) async {
    return await _dao.dwellingDao.getDwellingsByEntranceId(entranceGlobalId);
  }

  @override
  Future<String> insertDwelling(DwellingsCompanion dwelling) async {
    return await _dao.dwellingDao.insertDwelling(dwelling);
  }

  @override
  Future<void> insertDwellings(List<DwellingsCompanion> dwellingList) async {
    await _dao.dwellingDao.insertDwellings(dwellingList);
  }

  @override
  Future<void> updateDwellingDwlEntGlobalID(
      {required String oldDwlEntGlobalID,
      required String newDwlEntGlobalID}) async {
    await _dao.dwellingDao.updateDwellingDwlEntGlobalID(
        oldDwlEntGlobalID: oldDwlEntGlobalID,
        newDwlEntGlobalID: newDwlEntGlobalID);
  }

  @override
  Future<void> updateDwellingById(
      {required String oldGlobalId, required String newGlobalId}) async {
    await _dao.dwellingDao
        .updateDwellingById(oldGlobalId: oldGlobalId, newGlobalId: newGlobalId);
  }

  @override
  Future<void> updateDwellingOffline(DwellingsCompanion dwelling) =>
      _dao.dwellingDao.updateDwelling(dwelling);

  Future<List<DwellingEntity>> getDwellings(String? entranceGlobalId) async {
    return await dwellingService.getDwellings(entranceGlobalId);
  }

  Future<List<DwellingEntity>> getDwellingsByEntrancesList(
      List<String> entranceGlobalIds) async {
    return await dwellingService.getDwellingsByEntrancesList(entranceGlobalIds);
  }

  Future<List<FieldSchema>> getDwellingAttributes() async {
    return await dwellingService.getDwellingAttributes();
  }

  Future<String> addDwellingFeature(DwellingEntity dwelling) async {
    return await dwellingService.addDwellingFeature(dwelling);
  }

  Future<DwellingEntity> getDwellingDetails(int objectId) async {
    return await dwellingService.getDwellingDetails(objectId);
  }

  @override
  Future<Dwelling> getDwellingDetailsByObjectId(int objectId) async {
    return _dao.dwellingDao.getDwellingsByObjectId(objectId);
  }

  Future<bool> updateDwellingFeature(DwellingEntity dwelling) async {
    return await dwellingService.updateDwellingFeature(dwelling);
  }

  @override
  Future<void> markAsUnchanged(String globalId) async {
    await _dao.dwellingDao.markAsUnmodified(globalId);
  }

  @override
  Future<List<Dwelling>> getUnsyncedDwellings(int downloadId) =>
      _dao.dwellingDao.getUnsyncedDwellings(downloadId);

  @override
  Future<int> deleteUnmodified(int downloadId) =>
      _dao.dwellingDao.deleteUnmodifiedDwellings(downloadId);
}
