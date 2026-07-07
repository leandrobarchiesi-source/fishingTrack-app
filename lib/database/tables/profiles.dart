import 'package:drift/drift.dart';

class Profiles extends Table {
  TextColumn get id => text()();

  TextColumn get nome => text().nullable()();

  TextColumn get cognome => text().nullable()();

  TextColumn get email => text().nullable()();

  TextColumn get language =>
      text().withDefault(const Constant('it'))();

  TextColumn get avatar => text().nullable()();

  BoolColumn get synced =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}