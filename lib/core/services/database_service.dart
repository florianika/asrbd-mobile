import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/drift/daos/building_dao.dart';
import 'package:asrdb/data/drift/daos/dwellings_dao.dart';
import 'package:asrdb/data/drift/daos/entrances_dao.dart';

class DatabaseService {
  final AppDatabase _db = AppDatabase();

  BuildingDao get buildingDao => _db.buildingDao;
  EntrancesDao get entranceDao => _db.entrancesDao;
  DwellingsDao get dwellingDao => _db.dwellingsDao;

  Future<void> close() => _db.close();
}
