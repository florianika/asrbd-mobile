import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';

class Buildings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get objectId => integer().named('object_id').nullable()();

  IntColumn get recordStatus => integer().named('record_status')();

  IntColumn get downloadId =>
      integer().named('download_id').references(Downloads, #id)();

  TextColumn get globalId =>
      text().named('global_id').withLength(min: 1, max: 38)();

  TextColumn get bldAddressID =>
      text().named('bld_address_id').nullable().withLength(min: 1, max: 38)();

  IntColumn get bldQuality => integer()
      .named('bld_quality')
      .nullable()
      .withDefault(const Constant(9))();

  IntColumn get bldMunicipality =>
      integer().named('bld_municipality').nullable()();

  TextColumn get bldEnumArea =>
      text().named('bld_enum_area').withLength(min: 1, max: 8).nullable()();

  RealColumn get bldLatitude => real().named('bld_latitude').nullable()();

  RealColumn get bldLongitude => real().named('bld_longitude').nullable()();

  IntColumn get bldCadastralZone =>
      integer().named('bld_cadastral_zone').nullable()();

  TextColumn get bldProperty =>
      text().named('bld_property').withLength(min: 1, max: 255).nullable()();

  TextColumn get bldPermitNumber => text()
      .named('bld_permit_number')
      .withLength(min: 1, max: 25)
      .nullable()();

  DateTimeColumn get bldPermitDate =>
      dateTime().named('bld_permit_date').nullable()();

  IntColumn get bldStatus =>
      integer().named('bld_status').nullable().withDefault(const Constant(4))();

  IntColumn get bldYearConstruction =>
      integer().named('bld_year_construction').nullable()();

  IntColumn get bldYearDemolition =>
      integer().named('bld_year_demolition').nullable()();

  IntColumn get bldType =>
      integer().named('bld_type').nullable().withDefault(const Constant(9))();

  IntColumn get bldClass => integer()
      .named('bld_class')
      .nullable()
      .withDefault(const Constant(999))();

  TextColumn get bldCensus2023 => text().named('bld_census_2023').nullable()();

  RealColumn get bldArea => real().named('bld_area').nullable()();

  RealColumn get shapeLength => real().named('shape_length').nullable()();

  RealColumn get shapeArea => real().named('shape_area').nullable()();

  IntColumn get bldFloorsAbove =>
      integer().named('bld_floors_above').nullable()();

  RealColumn get bldHeight => real().named('bld_height').nullable()();

  RealColumn get bldVolume => real().named('bld_volume').nullable()();

  IntColumn get bldWasteWater => integer()
      .named('bld_waste_water')
      .nullable()
      .withDefault(const Constant(9))();

  IntColumn get bldElectricity => integer()
      .named('bld_electricity')
      .nullable()
      .withDefault(const Constant(9))();

  IntColumn get bldPipedGas => integer()
      .named('bld_piped_gas')
      .nullable()
      .withDefault(const Constant(9))();

  IntColumn get bldElevator => integer()
      .named('bld_elevator')
      .nullable()
      .withDefault(const Constant(9))();

  TextColumn get createdUser =>
      text().named('created_user').withLength(min: 1, max: 255).nullable()();

  DateTimeColumn get createdDate =>
      dateTime().named('created_date').nullable()();

  TextColumn get lastEditedUser => text()
      .named('last_edited_user')
      .withLength(min: 1, max: 255)
      .nullable()();

  DateTimeColumn get lastEditedDate =>
      dateTime().named('last_edited_date').nullable()();

  IntColumn get bldCentroidStatus => integer()
      .named('bld_centroid_status')
      .nullable()
      .withDefault(const Constant(1))();

  IntColumn get bldDwellingRecs =>
      integer().named('bld_dwelling_recs').nullable()();

  IntColumn get bldEntranceRecs =>
      integer().named('bld_entrance_recs').nullable()();

  TextColumn get externalCreator =>
      text().named('external_creator').withLength(min: 1, max: 38).nullable()();

  TextColumn get externalEditor =>
      text().named('external_editor').withLength(min: 1, max: 38).nullable()();

  IntColumn get bldReview =>
      integer().named('bld_review').nullable().withDefault(const Constant(1))();

  IntColumn get bldWaterSupply => integer()
      .named('bld_water_supply')
      .nullable()
      .withDefault(const Constant(99))();

  DateTimeColumn get externalCreatorDate =>
      dateTime().named('external_creator_date').nullable()();

  DateTimeColumn get externalEditorDate =>
      dateTime().named('external_editor_date').nullable()();

  // Custom fields not in ESRI schema
  TextColumn get geometryType =>
      text().named('geometry_type').withLength(min: 1, max: 255).nullable()();

  TextColumn get coordinates => text().named('coordinates')();
}
