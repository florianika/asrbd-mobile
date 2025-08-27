import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:asrdb/data/drift/tables/entrances.dart';
import 'package:drift/drift.dart';

class Dwellings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get downloadId =>
      integer().named('downloadid').references(Downloads, #id)();

  TextColumn get globalId =>
      text().named('globalid').withLength(min: 1, max: 38)();

  TextColumn get dwlEntGlobalId => text()
      .named('dwlentglobalid')
      .withLength(min: 1, max: 38)
      .references(Entrances, #globalId)();

  TextColumn get dwlAddressId =>
      text().named('dwladdressid').withLength(min: 1, max: 16).nullable()();

  IntColumn get dwlQuality =>
      integer().named('dwlquality').withDefault(const Constant(9))();

  IntColumn get dwlFloor => integer().named('dwlfloor').nullable()();

  TextColumn get dwlApartNumber =>
      text().named('dwlapartnumber').withLength(min: 1, max: 5).nullable()();

  IntColumn get dwlStatus =>
      integer().named('dwlstatus').withDefault(const Constant(4))();

  IntColumn get dwlYearConstruction =>
      integer().named('dwlyearconstruction').nullable()();

  IntColumn get dwlYearElimination =>
      integer().named('dwlyearelimination').nullable()();

  IntColumn get dwlType =>
      integer().named('dwltype').nullable().withDefault(const Constant(9))();

  IntColumn get dwlOwnership => integer()
      .named('dwlownership')
      .nullable()
      .withDefault(const Constant(99))();

  IntColumn get dwlOccupancy => integer()
      .named('dwloccupancy')
      .nullable()
      .withDefault(const Constant(99))();

  IntColumn get dwlSurface => integer().named('dwlsurface').nullable()();

  IntColumn get dwlToilet =>
      integer().named('dwltoilet').nullable().withDefault(const Constant(99))();

  IntColumn get dwlBath =>
      integer().named('dwlbath').nullable().withDefault(const Constant(9))();

  IntColumn get dwlHeatingFacility => integer()
      .named('dwlheatingfacility')
      .nullable()
      .withDefault(const Constant(99))();

  IntColumn get dwlHeatingEnergy => integer()
      .named('dwlheatingenergy')
      .nullable()
      .withDefault(const Constant(99))();

  IntColumn get dwlAirConditioner => integer()
      .named('dwlairconditioner')
      .nullable()
      .withDefault(const Constant(9))();

  IntColumn get dwlSolarPanel => integer()
      .named('dwlsolarpanel')
      .nullable()
      .withDefault(const Constant(9))();

  TextColumn get geometryType =>
      text().named('geometrytype').withLength(min: 1, max: 255).nullable()();
}
