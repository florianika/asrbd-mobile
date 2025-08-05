import 'package:asrdb/data/drift/app_database.dart';

abstract class IEntranceRepository {
  Future<List<Entrance>> getEntrancesByBuildingId(
      List<String> buildingGlobalIds);

  Future<void> insertEntrance(Entrance entrance);

  Future<void> insertEntrances(List<Entrance> entranceList);

  Future<void> deleteEntrance(String globalId);

  Future<void> deleteEntrances();

  Future<void> updateEntranceEntBldGlobalID({
    required String globalId,
    required String newEntBldGlobalID,
  });

  Future<void> updateEntranceGlobalID({
    required int objectId,
    required String newGlobalId,
  });
}
