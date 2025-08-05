import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/drift/tables/entrances.dart';
import 'package:drift/drift.dart';

part 'entrances_dao.g.dart';

@DriftAccessor(tables: [Entrances])
class EntrancesDao extends DatabaseAccessor<AppDatabase> with _$EntrancesDaoMixin {
  EntrancesDao(AppDatabase db) : super(db);

  // Get entrances by list of building GlobalIDs
  Future<List<Entrance>> getEntrancesByBuildingId(List<String> buildingGlobalIds) {
    return (select(entrances)
          ..where((tbl) => tbl.entBldGlobalId.isIn(buildingGlobalIds)))
        .get();
  }

  // Insert or update a single entrance
  Future<void> insertEntrance(Entrance entrance) async {
    await into(entrances).insertOnConflictUpdate(entrance);
  }

  // Bulk insert or update entrances
  Future<void> insertEntrances(List<Entrance> entranceList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(entrances, entranceList);
    });
  }

  // Delete an entrance by GlobalID
  Future<void> deleteEntrance(String globalId) async {
    await (delete(entrances)..where((tbl) => tbl.globalId.equals(globalId))).go();
  }

  // Delete all entrances
  Future<void> deleteEntrances() async {
    await delete(entrances).go();
  }

  // Update EntBldGlobalID by GlobalID
  Future<void> updateEntranceEntBldGlobalID({
    required String globalId,
    required String newEntBldGlobalID,
  }) async {
    await (update(entrances)..where((tbl) => tbl.globalId.equals(globalId))).write(
      EntrancesCompanion(
        entBldGlobalId: Value(newEntBldGlobalID),
      ),
    );
  }

  // Update GlobalID by ObjectID
  Future<void> updateEntranceGlobalID({
    required int objectId,
    required String newGlobalId,
  }) async {
    await (update(entrances)..where((tbl) => tbl.objectId.equals(objectId))).write(
      EntrancesCompanion(
        globalId: Value(newGlobalId),
      ),
    );
  }
}
