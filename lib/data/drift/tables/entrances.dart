import 'package:drift/drift.dart';

class Entrances extends Table {
  IntColumn get objectId => integer().autoIncrement()(); // OBJECTID

  TextColumn get entCensus2023 => text().withLength(min: 1, max: 13).nullable().withDefault(const Constant('9999999999999'))();

  DateTimeColumn get externalCreatorDate => dateTime().nullable()();
  DateTimeColumn get externalEditorDate => dateTime().nullable()();

  TextColumn get globalId => text().withLength(min: 1, max: 38)(); // GlobalID

  TextColumn get entBldGlobalId => text().withLength(min: 1, max: 38).withDefault(const Constant('00000000-0000-0000-0000-000000000000'))(); // EntBldGlobalID

  TextColumn get entAddressId => text().withLength(min: 1, max: 10).nullable()();
  IntColumn get entQuality => integer().withDefault(const Constant(9))();
  RealColumn get entLatitude => real()();
  RealColumn get entLongitude => real()();
  IntColumn get entPointStatus => integer().withDefault(const Constant(1))();
  TextColumn get entStrGlobalId => text().withLength(min: 1, max: 38).nullable()();

  TextColumn get entBuildingNumber => text().withLength(min: 1, max: 5).nullable()();
  TextColumn get entEntranceNumber => text().withLength(min: 1, max: 4).nullable()();
  IntColumn get entTown => integer().nullable()();
  IntColumn get entZipCode => integer().nullable()();
  IntColumn get entDwellingRecs => integer().nullable()();
  IntColumn get entDwellingExpec => integer().nullable()();

  TextColumn get createdUser => text().withLength(min: 1, max: 255).nullable()();
  DateTimeColumn get createdDate => dateTime().nullable()();
  TextColumn get lastEditedUser => text().withLength(min: 1, max: 255).nullable()();
  DateTimeColumn get lastEditedDate => dateTime().nullable()();

  TextColumn get externalCreator => text().withLength(min: 1, max: 38).nullable()();
  TextColumn get externalEditor => text().withLength(min: 1, max: 38).nullable()();
}
