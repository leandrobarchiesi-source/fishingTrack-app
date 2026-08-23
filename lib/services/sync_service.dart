import '../core/app_settings.dart';
import '../../../database/app_database.dart';

class SyncService {
  static Future<void> sync(AppDatabase database) async {
    // 1. Elimina prima le sessioni
    await database.syncDeletedSessions();

    // 2. Elimina gli spot
    await database.syncDeletedSpots();

    // 3. Elimina le catture
    await database.syncDeletedSessionCatches();

    // 4. Carica gli spot
    await database.syncPendingSpots();

    // 5. Carica le sessioni
    await database.syncPendingSessions();

    await database.syncPendingSessionLogs();
    await database.syncPendingCounterNames();
    await database.syncPendingSessionCounters();

    // 6. Carica le catture
    await database.syncPendingSessionCatches();

    // 7. Scarica gli spot
    await database.syncSpotsFromSupabase();

    // 8. Scarica le sessioni
    await database.syncFromSupabase();

    // 9. Scarica le catture
    await database.syncSessionCatchesFromSupabase();

    await database.syncSessionLogsFromSupabase();
    await database.syncCounterNamesFromSupabase();
    await database.syncSessionCountersFromSupabase();

    // 10. Profilo
    await database.downloadProfile();

    // 11. Meteo
    await database.syncMissingWeather();

    // Salva ultima sincronizzazione
    await AppSettings.saveLastSync(DateTime.now());
  }
}
