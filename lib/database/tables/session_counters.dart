import 'package:drift/drift.dart';

import 'fishing_sessions.dart';
import 'counter_names.dart';

class SessionCounters extends Table {
  TextColumn get sessionId => text().references(
        FishingSessions,
        #id,
        onDelete: KeyAction.cascade,
      )();

  IntColumn get counterNumber => integer()();

  TextColumn get counterNameId => text().references(
        CounterNames,
        #id,
        onDelete: KeyAction.restrict,
      )();

  BoolColumn get synced =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get deletedAt =>
      dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {
        sessionId,
        counterNumber,
      };

  @override
  List<Set<Column>> get indexes => [
        {sessionId},
        {counterNameId},
      ];
}