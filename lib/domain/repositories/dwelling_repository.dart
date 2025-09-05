import 'package:asrdb/data/drift/app_database.dart';

abstract class IDwellingRepository {
  Future<List<Dwelling>> getDwellingsByEntranceId(String entranceGlobalId);

  Future<void> insertDwelling(DwellingsCompanion dwelling);

  Future<void> insertDwellings(List<DwellingsCompanion> dwellingList);

  Future<void> deleteDwelling(String globalId);

  Future<void> markAsUnchanged(String globalId);

  Future<void> deleteDwellings();

  Future<int> deleteUnmodified(int downloadId);

  Future<Dwelling> getDwellingDetailsByObjectId(int objectId);

  Future<void> updateDwellingOffline(DwellingsCompanion dwelling);

  Future<List<Dwelling>> getUnsyncedDwellings(int downloadId);

  Future<void> updateDwellingDwlEntGlobalID({
    required String oldDwlEntGlobalID,
    required String newDwlEntGlobalID,
  });

  Future<void> updateDwellingById({
    required String oldGlobalId,
    required String newGlobalId,
  });
}
