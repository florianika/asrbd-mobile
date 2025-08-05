import 'package:drift/drift.dart';

class Downloads extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdDate =>
      dateTime().withDefault(currentDateAndTime)();
}
