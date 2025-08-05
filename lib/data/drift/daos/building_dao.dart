import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/buildings.dart';

part 'building_dao.g.dart';

@DriftAccessor(tables: [Buildings])
class BuildingDao extends DatabaseAccessor<AppDatabase> with _$BuildingDaoMixin {
  BuildingDao(AppDatabase db) : super(db);

  // 1. Get all buildings
  Future<List<Building>> getAllBuildings() {
    return select(buildings).get();
  }

  // 2. Get building by id
  Future<Building?> getBuildingById(String globalId) {
    return (select(buildings)..where((tbl) => tbl.globalId.equals(globalId))).getSingleOrNull();
  }

  // 3. Insert or update a single building
  Future<void> insertBuilding(Building building) async {
    await into(buildings).insertOnConflictUpdate(building);
  }

  // 4. Bulk insert or update buildings
  Future<void> insertBuildings(List<Building> buildingList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(buildings, buildingList);
    });
  }

  // 5. Delete a single building
  Future<void> deleteBuilding(Building building) async {
    await delete(buildings).delete(building);
  }

  // 6. Delete all buildings
  Future<void> deleteAllBuildings() async {
    await delete(buildings).go();
  }

  // 7. Update only GlobalID based on OBJECTID
  Future<void> updateGlobalIdById({
    required int id,
    required String globalId,
  }) async {
    await (update(buildings)..where((tbl) => tbl.id.equals(id)))
        .write(
      BuildingsCompanion(
        globalId: Value(globalId),
      ),
    );
  }
}

