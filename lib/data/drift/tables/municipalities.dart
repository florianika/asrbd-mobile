import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';

class Municipalities extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get objectId => integer()();
  TextColumn get municipalityId => text()();

  late final downloadId = integer().references(Downloads, #id)();

  TextColumn get municipalityName => text().nullable()();
  TextColumn get coordinates => text()();
}
