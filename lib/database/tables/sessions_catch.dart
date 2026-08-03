import 'package:drift/drift.dart';
import 'fishing_sessions.dart';


class SessionCatch extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId => text().references(
        FishingSessions,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get species => text()();

  IntColumn get quantity =>
      integer().withDefault(const Constant(0))();

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
        {sessionId},
      ];
}