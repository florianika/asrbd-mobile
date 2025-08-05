import 'package:asrdb/data/drift/tables/buildings.dart';
import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';

class Entrances extends Table {
  IntColumn get id => integer().autoIncrement()();
  late final downloadId = integer().references(Downloads, #id)();
  TextColumn get globalId => text().withLength(min: 1, max: 38)();

  late final entBldGlobalId =
      text().withLength(min: 1, max: 38).references(Buildings, #globalId)();

  TextColumn get entAddressId =>
      text().withLength(min: 1, max: 10).nullable()();
  IntColumn get entQuality => integer().withDefault(const Constant(9))();
  RealColumn get entLatitude => real()();
  RealColumn get entLongitude => real()();
  IntColumn get entPointStatus => integer().withDefault(const Constant(1))();
  TextColumn get entStrGlobalId =>
      text().withLength(min: 1, max: 38).nullable()();

  TextColumn get entBuildingNumber =>
      text().withLength(min: 1, max: 5).nullable()();
  TextColumn get entEntranceNumber =>
      text().withLength(min: 1, max: 4).nullable()();
  IntColumn get entTown => integer().nullable()();
  IntColumn get entZipCode => integer().nullable()();
  IntColumn get entDwellingRecs => integer().nullable()();
  IntColumn get entDwellingExpec => integer().nullable()();
}
