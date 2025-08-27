import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';

class Buildings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get objectId => integer().named('objectid')();

  IntColumn get downloadId =>
      integer().named('downloadid').references(Downloads, #id)();

  TextColumn get globalId =>
      text().named('globalid').withLength(min: 1, max: 38)();

  TextColumn get bldAddressID =>
      text().named('bldaddressid').nullable().withLength(min: 1, max: 38)();

  IntColumn get bldQuality =>
      integer().named('bldquality').nullable().withDefault(const Constant(9))();

  IntColumn get bldMunicipality =>
      integer().named('bldmunicipality').nullable()();

  TextColumn get bldEnumArea =>
      text().named('bldenumarea').withLength(min: 1, max: 8).nullable()();

  RealColumn get bldLatitude => real().named('bldlatitude').nullable()();

  RealColumn get bldLongitude => real().named('bldlongitude').nullable()();

  IntColumn get bldCadastralZone =>
      integer().named('bldcadastralzone').nullable()();

  TextColumn get bldProperty =>
      text().named('bldproperty').withLength(min: 1, max: 255).nullable()();

  TextColumn get bldPermitNumber =>
      text().named('bldpermitnumber').withLength(min: 1, max: 25).nullable()();

  DateTimeColumn get bldPermitDate =>
      dateTime().named('bldpermitdate').nullable()();

  IntColumn get bldStatus =>
      integer().named('bldstatus').nullable().withDefault(const Constant(4))();

  IntColumn get bldYearConstruction =>
      integer().named('bldyearconstruction').nullable()();

  IntColumn get bldYearDemolition =>
      integer().named('bldyeardemolition').nullable()();

  IntColumn get bldType =>
      integer().named('bldtype').nullable().withDefault(const Constant(9))();

  IntColumn get bldClass =>
      integer().named('bldclass').nullable().withDefault(const Constant(999))();

  TextColumn get bldCensus2023 => text().named('bldcensus2023').nullable()();

  RealColumn get bldArea => real().named('bldarea').nullable()();

  RealColumn get shapeLength => real().named('shapelength').nullable()();

  RealColumn get shapeArea => real().named('shapearea').nullable()();

  IntColumn get bldFloorsAbove =>
      integer().named('bldfloorsabove').nullable()();

  RealColumn get bldHeight => real().named('bldheight').nullable()();

  RealColumn get bldVolume => real().named('bldvolume').nullable()();

  IntColumn get bldWasteWater => integer()
      .named('bldwastewater')
      .nullable()
      .withDefault(const Constant(9))();

  IntColumn get bldElectricity => integer()
      .named('bldelectricity')
      .nullable()
      .withDefault(const Constant(9))();

  IntColumn get bldPipedGas => integer()
      .named('bldpipedgas')
      .nullable()
      .withDefault(const Constant(9))();

  IntColumn get bldElevator => integer()
      .named('bldelevator')
      .nullable()
      .withDefault(const Constant(9))();

  TextColumn get createdUser =>
      text().named('createduser').withLength(min: 1, max: 255).nullable()();

  DateTimeColumn get createdDate =>
      dateTime().named('createddate').nullable()();

  TextColumn get lastEditedUser =>
      text().named('lastediteduser').withLength(min: 1, max: 255).nullable()();

  DateTimeColumn get lastEditedDate =>
      dateTime().named('lastediteddate').nullable()();

  IntColumn get bldCentroidStatus => integer()
      .named('bldcentroidstatus')
      .nullable()
      .withDefault(const Constant(1))();

  IntColumn get bldDwellingRecs =>
      integer().named('blddwellingrecs').nullable()();

  IntColumn get bldEntranceRecs =>
      integer().named('bldentrancerecs').nullable()();

  // TextColumn get bldAddressId =>
  //     text().named('bldaddressid').withLength(min: 1, max: 6).nullable()();

  TextColumn get externalCreator =>
      text().named('externalcreator').withLength(min: 1, max: 38).nullable()();

  TextColumn get externalEditor =>
      text().named('externaleditor').withLength(min: 1, max: 38).nullable()();

  IntColumn get bldReview =>
      integer().named('bldreview').nullable().withDefault(const Constant(1))();

  IntColumn get bldWaterSupply => integer()
      .named('bldwatersupply')
      .nullable()
      .withDefault(const Constant(99))();

  DateTimeColumn get externalCreatorDate =>
      dateTime().named('externalcreatordate').nullable()();

  DateTimeColumn get externalEditorDate =>
      dateTime().named('externaleditordate').nullable()();

  // Custom fields not in ESRI schema
  TextColumn get geometryType =>
      text().named('geometrytype').withLength(min: 1, max: 255).nullable()();

  TextColumn get coordinates => text().named('coordinates')();
}
