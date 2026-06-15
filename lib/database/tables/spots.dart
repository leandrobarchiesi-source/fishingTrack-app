import 'package:drift/drift.dart';

class Spots extends Table {
  TextColumn get id => text()();

  TextColumn get userId => text()();

  TextColumn get nome => text()();

  RealColumn get latitudine => real().nullable()();

  RealColumn get longitudine => real().nullable()();

  TextColumn get note => text().nullable()();

  BoolColumn get preferito => boolean().withDefault(
        const Constant(false),
      )();

  // SOLO LOCALE
  BoolColumn get synced => boolean().withDefault(
        const Constant(false),
      )();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {
        id,
      };
}
