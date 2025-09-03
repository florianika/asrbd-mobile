import 'package:drift/drift.dart';

class Downloads extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get areaName => text().named('area_name')();
  RealColumn get boundsNorthWestLat =>
      real().named('bounds_north_west_lat').nullable()();
  RealColumn get boundsNorthWestLng =>
      real().named('bounds_north_west_lng').nullable()();
  RealColumn get boundsSouthEastLat =>
      real().named('bounds_south_east_lat').nullable()();
  RealColumn get boundsSouthEastLng =>
      real().named('bounds_south_east_lng').nullable()();
  RealColumn get centerLat => real().named('center_lat').nullable()();
  RealColumn get centerLng => real().named('center_lng').nullable()();
  IntColumn get municipalityId => integer().named('municipality_id')();
  TextColumn get email => text().named('email')();
  IntColumn get userId => integer().named('user_id')();
  DateTimeColumn get createdDate =>
      dateTime().named('created_date').withDefault(currentDateAndTime)();
}
