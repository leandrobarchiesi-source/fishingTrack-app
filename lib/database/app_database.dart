
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/wheater/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'tables/fishing_sessions.dart';
import 'tables/spots.dart';
import 'tables/profiles.dart';
import 'tables/sessions_catch.dart';
import 'nearby_spot_result.dart';
import '/core/app_settings.dart';
import 'database_connection.dart';
import 'migrations.dart';
import 'tables/session_log.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    FishingSessions,
    Spots,
    Profiles,
    SessionCatch,
    SessionLog,
  ],
)

class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          openConnection(),
        );

  @override
  int get schemaVersion => 12;

  @override
  MigrationStrategy get migration => buildMigration(this);


Future<List<FishingSession>> getAllSessions() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return [];
  }

  return (select(fishingSessions)
        ..where((t) => t.userId.equals(user.id) & t.deletedAt.isNull()))
      .get();
}

Future<FishingSession?> getSessionById(String id) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return null;
  }

  return (select(fishingSessions)
        ..where((t) => t.id.equals(id))
        ..where((t) => t.userId.equals(user.id)))
      .getSingleOrNull();
}




  Future<void> insertSession(
    FishingSessionsCompanion session,
  ) async {
    await into(
      fishingSessions,
    ).insert(
      session.copyWith(
        synced: const Value(
          false,
        ),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );

  }

Future<bool> isSpotUsed(
  String spotId, {
  String? excludeSessionId,
}) async {
  final query = select(fishingSessions)
    ..where(
      (t) =>
          t.spotId.equals(spotId) &
          t.deletedAt.isNull(),
    );

  if (excludeSessionId != null) {
    query.where(
      (t) => t.id.isNotValue(excludeSessionId),
    );
  }

  return (await query.get()).isNotEmpty;
}

Future<void> deleteSession(String id) async {
  await transaction(() async {
    // Recupera la sessione
    final session = await (select(fishingSessions)
          ..where((t) => t.id.equals(id)))
        .getSingle();

    // Elimina le catture associate
    await deleteSessionCatches(id);

    // Marca la sessione come eliminata
    await (update(fishingSessions)
          ..where((t) => t.id.equals(id)))
        .write(
      FishingSessionsCompanion(
        deletedAt: Value(DateTime.now().toUtc()),
        synced: const Value(false),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );

    // Se lo spot non è più utilizzato, elimina anche lui
    if (session.spotId != null) {
      final used = await isSpotUsed(
        session.spotId!,
        excludeSessionId: id,
      );

      if (!used) {
        await deleteSpot(session.spotId!);
        await deleteSessionLogs(id);
      }
    }
  });
}

  Future<void> updateSession(
    FishingSession session,
  ) async {
    await (update(
      fishingSessions,
    )..where(
            (t) => t.id.equals(
              session.id,
            ),
          ))
        .write(
      FishingSessionsCompanion(
        spotId: Value(
          session.spotId,
        ),
        luogo: Value(
          session.luogo,
        ),
        tipoPescata: Value(
          session.tipoPescata,
        ),
        data: Value(
          session.data,
        ),
        oraInizio: Value(
          session.oraInizio,
        ),
        oraFine: Value(
          session.oraFine,
        ),
        latitudine: Value(
          session.latitudine,
        ),
        longitudine: Value(
          session.longitudine,
        ),
        temperatura: Value(
          session.temperatura,
        ),
        temperaturaAcqua: Value(
          session.temperaturaAcqua,
        ),
        pressione: Value(
          session.pressione,
        ),
        vento: Value(
          session.vento,
        ),
        condizioni: Value(
          session.condizioni,
        ),
        faseLunare: Value(
          session.faseLunare,
        ),
        note: Value(
          session.note,
        ),
        synced: const Value(
          false,
        ),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );

  }

  Future<bool> completaMeteoSessione(String id) async {
  final sessione = await (select(fishingSessions)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

  if (sessione == null) return false;


  if (sessione.latitudine == null || sessione.longitudine == null) {
    return false;
  }

  // Se il meteo è già presente non fare nulla
  if (sessione.temperatura != null &&
      sessione.pressione != null &&
      sessione.vento != null &&
      sessione.condizioni != null) {
    return false;
  }

  try {
    final weather = WeatherService();

    final meteo = await weather.getWeather(
      lat: sessione.latitudine!,
      lon: sessione.longitudine!,
      data: sessione.data,
      oraInizio: sessione.oraInizio,
    );

    await updateSession(
      sessione.copyWith(
        temperatura: Value(meteo.temperatura),
        pressione: Value(meteo.pressione),
        vento: Value(meteo.vento),
        condizioni: Value(meteo.condizioni),
      ),
    );

    return true;
  } catch (_) {
    return false;
  }
}

Future<void> syncDeletedSessions() async {
  final deleted = await (select(fishingSessions)
        ..where((t) => t.deletedAt.isNotNull()))
      .get();

  for (final s in deleted) {
    try {
      await Supabase.instance.client
          .from('fishing_sessions')
          .delete()
          .eq('id', s.id);

      await (delete(fishingSessions)
            ..where((t) => t.id.equals(s.id)))
          .go();
    } catch (e) {
      print("Errore eliminazione sessione: $e");
    }
  }
}

Future<void> syncDeletedSessionCatches() async {
  final deleted = await (select(sessionCatch)
        ..where((t) => t.deletedAt.isNotNull()))
      .get();

  for (final c in deleted) {
    try {
      await Supabase.instance.client
          .from('session_catch')
          .delete()
          .eq('id', c.id);

      await (delete(sessionCatch)
            ..where((t) => t.id.equals(c.id)))
          .go();
    } catch (e) {
      print("Errore eliminazione cattura: $e");
    }
  }
}

Future<void> syncSessionCatchesFromSupabase() async {
  try {
    final data = await Supabase.instance.client
        .from('session_catch')
        .select();

    for (final item in data) {
      final locale = await (select(sessionCatch)
            ..where((t) => t.id.equals(item['id'])))
          .getSingleOrNull();

      if (locale != null) {
        final remoto = DateTime.parse(
          item['updated_at'],
        ).toUtc();

        final localeTime = locale.updatedAt.toUtc();

        if (localeTime.isAfter(remoto)) {
          continue;
        }
      }

      await into(sessionCatch).insert(
        SessionCatchCompanion(
          id: Value(item['id']),
          sessionId: Value(item['session_id']),
          species: Value(item['species']),
          quantity: Value(item['quantity']),
          synced: const Value(true),
          createdAt: Value(
            DateTime.parse(item['created_at']),
          ),
          updatedAt: Value(
            DateTime.parse(item['updated_at']),
          ),
          deletedAt: item['deleted_at'] == null
              ? const Value.absent()
              : Value(
                  DateTime.parse(item['deleted_at']),
                ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  } catch (e) {
    print("Errore download catture: $e");
  }
}

Future<void> syncPendingSessions() async {
  print(">>> syncPendingSessions()");
  try {
    final pending = await (select(
      fishingSessions,
    )..where(
            (t) => t.synced.equals(false),
          ))
        .get();
print("Sessioni da sincronizzare: ${pending.length}");
    for (final s in pending) {
      // Sessione eliminata localmente

      // Inserimento / aggiornamento
      await Supabase.instance.client
          .from('fishing_sessions')
          .upsert({
        'id': s.id,
        'user_id': s.userId,
        'spot_id': s.spotId,
        'luogo': s.luogo,
        'tipo_pescata': s.tipoPescata,
        'data': s.data.toIso8601String(),
        'ora_inizio': s.oraInizio.toIso8601String(),
        'ora_fine': s.oraFine.toIso8601String(),
        'latitudine': s.latitudine,
        'longitudine': s.longitudine,
        'temperatura': s.temperatura,
        'temperatura_acqua': s.temperaturaAcqua,
        'pressione': s.pressione,
        'vento': s.vento,
        'condizioni': s.condizioni,
        'fase_lunare': s.faseLunare,
        'note': s.note,
        'created_at': s.createdAt.toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });

      await (update(fishingSessions)
            ..where((t) => t.id.equals(s.id)))
          .write(
        const FishingSessionsCompanion(
          synced: Value(true),
        ),
      );
    }
} catch (e, st) {
  print("ERRORE syncPendingSessions");
  print(e);
  print(st);
}
}

  Future<void> downloadProfile() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return;
  }

  try {
    final remoto = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

await saveProfile(
  ProfilesCompanion.insert(
    id: user.id,
    nome: Value(remoto['nome']),
    cognome: Value(remoto['cognome']),
    email: Value(user.email),
    language: Value(remoto['language'] ?? 'it'),
    avatar: Value(remoto['avatar']),
    synced: const Value(true),
    createdAt: DateTime.parse(remoto['created_at']),
    updatedAt: DateTime.parse(remoto['updated_at']),
  ),
);

await AppSettings.saveLanguage(
  (remoto['language'] as String?) ?? 'it',
);

    print("Profilo salvato in SQLite");
  } catch (e) {
    print("Errore download profilo: $e");
  }


}

Future<void> syncFromSupabase() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return;
  }

  try {
    final data = await Supabase.instance.client
        .from('fishing_sessions')
        .select()
        .eq('user_id', user.id);

    for (final item in data) {
      final locale = await (select(
        fishingSessions,
      )..where(
              (t) => t.id.equals(item['id']),
            ))
          .getSingleOrNull();

      print("========== SESSIONE ==========");
      print("ID: ${item['id']}");
      print("Cloud updated : ${item['updated_at']}");
      print("Locale updated: ${locale?.updatedAt}");
print("Cloud note   : ${item['note']}");
print("Locale note  : ${locale?.note}");
      print("=============================");

      if (locale != null) {
        final remoto = DateTime.parse(
          item['updated_at'],
        ).toUtc();

        final localeTime = locale.updatedAt.toUtc();

        print("Cloud UTC : $remoto");
        print("Locale UTC: $localeTime");

        if (localeTime.millisecondsSinceEpoch >
            remoto.millisecondsSinceEpoch) {
          print("SKIP DOWNLOAD - Locale più recente");
          continue;
        }
      }

      print("DOWNLOAD DAL CLOUD");

      final cloudSession = FishingSessionsCompanion.insert(
        id: item['id'],
        userId: item['user_id'],
        spotId: Value(item['spot_id']),
        luogo: item['luogo'],
        tipoPescata: item['tipo_pescata'],
        data: DateTime.parse(item['data']),
        oraInizio: DateTime.parse(item['ora_inizio']),
        oraFine: DateTime.parse(item['ora_fine']),
        latitudine: Value(
          (item['latitudine'] as num?)?.toDouble(),
        ),
        longitudine: Value(
          (item['longitudine'] as num?)?.toDouble(),
        ),
        temperatura: Value(
          (item['temperatura'] as num?)?.toDouble(),
        ),
        temperaturaAcqua: Value(
          (item['temperatura_acqua'] as num?)?.toDouble(),
        ),
        pressione: Value(
          (item['pressione'] as num?)?.toDouble(),
        ),
        vento: Value(item['vento']),
        condizioni: Value(item['condizioni']),
        faseLunare: Value(item['fase_lunare']),
        note: Value(item['note']),
        synced: const Value(true),
        createdAt: DateTime.parse(item['created_at']),
        updatedAt: DateTime.parse(item['updated_at']),
      );

      await into(
        fishingSessions,
      ).insert(
        cloudSession,
        mode: InsertMode.insertOrReplace,
      );

      final verifica = await (select(
        fishingSessions,
      )..where(
              (t) => t.id.equals(item['id']),
            ))
          .getSingleOrNull();

      print("----- SQLITE DOPO INSERT -----");
      print("Note       : ${verifica?.note}");
      print("Updated_at : ${verifica?.updatedAt}");
      print("------------------------------");
    }
  } catch (e) {
    print("Errore download sessioni: $e");
  }
}

  Future<void> syncSpotsFromSupabase() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      print(
        "Utente non autenticato",
      );

      return;
    }

    try {
      final dati = await Supabase.instance.client
          .from(
            'spots',
          )
          .select()
          .eq(
            'user_id',
            user.id,
          );

      for (final s in dati) {
        final locale = await (select(
          spots,
        )..where(
                (t) => t.id.equals(
                  s['id'],
                ),
              ))
            .getSingleOrNull();
            

if (locale != null) {
  
final remoto = DateTime.parse(
  s['updated_at'],
).toUtc();

final localeTime = locale.updatedAt.toUtc();

print("Cloud UTC : $remoto");
print("Locale UTC: $localeTime");
  // Il record locale è più recente:
  // non sovrascriverlo, verrà inviato al cloud.
  if (locale.updatedAt.isAfter(remoto)) {
    print(
      "Spot locale più recente -> skip download",
    );

    continue;
  }
}
        await into(
          spots,
        ).insert(
          SpotsCompanion(
            id: Value(
              s['id'],
            ),
            userId: Value(
              s['user_id'],
            ),
            nome: Value(
              s['nome'],
            ),
            latitudine: Value(
              (s['latitudine'] as num?)?.toDouble(),
            ),
            longitudine: Value(
              (s['longitudine'] as num?)?.toDouble(),
            ),
            synced: const Value(
              true,
            ),
            createdAt: Value(
              DateTime.parse(
                s['created_at'],
              ),
            ),
            updatedAt: Value(
              DateTime.parse(
                s['updated_at'],
              ),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

    } catch (e) {
      print(
        "Errore sync spot: $e",
      );
    }
  }

Future<void> syncDeletedSpots() async {
  final deleted = await (select(spots)
        ..where((t) => t.deletedAt.isNotNull()))
      .get();

  for (final s in deleted) {
    try {
      await Supabase.instance.client
          .from('spots')
          .delete()
          .eq('id', s.id);

      await (delete(spots)
            ..where((t) => t.id.equals(s.id)))
          .go();
    } catch (e) {
      print("Errore eliminazione spot: $e");
    }
  }
}

Future<void> syncPendingSpots() async {
  print(">>> syncPendingSpots()");
  try {
    final pending = await (select(
      spots,
    )..where(
            (t) => t.synced.equals(false),
          ))
        .get();

    for (final s in pending) {
      // Spot eliminato localmente
print("========== SYNC SPOT ==========");
print("Spot: ${s.nome}");
print("userId SQLite : ${s.userId}");
print("auth.uid()    : ${Supabase.instance.client.auth.currentUser?.id}");
print("Spot ID: ${s.id}");
print("Created: ${s.createdAt}");
print("================================");
      // Inserimento / aggiornamento
      await Supabase.instance.client
          .from('spots')
          .upsert({
        'id': s.id,
        'user_id': s.userId,
        'nome': s.nome,
        'latitudine': s.latitudine,
        'longitudine': s.longitudine,
        'created_at': s.createdAt.toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });

      await (update(spots)
            ..where((t) => t.id.equals(s.id)))
          .write(
        const SpotsCompanion(
          synced: Value(true),
        ),
      );
    }
  } catch (e) {
    print("Errore sync pending spots: $e");
  }
}

  Future<void> syncMissingWeather() async {
    try {
      final daAggiornare = await (select(
        fishingSessions,
      )..where(
              (t) =>
                  t.temperatura.isNull() &
                  t.synced.equals(
                    true,
                  ),
            ))
          .get();

      for (final s in daAggiornare) {
        // QUI userai il tuo WeatherService

        final weatherService = WeatherService();

        final meteo = await weatherService.getWeather(
          lat: s.latitudine!,
          lon: s.longitudine!,
          data: s.data,
          oraInizio: s.oraInizio,
        );
        await (update(
          fishingSessions,
        )..where(
                (t) => t.id.equals(
                  s.id,
                ),
              ))
            .write(
          FishingSessionsCompanion(
            temperatura: Value(
              meteo.temperatura,
            ),
            pressione: Value(
              meteo.pressione,
            ),
            vento: Value(
              meteo.vento,
            ),
            condizioni: Value(
              meteo.condizioni,
            ),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );

        // UPDATE CLOUD

        await Supabase.instance.client
            .from(
          'fishing_sessions',
        )
            .update({
          'temperatura': meteo.temperatura,
          'pressione': meteo.pressione,
          'vento': meteo.vento,
          'condizioni': meteo.condizioni,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }).eq(
          'id',
          s.id,
        );
      }
    } catch (e) {}
  }


  Future<Profile?> getProfile() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return null;
  }

  return (select(profiles)
        ..where((t) => t.id.equals(user.id)))
      .getSingleOrNull();
}

Future<void> saveProfile(ProfilesCompanion profile) async {
  await into(profiles).insert(
    profile,
    mode: InsertMode.insertOrReplace,
  );
}

Future<void> updateProfile(Profile profile) async {
  await (update(profiles)
        ..where((t) => t.id.equals(profile.id)))
      .write(
    ProfilesCompanion(
      nome: Value(profile.nome),
      cognome: Value(profile.cognome),
      email: Value(profile.email),
      language: Value(profile.language),
      avatar: Value(profile.avatar),
      synced: Value(profile.synced),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}

  Future<void> creaSpotSeManca({
    required String nome,
    double? lat,
    double? lon,
  }) async {
    if (lat == null || lon == null) {
      return;
    }

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      final existing = await Supabase.instance.client
          .from(
            'spots',
          )
          .select()
          .eq(
            'user_id',
            userId,
          )
          .eq(
            'nome',
            nome,
          );

      if (existing.isNotEmpty) {
        return;
      }

      await Supabase.instance.client
          .from(
        'spots',
      )
          .insert({
        'user_id': userId,
        'nome': nome,
        'latitudine': lat,
        'longitudine': lon,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      print(
        "Errore spot: $e",
      );
    }
  }

Future<void> updateSpot({
  required String id,
  required String nome,
  required double latitudine,
  required double longitudine,
}) async {
  final now = DateTime.now().toUtc();

  // Aggiorna lo spot
  await (update(spots)
        ..where((t) => t.id.equals(id)))
      .write(
    SpotsCompanion(
      nome: Value(nome),
      latitudine: Value(latitudine),
      longitudine: Value(longitudine),
      updatedAt: Value(now),
      synced: const Value(false),
    ),
  );

  // Aggiorna tutte le sessioni collegate allo spot
  await (update(fishingSessions)
        ..where((t) => t.spotId.equals(id)))
      .write(
    FishingSessionsCompanion(
      luogo: Value(nome),
      updatedAt: Value(now),
      synced: const Value(false),
    ),
  );
}

Future<void> deleteSpot(String id) async {
  await (update(spots)
        ..where((t) => t.id.equals(id)))
      .write(
    SpotsCompanion(
      deletedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}

Future<List<Spot>> getAllSpots() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return [];
  }

  return (select(spots)
      ..where((t) =>
          t.userId.equals(user.id) &
          t.deletedAt.isNull()))
    .get();
    }

Future<NearbySpotResult> findNearestSpot({
  required double latitude,
  required double longitude,
  double maxDistanceMeters = 20,
}) async {
    final allSpots = await getAllSpots();

  Spot? nearestSpot;
  double nearestDistance = maxDistanceMeters;

  for (final spot in allSpots) {
    if (spot.latitudine == null || spot.longitudine == null) {
      continue;
    }

    final distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      spot.latitudine!,
      spot.longitudine!,
    );
print(
  'Spot: ${spot.nome} - distanza: ${distance.toStringAsFixed(2)} m',
);


    if (distance < nearestDistance) {
      nearestDistance = distance;
      nearestSpot = spot;
    }
  }

  if (nearestSpot != null) {
  print(
    'Scelto: ${nearestSpot.nome}',
  );
} else {
  print(
    'Nessuno spot trovato entro $maxDistanceMeters m',
  );
}

return NearbySpotResult(
  spot: nearestSpot,
  distance: nearestSpot == null ? null : nearestDistance,
);
}

  Future<void> insertSpot(
    SpotsCompanion spot,
  ) async {
    await into(
      spots,
    ).insert(
      spot.copyWith(
        synced: const Value(false),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

Future<int> getSpotCount() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return 0;
  }

  final data = await (select(spots)
        ..where((t) => t.userId.equals(user.id)&t.deletedAt.isNull()))
        
      .get();

  return data.length;
}

Future<Spot?> getSpotByNome(String nome) async {
  final pulito = nome.trim();

  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return null;
  }

  final risultati = await (select(spots)
        ..where(
          (t) =>
              t.userId.equals(user.id) &
              t.nome.equals(pulito),
        ))
      .get();

  return risultati.isEmpty ? null : risultati.first;
}

Future<List<SessionCatchData>> getSessionCatches(
  String sessionId,
) {
  return (select(sessionCatch)
        ..where((t) => t.sessionId.equals(sessionId)))
      .get();
}

Future<void> saveSessionCatch(
  SessionCatchCompanion catchData,
) async {
  await into(sessionCatch).insertOnConflictUpdate(
    catchData.copyWith(
      synced: const Value(false),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}

Future<void> deleteSessionCatch(
  String id,
) async {
  await (update(sessionCatch)
        ..where((t) => t.id.equals(id)))
      .write(
    SessionCatchCompanion(
      deletedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}

Future<void> deleteSessionCatches(
  String sessionId,
) async {
  await (update(sessionCatch)
        ..where((t) => t.sessionId.equals(sessionId)))
      .write(
    SessionCatchCompanion(
      deletedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}

Future<List<String>> getUsedSpecies() async {
  final result = await customSelect(
    '''
    SELECT DISTINCT species
    FROM session_catch
    WHERE species IS NOT NULL
      AND species <> ''
    ORDER BY species
    ''',
  ).get();

  return result
      .map((row) => row.read<String>('species'))
      .toList();
}

Future<void> syncPendingSessionCatches() async {
  print(">>> syncPendingSessionCatches()");

  try {
    final pending = await (select(sessionCatch)
          ..where((t) => t.synced.equals(false)))
        .get();

    print("Catture da sincronizzare: ${pending.length}");

    for (final c in pending) {
      print("Upload cattura ${c.id} (${c.species})");
      print("Sessione: ${c.sessionId}");
      await Supabase.instance.client
          .from('session_catch')
          .upsert({
        'id': c.id,
        'session_id': c.sessionId,
        'species': c.species,
        'quantity': c.quantity,
        'created_at': c.createdAt.toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
        'deleted_at': c.deletedAt?.toUtc().toIso8601String(),
      });

      await (update(sessionCatch)
            ..where((t) => t.id.equals(c.id)))
          .write(
        const SessionCatchCompanion(
          synced: Value(true),
        ),
      );
    }
  } catch (e, st) {
    print("ERRORE syncPendingSessionCatches");
    print(e);
    print(st);
  }
}

Future<void> saveSessionLog(
  SessionLogCompanion event,
) async {
  await into(sessionLog).insertOnConflictUpdate(
    event.copyWith(
      synced: const Value(false),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}

Future<List<SessionLogData>> getSessionLog(
  String sessionId,
) {
  return (select(sessionLog)
        ..where((t) => t.sessionId.equals(sessionId))
        ..orderBy([
          (t) => OrderingTerm.asc(t.timestamp),
        ]))
      .get();
}

Future<void> deleteSessionLog(
  String id,
) async {
  await (update(sessionLog)
        ..where((t) => t.id.equals(id)))
      .write(
    SessionLogCompanion(
      deletedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}

Future<void> deleteSessionLogs(
  String sessionId,
) async {
  await (update(sessionLog)
        ..where((t) => t.sessionId.equals(sessionId)))
      .write(
    SessionLogCompanion(
      deletedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}

}