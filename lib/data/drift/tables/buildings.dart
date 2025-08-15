import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';

class Buildings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get objectId => integer()();

  late final downloadId = integer().references(Downloads, #id)();

  TextColumn get globalId => text().withLength(min: 1, max: 38)();

  TextColumn get bldAddressID =>
      text().nullable().withLength(min: 1, max: 38)();

  IntColumn get bldQuality =>
      integer().nullable().withDefault(const Constant(9))();

  IntColumn get bldMunicipality => integer().nullable()();

  TextColumn get bldEnumArea => text().withLength(min: 1, max: 8).nullable()();

  RealColumn get bldLatitude => real().nullable()();

  RealColumn get bldLongitude => real().nullable()();

  IntColumn get bldCadastralZone => integer().nullable()();

  TextColumn get bldProperty =>
      text().withLength(min: 1, max: 255).nullable()();

  TextColumn get bldPermitNumber =>
      text().withLength(min: 1, max: 25).nullable()();

  DateTimeColumn get bldPermitDate => dateTime().nullable()();

  IntColumn get bldStatus =>
      integer().nullable().withDefault(const Constant(4))();

  IntColumn get bldYearConstruction => integer().nullable()();

  IntColumn get bldYearDemolition => integer().nullable()();

  IntColumn get bldType =>
      integer().nullable().withDefault(const Constant(9))();

  IntColumn get bldClass =>
      integer().nullable().withDefault(const Constant(999))();

  TextColumn get bldCensus2023 => text().nullable()();

  RealColumn get bldArea => real().nullable()();

  RealColumn get shapeLength => real().nullable()();

  RealColumn get shapeArea => real().nullable()();

  IntColumn get bldFloorsAbove => integer().nullable()();

  RealColumn get bldHeight => real().nullable()();

  RealColumn get bldVolume => real().nullable()();

  IntColumn get bldWasteWater =>
      integer().nullable().withDefault(const Constant(9))();

  IntColumn get bldElectricity =>
      integer().nullable().withDefault(const Constant(9))();

  IntColumn get bldPipedGas =>
      integer().nullable().withDefault(const Constant(9))();

  IntColumn get bldElevator =>
      integer().nullable().withDefault(const Constant(9))();

  TextColumn get createdUser =>
      text().withLength(min: 1, max: 255).nullable()();

  DateTimeColumn get createdDate => dateTime().nullable()();

  TextColumn get lastEditedUser =>
      text().withLength(min: 1, max: 255).nullable()();

  DateTimeColumn get lastEditedDate => dateTime().nullable()();

  IntColumn get bldCentroidStatus =>
      integer().nullable().withDefault(const Constant(1))();

  IntColumn get bldDwellingRecs => integer().nullable()();

  IntColumn get bldEntranceRecs => integer().nullable()();

  TextColumn get bldAddressId => text().withLength(min: 1, max: 6).nullable()();

  TextColumn get externalCreator =>
      text().withLength(min: 1, max: 38).nullable()();

  TextColumn get externalEditor =>
      text().withLength(min: 1, max: 38).nullable()();

  IntColumn get bldReview =>
      integer().nullable().withDefault(const Constant(1))();

  IntColumn get bldWaterSupply =>
      integer().nullable().withDefault(const Constant(99))();

  DateTimeColumn get externalCreatorDate => dateTime().nullable()();

  DateTimeColumn get externalEditorDate => dateTime().nullable()();

  // Custom fields not in ESRI schema
  TextColumn get geometryType =>
      text().withLength(min: 1, max: 255).nullable()();

  TextColumn get coordinates => text()();
}
