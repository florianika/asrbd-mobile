import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/database_service.dart';
import 'package:asrdb/core/services/dwelling_service.dart';
import 'package:asrdb/data/drift/app_database.dart';
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
      List<String> entranceGlobalIds) async {
    return await _dao.dwellingDao.getDwellingsByEntranceId(entranceGlobalIds);
  }

  @override
  Future<void> insertDwelling(Dwelling dwelling) async {
    await _dao.dwellingDao.insertDwelling(dwelling);
  }

  @override
  Future<void> insertDwellings(List<Dwelling> dwellingList) async {
    await _dao.dwellingDao.insertDwellings(dwellingList);
  }

  @override
  Future<void> updateDwellingDwlEntGlobalID(
      {required String globalId, required String newDwlEntGlobalID}) async {
    await _dao.dwellingDao.updateDwellingDwlEntGlobalID(
        globalId: globalId, newDwlEntGlobalID: newDwlEntGlobalID);
  }

  @override
  Future<void> updateDwellingGlobalID(
      {required int objectId, required String newGlobalId}) async {
    await _dao.dwellingDao
        .updateDwellingGlobalID(objectId: objectId, newGlobalId: newGlobalId);
  }

  Future<Map<String, dynamic>> getDwellings(String? entranceGlobalId) async {
    return await dwellingService.getDwellings(entranceGlobalId);
  }

  Future<List<FieldSchema>> getDwellingAttributes() async {
    return await dwellingService.getDwellingAttributes();
  }

  Future<bool> addDwellingFeature(Map<String, dynamic> attributes) async {
    return await dwellingService.addDwellingFeature(attributes);
  }

  Future<Map<String, dynamic>> getDwellingDetails(int objectId) async {
    return await dwellingService.getDwellingDetails(objectId);
  }

  Future<bool> updateDwellingFeature(Map<String, dynamic> attributes) async {
    return await dwellingService.updateDwellingFeature(attributes);
  }
}
