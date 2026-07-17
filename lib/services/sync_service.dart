import '../core/app_settings.dart';
import '../../../database/app_database.dart';

class SyncService {
  static Future<void> sync(AppDatabase database) async {
    // 1. Elimina prima le sessioni
    await database.syncDeletedSessions();

    // 2. Elimina gli spot
    await database.syncDeletedSpots();

    // 3. Carica gli spot
    await database.syncPendingSpots();

    // 4. Carica le sessioni
    await database.syncPendingSessions();

    // 5. Scarica gli spot
    await database.syncSpotsFromSupabase();

    // 6. Scarica le sessioni
    await database.syncFromSupabase();

    // 7. Profilo
    await database.downloadProfile();

    // 8. Meteo
    await database.syncMissingWeather();

    // Salva ultima sincronizzazione
    await AppSettings.saveLastSync(DateTime.now());
  }
}