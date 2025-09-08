import 'package:asrdb/data/drift/app_database.dart';

abstract class IDwellingRepository {
  Future<List<Dwelling>> getDwellingsByEntranceId(
      String entranceGlobalId, int downloadId);

  Future<void> insertDwelling(DwellingsCompanion dwelling);

  Future<void> insertDwellings(List<DwellingsCompanion> dwellingList);

  // Future<void> deleteDwelling(String globalId);

  Future<void> markAsUnchanged(String globalId, int downloadId);

  // Future<void> deleteDwellings();

  Future<int> deleteUnmodified(int downloadId);

  Future<Dwelling> getDwellingDetailsByObjectId(int objectId, int downloadId);

  Future<void> updateDwellingOffline(DwellingsCompanion dwelling);

  Future<List<Dwelling>> getUnsyncedDwellings(int downloadId);

  Future<void> updateDwellingDwlEntGlobalID({
    required String oldDwlEntGlobalID,
    required String newDwlEntGlobalID,
    required int downloadId,
  });

  Future<void> updateDwellingById({
    required String oldGlobalId,
    required String newGlobalId,
    required int downloadId,
  });
}
