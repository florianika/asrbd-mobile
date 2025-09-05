import 'package:asrdb/core/models/record_status.dart';
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/buildings.dart';

part 'building_dao.g.dart';

@DriftAccessor(tables: [Buildings])
class BuildingDao extends DatabaseAccessor<AppDatabase>
    with _$BuildingDaoMixin {
  BuildingDao(AppDatabase db) : super(db);

  // 1. Get all buildings
  Future<List<Building>> getAllBuildings() {
    return select(buildings).get();
  }

  Future<List<Building>> getUnsyncedBuildings(int downloadId) {
    // final rows = await db.customSelect(
    //   'SELECT id, record_status FROM buildings',
    //   readsFrom: {db.buildings}, // optional but good practice
    // ).get();

    // for (final row in rows) {
    //   print('id=${row.data['id']}, record_status=${row.data['record_status']}');
    // }

    return (select(buildings)
          ..where((b) => b.recordStatus.isNotValue(RecordStatus.unmodified)))
        .get();
  }

  Future<int> deleteUnmodifiedBuildings(int downloadId) {
    return (delete(buildings)
          ..where((e) => e.recordStatus.equals(RecordStatus.unmodified)))
        .go();
  }

  Future<List<Building>> getBuildingsByDownloadId(int? downloadId) {
    if (downloadId == null) {
      return Future.value([]);
    }

    return (select(buildings)
          ..where((tbl) => tbl.downloadId.equals(downloadId)))
        .get();
  }

  // 2. Get building by id
  Future<Building?> getBuildingById(String globalId) {
    return (select(buildings)..where((tbl) => tbl.globalId.equals(globalId)))
        .getSingleOrNull();
  }

  // 3. Insert or update a single building
  Future<String> insertBuilding(BuildingsCompanion building) async {
    final updatedCompanion = building.copyWith(
      recordStatus: Value(RecordStatus.added),
    );
    await into(buildings).insertOnConflictUpdate(updatedCompanion);
    return building.globalId.value;
  }

  // 4. Bulk insert or update buildings
  Future<void> insertBuildings(List<BuildingsCompanion> buildingList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(buildings, buildingList);
    });
  }

  Future<int> updateBuilding(BuildingsCompanion building) async {
    assert(building.globalId.present, 'globalId must be provided for update');

    // 1. Get the current record from DB
    final current = await (select(buildings)
          ..where((tbl) => tbl.globalId.equals(building.globalId.value)))
        .getSingleOrNull();

    if (current == null) {
      throw Exception('Building not found: ${building.globalId.value}');
    }

    // 2. Determine new status
    final statusToUpdate = (current.recordStatus == RecordStatus.added)
        ? RecordStatus.added
        : RecordStatus.updated;

    // 3. Build a new companion including the conditional status
    final updatedCompanion = building.copyWith(
      recordStatus: Value(statusToUpdate),
    );

    // 4. Execute the update
    return (update(buildings)
          ..where((tbl) => tbl.globalId.equals(building.globalId.value)))
        .write(updatedCompanion);
  }

  // 5. Delete a single building
  Future<int> deleteBuildingByGlobalId(String globalId) async {
    return (delete(buildings)..where((tbl) => tbl.globalId.equals(globalId)))
        .go();
  }

  Future<int> markAsUnmodified(String globalId) async {
    return (update(buildings)..where((tbl) => tbl.globalId.equals(globalId)))
        .write(
      BuildingsCompanion(
        recordStatus: Value(RecordStatus.unmodified),
      ),
    );
  }

  // 6. Delete all buildings
  Future<void> deleteAllBuildings() async {
    await delete(buildings).go();
  }

  // 7. Update only GlobalID based on OBJECTID
  Future<void> updateGlobalIdById({
    required String oldGlobalId,
    required String globalId,
  }) async {
    await (update(buildings)..where((tbl) => tbl.globalId.equals(oldGlobalId)))
        .write(
      BuildingsCompanion(
        globalId: Value(globalId),
      ),
    );
  }
}
