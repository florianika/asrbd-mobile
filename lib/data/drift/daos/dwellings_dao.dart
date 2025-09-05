import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/drift/tables/dwellings.dart' show Dwellings;
import 'package:drift/drift.dart';

part 'dwellings_dao.g.dart';

@DriftAccessor(tables: [Dwellings])
class DwellingsDao extends DatabaseAccessor<AppDatabase>
    with _$DwellingsDaoMixin {
  DwellingsDao(AppDatabase db) : super(db);

  // Get dwellings by list of entrance GlobalIDs
  Future<List<Dwelling>> getDwellingsByEntranceId(String entranceGlobalId) {
    return (select(dwellings)
          ..where((tbl) => tbl.dwlEntGlobalId.equals(entranceGlobalId)))
        .get();
  }

  Future<List<Dwelling>> getUnsyncedDwellings(int downloadId) {
    return (select(dwellings)
          ..where((b) => b.recordStatus.isNotValue(RecordStatus.unmodified)))
        .get();
  }

  Future<Dwelling> getDwellingsByObjectId(int objectId) {
    return (select(dwellings)..where((tbl) => tbl.objectId.equals(objectId)))
        .getSingle();
  }

  // Insert or update a single dwelling
  Future<String> insertDwelling(DwellingsCompanion dwelling) async {
    final updatedCompanion = dwelling.copyWith(
      recordStatus: Value(RecordStatus.added),
    );
    await into(dwellings).insertOnConflictUpdate(updatedCompanion);
    return dwelling.globalId.value;
  }

  Future<int> markAsUnmodified(String globalId) async {
    return (update(dwellings)..where((tbl) => tbl.globalId.equals(globalId)))
        .write(
      DwellingsCompanion(
        recordStatus: Value(RecordStatus.unmodified),
      ),
    );
  }

  Future<int> updateDwelling(DwellingsCompanion dwelling) async {
    assert(dwelling.globalId.present, 'globalId must be provided for update');

    // 1. Get the current record from DB
    final current = await (select(dwellings)
          ..where((tbl) => tbl.globalId.equals(dwelling.globalId.value)))
        .getSingleOrNull();

    if (current == null) {
      throw Exception('dwelling not found: ${dwelling.globalId.value}');
    }

    // 2. Determine new status
    final statusToUpdate = (current.recordStatus == RecordStatus.added)
        ? RecordStatus.added
        : RecordStatus.updated;

    // 3. Build a new companion including the conditional status
    final updatedCompanion = dwelling.copyWith(
      recordStatus: Value(statusToUpdate),
    );

    // 4. Execute the update
    return (update(dwellings)
          ..where((tbl) => tbl.globalId.equals(dwelling.globalId.value)))
        .write(updatedCompanion);
  }

  // Bulk insert or update dwellings
  Future<void> insertDwellings(List<DwellingsCompanion> dwellingList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(dwellings, dwellingList);
    });
  }

  // Delete a dwelling by GlobalID
  Future<void> deleteDwelling(String globalId) async {
    await (delete(dwellings)..where((tbl) => tbl.globalId.equals(globalId)))
        .go();
  }

  // Delete all dwellings
  Future<void> deleteDwellings() async {
    await delete(dwellings).go();
  }

  // Update DwlEntGlobalID by GlobalID
  Future<void> updateDwellingDwlEntGlobalID({
    required String oldDwlEntGlobalID,
    required String newDwlEntGlobalID,
  }) async {
    await (update(dwellings)
          ..where((tbl) => tbl.dwlEntGlobalId.equals(oldDwlEntGlobalID)))
        .write(
      DwellingsCompanion(
        dwlEntGlobalId: Value(newDwlEntGlobalID),
      ),
    );
  }

  // Update GlobalID by ObjectID
  Future<void> updateDwellingById({
    required String oldGlobalId,
    required String newGlobalId,
  }) async {
    await (update(dwellings)..where((tbl) => tbl.globalId.equals(oldGlobalId)))
        .write(
      DwellingsCompanion(
        globalId: Value(newGlobalId),
      ),
    );
  }

  Future<int> deleteUnmodifiedDwellings(int downloadId) {
    return (delete(dwellings)
          ..where((e) => e.recordStatus.equals(RecordStatus.unmodified)))
        .go();
  }
}
