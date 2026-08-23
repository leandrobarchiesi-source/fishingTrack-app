import 'package:drift/drift.dart';

class FishingSessions extends Table {
  TextColumn get id => text()();

  TextColumn get userId => text()();

  // NUOVO
  TextColumn get spotId => text().nullable()();

  TextColumn get luogo => text()();

  TextColumn get tipoPescata => text()();

  RealColumn get latitudine => real().nullable()();

  RealColumn get longitudine => real().nullable()();

  DateTimeColumn get data => dateTime()();

  DateTimeColumn get oraInizio => dateTime()();

  DateTimeColumn get oraFine => dateTime()();

  TextColumn get note => text().nullable()();

  RealColumn get temperatura => real().nullable()();

  RealColumn get temperaturaAcqua => real().nullable()();

  TextColumn get vento => text().nullable()();

  RealColumn get pressione => real().nullable()();

  TextColumn get condizioni => text().nullable()();

  TextColumn get faseLunare => text().nullable()();

  BoolColumn get synced => boolean().withDefault(
        const Constant(false),
      )();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  TextColumn get mode => text().withDefault(
        const Constant("standard"),
      )();

  TextColumn get status => text().withDefault(
        const Constant("completed"),
      )();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get modalita => text().withDefault(const Constant('standard'))();

  @override
  Set<Column> get primaryKey => {id};
}
