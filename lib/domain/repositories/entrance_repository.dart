import 'package:asrdb/data/drift/app_database.dart';

abstract class IEntranceRepository {
  Future<List<Entrance>> getEntrancesByBuildingId(
      List<String> buildingGlobalIds, int downloadId);

  Future<void> insertEntrance(EntrancesCompanion entrance);

  Future<List<Entrance>> getUnsyncedEntrances(int downloadId);

  Future<void> insertEntrances(List<EntrancesCompanion> entranceList);

  // Future<void> deleteEntrance(String globalId);

  Future<Entrance?> getEntranceById(String globalId, int downloadId);

  Future<int> deleteUnmodified(int downloadId);

  Future<int> deleteByDownloadId(int downloadId);

  // Future<void> deleteEntrances();

  Future<void> markAsUnchanged(String globalId, int downloadId);

  Future<void> updateEntranceOffline(EntrancesCompanion entrance);

  Future<void> updateEntranceEntBldGlobalID({
    required String globalId,
    required String newEntBldGlobalID,
    required int downloadId,
  });

  Future<void> updateEntranceGlobalID({
    required int id,
    required String newGlobalId,
  });
}
