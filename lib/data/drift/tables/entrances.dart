import 'package:asrdb/data/drift/tables/buildings.dart';
import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';

class Entrances extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get downloadId =>
      integer().named('downloadid').references(Downloads, #id)();

  TextColumn get globalId =>
      text().named('globalid').withLength(min: 1, max: 38)();

  TextColumn get entBldGlobalId => text()
      .named('entbldglobalid')
      .withLength(min: 1, max: 38)
      .references(Buildings, #globalId)();

  TextColumn get entAddressId =>
      text().named('entaddressid').withLength(min: 1, max: 10).nullable()();

  IntColumn get entQuality =>
      integer().named('entquality').withDefault(const Constant(9))();

  RealColumn get entLatitude => real().named('entlatitude')();

  RealColumn get entLongitude => real().named('entlongitude')();

  IntColumn get entPointStatus =>
      integer().named('entpointstatus').withDefault(const Constant(1))();

  TextColumn get entStrGlobalId =>
      text().named('entstrglobalid').withLength(min: 1, max: 38).nullable()();

  TextColumn get entBuildingNumber =>
      text().named('entbuildingnumber').withLength(min: 1, max: 5).nullable()();

  TextColumn get entEntranceNumber =>
      text().named('ententrancenumber').withLength(min: 1, max: 4).nullable()();

  IntColumn get entTown => integer().named('enttown').nullable()();

  IntColumn get entZipCode => integer().named('entzpcode').nullable()();

  IntColumn get entDwellingRecs =>
      integer().named('entdwellingrecs').nullable()();

  IntColumn get entDwellingExpec =>
      integer().named('entdwellingexpec').nullable()();

  TextColumn get geometryType =>
      text().named('geometrytype').withLength(min: 1, max: 255).nullable()();

  TextColumn get coordinates => text().named('coordinates')();
}
