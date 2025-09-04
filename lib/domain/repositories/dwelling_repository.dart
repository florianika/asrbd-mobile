import 'package:asrdb/data/drift/app_database.dart';

abstract class IDwellingRepository {
  Future<List<Dwelling>> getDwellingsByEntranceId(String entranceGlobalId);

  Future<void> insertDwelling(DwellingsCompanion dwelling);

  Future<void> insertDwellings(List<DwellingsCompanion> dwellingList);

  Future<void> deleteDwelling(String globalId);

  Future<void> markAsUnchanged(String globalId);

  Future<void> deleteDwellings();
  Future<Dwelling> getDwellingDetailsByObjectId(int objectId);

  Future<void> updateDwellingOffline(DwellingsCompanion dwelling);

  Future<void> updateDwellingDwlEntGlobalID({
    required String oldDwlEntGlobalID,
    required String newDwlEntGlobalID,
  });

  Future<void> updateDwellingById({
    required int id,
    required String newGlobalId,
  });
}
