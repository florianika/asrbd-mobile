import 'package:asrdb/data/drift/tables/buildings.dart';
import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';

class Entrances extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get downloadId =>
      integer().named('download_id').references(Downloads, #id)();

  TextColumn get globalId =>
      text().named('global_id').withLength(min: 1, max: 38)();

  IntColumn get recordStatus => integer().named('record_status')();

  TextColumn get entBldGlobalId => text()
      .named('ent_bld_global_id')
      .withLength(min: 1, max: 38)
      .references(Buildings, #globalId)();

  TextColumn get entAddressId =>
      text().named('ent_address_id').withLength(min: 1, max: 10).nullable()();

  IntColumn get entQuality =>
      integer().named('ent_quality').withDefault(const Constant(9))();

  RealColumn get entLatitude => real().named('ent_latitude')();

  RealColumn get entLongitude => real().named('ent_longitude')();

  IntColumn get entPointStatus =>
      integer().named('ent_point_status').withDefault(const Constant(1))();

  TextColumn get entStrGlobalId => text()
      .named('ent_str_global_id')
      .withLength(min: 1, max: 38)
      .nullable()();

  TextColumn get entBuildingNumber => text()
      .named('ent_building_number')
      .withLength(min: 1, max: 5)
      .nullable()();

  TextColumn get entEntranceNumber => text()
      .named('ent_entrance_number')
      .withLength(min: 1, max: 4)
      .nullable()();

  IntColumn get entTown => integer().named('ent_town').nullable()();

  IntColumn get entZipCode => integer().named('ent_zip_code').nullable()();

  IntColumn get entDwellingRecs =>
      integer().named('ent_dwelling_recs').nullable()();

  IntColumn get entDwellingExpec =>
      integer().named('ent_dwelling_expec').nullable()();

  TextColumn get geometryType =>
      text().named('geometry_type').withLength(min: 1, max: 255).nullable()();

  TextColumn get coordinates => text().named('coordinates')();
}
