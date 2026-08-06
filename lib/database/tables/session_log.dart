import 'package:drift/drift.dart';

import 'fishing_sessions.dart';

class SessionLog extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId => text().references(
        FishingSessions,
        #id,
        onDelete: KeyAction.cascade,
      )();

  /// start, cast, catch, end...
  TextColumn get eventType => text()();

  /// Contatore Live (1,2,3...)
  IntColumn get counter =>
      integer().nullable()();

  /// Specie assegnata a fine sessione
  TextColumn get species =>
      text().nullable()();

  /// Per sviluppi futuri (es. doppia cattura)
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
        {eventType},
        {sessionId, eventType},
      ];
}