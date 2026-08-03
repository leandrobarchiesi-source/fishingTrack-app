import 'package:drift/drift.dart';

import 'fishing_sessions.dart';

class SessionLog extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId => text().references(
        FishingSessions,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get eventType => text()();

  TextColumn get species =>
      text().nullable()();

  IntColumn get quantity =>
      integer().withDefault(const Constant(1))();

  DateTimeColumn get timestamp =>
      dateTime()();

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