import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:asrdb/data/drift/tables/entrances.dart';
import 'package:drift/drift.dart';

class Dwellings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get downloadId =>
      integer().named('download_id').references(Downloads, #id)();

  IntColumn get objectId => integer().named('object_id')();

  TextColumn get globalId =>
      text().named('global_id').withLength(min: 1, max: 38)();

  IntColumn get recordStatus => integer().named('record_status')();

  TextColumn get dwlEntGlobalId => text()
      .named('dwl_ent_global_id')
      .withLength(min: 1, max: 38)
      .references(Entrances, #globalId)();

  TextColumn get dwlAddressId =>
      text().named('dwl_address_id').withLength(min: 1, max: 16).nullable()();

  IntColumn get dwlQuality =>
      integer().named('dwl_quality').withDefault(const Constant(9))();

  IntColumn get dwlFloor => integer().named('dwl_floor').nullable()();

  TextColumn get dwlApartNumber =>
      text().named('dwl_apart_number').withLength(min: 1, max: 5).nullable()();

  IntColumn get dwlStatus =>
      integer().named('dwl_status').withDefault(const Constant(4))();

  IntColumn get dwlYearConstruction =>
      integer().named('dwl_year_construction').nullable()();

  IntColumn get dwlYearElimination =>
      integer().named('dwl_year_elimination').nullable()();

  IntColumn get dwlType =>
      integer().named('dwl_type').nullable().withDefault(const Constant(9))();

  IntColumn get dwlOwnership => integer()
      .named('dwl_ownership')
      .nullable()
      .withDefault(const Constant(99))();

  IntColumn get dwlOccupancy => integer()
      .named('dwl_occupancy')
      .nullable()
      .withDefault(const Constant(99))();

  IntColumn get dwlSurface => integer().named('dwl_surface').nullable()();

  IntColumn get dwlToilet => integer()
      .named('dwl_toilet')
      .nullable()
      .withDefault(const Constant(99))();

  IntColumn get dwlBath =>
      integer().named('dwl_bath').nullable().withDefault(const Constant(9))();

  IntColumn get dwlHeatingFacility => integer()
      .named('dwl_heating_facility')
      .nullable()
      .withDefault(const Constant(99))();

  IntColumn get dwlHeatingEnergy => integer()
      .named('dwl_heating_energy')
      .nullable()
      .withDefault(const Constant(99))();

  IntColumn get dwlAirConditioner => integer()
      .named('dwl_air_conditioner')
      .nullable()
      .withDefault(const Constant(9))();

  IntColumn get dwlSolarPanel => integer()
      .named('dwl_solar_panel')
      .nullable()
      .withDefault(const Constant(9))();

  TextColumn get geometryType =>
      text().named('geometry_type').withLength(min: 1, max: 255).nullable()();
}
