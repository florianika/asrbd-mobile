import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';

class Municipalities extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get objectId => integer().named('objectid')();

  TextColumn get municipalityId => text().named('municipalityid')();

  IntColumn get downloadId =>
      integer().named('downloadid').references(Downloads, #id)();

  TextColumn get municipalityName =>
      text().named('municipalityname').nullable()();

  TextColumn get coordinates => text().named('coordinates')();
}
