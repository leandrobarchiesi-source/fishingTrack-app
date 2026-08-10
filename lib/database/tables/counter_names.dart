import 'package:drift/drift.dart';

class CounterNames extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  // specie associata (testo, come SessionCatch)
  TextColumn get species => text().nullable()();

  BoolColumn get synced =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get deletedAt =>
      dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get indexes => [
        {name},
      ];
}