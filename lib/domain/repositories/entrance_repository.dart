import 'package:asrdb/data/drift/app_database.dart';

abstract class IEntranceRepository {
  Future<List<Entrance>> getEntrancesByBuildingId(
      List<String> buildingGlobalIds);

  Future<void> insertEntrance(EntrancesCompanion entrance);

  Future<void> insertEntrances(List<EntrancesCompanion> entranceList);

  Future<void> deleteEntrance(String globalId);

  Future<Entrance?> getEntranceById(String globalId);

  Future<void> deleteEntrances();

  Future<void> updateEntranceOffline(EntrancesCompanion entrance);

  Future<void> updateEntranceEntBldGlobalID({
    required String globalId,
    required String newEntBldGlobalID,
  });

  Future<void> updateEntranceGlobalID({
    required int id,
    required String newGlobalId,
  });
}
