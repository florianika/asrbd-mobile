import 'package:drift/drift.dart';

class Buildings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get globalId => text().withLength(min: 1, max: 38)();
  IntColumn get bldQuality => integer().withDefault(const Constant(9))();
  IntColumn get bldMunicipality => integer()();
  TextColumn get bldEnumArea => text().withLength(min: 1, max: 8).nullable()();
  RealColumn get bldLatitude => real()();
  RealColumn get bldLongitude => real()();
  IntColumn get bldCadastralZone => integer().nullable()();
  TextColumn get bldProperty =>
      text().withLength(min: 1, max: 255).nullable()();
  TextColumn get bldPermitNumber =>
      text().withLength(min: 1, max: 25).nullable()();
  DateTimeColumn get bldPermitDate => dateTime().nullable()();
  IntColumn get bldStatus => integer().withDefault(const Constant(4))();
  IntColumn get bldYearConstruction => integer().nullable()();
  IntColumn get bldYearDemolition => integer().nullable()();
  IntColumn get bldType =>
      integer().nullable().withDefault(const Constant(9))();
  IntColumn get bldClass =>
      integer().nullable().withDefault(const Constant(999))();
  RealColumn get bldArea => real().nullable()();
  IntColumn get bldFloorsAbove => integer().nullable()();
  IntColumn get bldHeight => integer().nullable()();
  RealColumn get bldVolume => real().nullable()();
  IntColumn get bldWasteWater =>
      integer().nullable().withDefault(const Constant(9))();
  IntColumn get bldElectricity =>
      integer().nullable().withDefault(const Constant(9))();
  IntColumn get bldPipedGas =>
      integer().nullable().withDefault(const Constant(9))();
  IntColumn get bldElevator =>
      integer().nullable().withDefault(const Constant(9))();

  IntColumn get bldCentroidStatus => integer().withDefault(const Constant(1))();
  IntColumn get bldDwellingRecs => integer().nullable()();
  IntColumn get bldEntranceRecs => integer().nullable()();
  TextColumn get bldAddressId => text().withLength(min: 1, max: 6).nullable()();

  IntColumn get bldReview => integer().withDefault(const Constant(1))();
  IntColumn get bldWaterSupply =>
      integer().nullable().withDefault(const Constant(99))();
}
