import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';

class Municipalities extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get objectId => integer().named('object_id')();

  TextColumn get municipalityId => text().named('municipality_id')();

  IntColumn get downloadId =>
      integer().named('download_id').references(Downloads, #id)();

  TextColumn get municipalityName =>
      text().named('municipality_name').nullable()();

  TextColumn get coordinates => text().named('coordinates')();
}
