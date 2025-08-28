import 'package:asrdb/data/drift/daos/building_dao.dart';
import 'package:asrdb/data/drift/daos/downloads_dao.dart';
import 'package:asrdb/data/drift/daos/dwellings_dao.dart';
import 'package:asrdb/data/drift/daos/entrances_dao.dart';
import 'package:asrdb/data/drift/drift_initializer.dart';
import 'package:asrdb/data/drift/tables/buildings.dart';
import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:asrdb/data/drift/tables/dwellings.dart';
import 'package:asrdb/data/drift/tables/entrances.dart';
import 'package:asrdb/data/drift/tables/municipalities.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Downloads, Buildings, Entrances, Dwellings, Municipalities],
  daos: [
    DownloadsDao,
    BuildingDao,
    EntrancesDao,
    DwellingsDao,
    // MunicipalitiesDao
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 2;
}
