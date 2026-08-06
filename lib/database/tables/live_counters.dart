import 'package:drift/drift.dart';

class LiveCounterEntries extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId => text()();

  IntColumn get counter => integer()();

  IntColumn get quantity =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}