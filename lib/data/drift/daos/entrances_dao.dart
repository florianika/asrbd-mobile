import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/drift/tables/entrances.dart';
import 'package:drift/drift.dart';

part 'entrances_dao.g.dart';

@DriftAccessor(tables: [Entrances])
class EntrancesDao extends DatabaseAccessor<AppDatabase>
    with _$EntrancesDaoMixin {
  EntrancesDao(AppDatabase db) : super(db);

  // Get entrances by list of building GlobalIDs
  Future<List<Entrance>> getEntrancesByBuildingId(
      List<String> buildingGlobalIds, int downloadId) {
    return (select(entrances)
          ..where((tbl) =>
              tbl.entBldGlobalId.isIn(buildingGlobalIds) &
              tbl.downloadId.equals(downloadId)))
        .get();
  }

  Future<List<Entrance>> getUnsyncedEntrances(int downloadId) {
    return (select(entrances)
          ..where((b) => b.recordStatus.isNotValue(RecordStatus.unmodified)))
        .get();
  }

  Future<int> markAsUnmodified(String globalId, int downloadId) async {
    return (update(entrances)
          ..where((tbl) =>
              tbl.globalId.equals(globalId) &
              tbl.downloadId.equals(downloadId)))
        .write(
      EntrancesCompanion(
        recordStatus: Value(RecordStatus.unmodified),
      ),
    );
  }

  Future<int> deleteUnmodifiedEntrances(int downloadId) {
    return (delete(entrances)
          ..where((e) => e.recordStatus.equals(RecordStatus.unmodified)))
        .go();
  }

  // Insert or update a single entrance
  // Future<void> insertEntrance(EntrancesCompanion entrance) async {
  //   await into(entrances).insertOnConflictUpdate(entrance);
  // }

  Future<String> insertEntrance(EntrancesCompanion entrance) async {
    final updatedCompanion = entrance.copyWith(
      recordStatus: Value(RecordStatus.added),
    );
    await into(entrances).insertOnConflictUpdate(updatedCompanion);
    return entrance.globalId.value;
  }

  Future<Entrance?> getEntranceById(String globalId, int downloadId) {
    return (select(entrances)
          ..where((tbl) =>
              tbl.globalId.equals(globalId) &
              tbl.downloadId.equals(downloadId)))
        .getSingleOrNull();
  }

  // Bulk insert or update entrances
  Future<void> insertEntrances(List<EntrancesCompanion> entranceList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(entrances, entranceList);
    });
  }

  // Delete an entrance by GlobalID
  // Future<void> deleteEntrance(String globalId) async {
  //   await (delete(entrances)..where((tbl) => tbl.globalId.equals(globalId)))
  //       .go();
  // }

  Future<int> updateEntrance(EntrancesCompanion entrance) async {
    assert(entrance.globalId.present, 'globalId must be provided for update');

    // 1. Get the current record from DB
    final current = await (select(entrances)
          ..where((tbl) =>
              tbl.globalId.equals(entrance.globalId.value) &
              tbl.downloadId.equals(entrance.downloadId.value)))
        .getSingleOrNull();

    if (current == null) {
      throw Exception('entrance not found: ${entrance.globalId.value}');
    }

    // 2. Determine new status
    final statusToUpdate = (current.recordStatus == RecordStatus.added)
        ? RecordStatus.added
        : RecordStatus.updated;

    // 3. Build a new companion including the conditional status
    final updatedCompanion = entrance.copyWith(
      recordStatus: Value(statusToUpdate),
    );

    // 4. Execute the update
    return (update(entrances)
          ..where((tbl) =>
              tbl.globalId.equals(entrance.globalId.value) &
              tbl.downloadId.equals(entrance.downloadId.value)))
        .write(updatedCompanion);
  }

  // Delete all entrances
  // Future<void> deleteEntrances() async {
  //   await delete(entrances).go();
  // }

  // Update EntBldGlobalID by GlobalID
  Future<void> updateEntranceEntBldGlobalID({
    required String globalId,
    required String newEntBldGlobalID,
    required int downloadId,
  }) async {
    await (update(entrances)
          ..where((tbl) =>
              tbl.globalId.equals(globalId) &
              tbl.downloadId.equals(downloadId)))
        .write(
      EntrancesCompanion(
        entBldGlobalId: Value(newEntBldGlobalID),
      ),
    );
  }

  // Update GlobalID by ObjectID
  Future<void> updateEntranceGlobalID({
    required int id,
    required String newGlobalId,
  }) async {
    await (update(entrances)..where((tbl) => tbl.id.equals(id))).write(
      EntrancesCompanion(
        globalId: Value(newGlobalId),
      ),
    );
  }
}
