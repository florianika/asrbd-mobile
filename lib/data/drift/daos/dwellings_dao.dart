import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/drift/tables/dwellings.dart' show Dwellings;
import 'package:drift/drift.dart';

part 'dwellings_dao.g.dart';

@DriftAccessor(tables: [Dwellings])
class DwellingsDao extends DatabaseAccessor<AppDatabase>
    with _$DwellingsDaoMixin {
  DwellingsDao(AppDatabase db) : super(db);

  // Get dwellings by list of entrance GlobalIDs
  Future<List<Dwelling>> getDwellingsByEntranceId(
      List<String> entranceGlobalIds) {
    return (select(dwellings)
          ..where((tbl) => tbl.dwlEntGlobalId.isIn(entranceGlobalIds)))
        .get();
  }

  // Insert or update a single dwelling
  Future<void> insertDwelling(Dwelling dwelling) async {
    await into(dwellings).insertOnConflictUpdate(dwelling);
  }

  // Bulk insert or update dwellings
  Future<void> insertDwellings(List<Dwelling> dwellingList) async {
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
    required String globalId,
    required String newDwlEntGlobalID,
  }) async {
    await (update(dwellings)..where((tbl) => tbl.globalId.equals(globalId)))
        .write(
      DwellingsCompanion(
        dwlEntGlobalId: Value(newDwlEntGlobalID),
      ),
    );
  }

  // Update GlobalID by ObjectID
  Future<void> updateDwellingGlobalID({
    required int objectId,
    required String newGlobalId,
  }) async {
    await (update(dwellings)..where((tbl) => tbl.objectId.equals(objectId)))
        .write(
      DwellingsCompanion(
        globalId: Value(newGlobalId),
      ),
    );
  }
}
