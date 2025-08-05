import 'package:asrdb/data/drift/app_database.dart';

abstract class IDwellingRepository {
  Future<List<Dwelling>> getDwellingsByEntranceId(
      List<String> entranceGlobalIds);

  Future<void> insertDwelling(Dwelling dwelling);

  Future<void> insertDwellings(List<Dwelling> dwellingList);

  Future<void> deleteDwelling(String globalId);

  Future<void> deleteDwellings();

  Future<void> updateDwellingDwlEntGlobalID({
    required String globalId,
    required String newDwlEntGlobalID,
  });

  Future<void> updateDwellingById({
    required int id,
    required String newGlobalId,
  });
}
