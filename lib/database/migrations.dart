import 'package:drift/drift.dart';

import 'app_database.dart';

MigrationStrategy buildMigration(AppDatabase db) {
  return MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(
          db.fishingSessions,
          db.fishingSessions.synced,
        );
      }

      if (from < 3) {
        await m.createTable(
          db.spots,
        );
      }

      if (from < 4) {
        await m.addColumn(
          db.fishingSessions,
          db.fishingSessions.spotId,
        );
      }

      if (from < 5) {
        await m.addColumn(
          db.spots,
          db.spots.synced,
        );
      }

      if (from < 6) {
        await m.addColumn(
          db.fishingSessions,
          db.fishingSessions.temperaturaAcqua,
        );
      }

      if (from < 7) {
        await m.createTable(
          db.profiles,
        );
      }

      if (from < 8) {
        await m.addColumn(
          db.fishingSessions,
          db.fishingSessions.deletedAt,
        );

        await m.addColumn(
          db.spots,
          db.spots.deletedAt,
        );
      }
    },
  );
}