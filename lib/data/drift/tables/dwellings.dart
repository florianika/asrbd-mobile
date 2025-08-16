import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:asrdb/data/drift/tables/entrances.dart';
import 'package:drift/drift.dart';

class Dwellings extends Table {
  IntColumn get id => integer().autoIncrement()();
  late final downloadId = integer().references(Downloads, #id)();
  TextColumn get globalId => text().withLength(min: 1, max: 38)();
  late final dwlEntGlobalId =
      text().withLength(min: 1, max: 38).references(Entrances, #globalId)();

  TextColumn get dwlAddressId =>
      text().withLength(min: 1, max: 16).nullable()();

  IntColumn get dwlQuality => integer().withDefault(const Constant(9))();
  IntColumn get dwlFloor => integer().nullable()();
  TextColumn get dwlApartNumber =>
      text().withLength(min: 1, max: 5).nullable()();

  IntColumn get dwlStatus => integer().withDefault(const Constant(4))();
  IntColumn get dwlYearConstruction => integer().nullable()();
  IntColumn get dwlYearElimination => integer().nullable()();

  IntColumn get dwlType =>
      integer().nullable().withDefault(const Constant(9))();
  IntColumn get dwlOwnership =>
      integer().nullable().withDefault(const Constant(99))();
  IntColumn get dwlOccupancy =>
      integer().nullable().withDefault(const Constant(99))();

  IntColumn get dwlSurface => integer().nullable()();
  IntColumn get dwlToilet =>
      integer().nullable().withDefault(const Constant(99))();
  IntColumn get dwlBath =>
      integer().nullable().withDefault(const Constant(9))();

  IntColumn get dwlHeatingFacility =>
      integer().nullable().withDefault(const Constant(99))();
  IntColumn get dwlHeatingEnergy =>
      integer().nullable().withDefault(const Constant(99))();

  IntColumn get dwlAirConditioner =>
      integer().nullable().withDefault(const Constant(9))();
  IntColumn get dwlSolarPanel =>
      integer().nullable().withDefault(const Constant(9))();

  TextColumn get geometryType =>
      text().withLength(min: 1, max: 255).nullable()();
}
