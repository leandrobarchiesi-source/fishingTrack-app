import 'package:drift/drift.dart';

import 'app_database.dart';

MigrationStrategy buildMigration(AppDatabase db) {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },

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

      if (from < 9) {
        await m.createTable(
          db.sessionCatch,
        );
      }

if (from < 12) {
  await m.createTable(
    db.sessionLog,
  );
}

if (from < 13) {
  await m.addColumn(
    db.fishingSessions,
    db.fishingSessions.mode,
  );

  await m.addColumn(
    db.fishingSessions,
    db.fishingSessions.status,
  );
}

if (from < 14) {
  await m.createTable(
db.liveCounterEntries  );
}

if (from < 15) {
  await m.createTable(
    db.counterNames,
  );

  await m.createTable(
    db.sessionCounters,
  );
}
    },
  );
}