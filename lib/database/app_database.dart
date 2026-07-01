import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/wheater/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'tables/fishing_sessions.dart';
import 'tables/spots.dart';
import 'nearby_spot_result.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    FishingSessions,
    Spots,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          _openConnection(),
        );

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (
          Migrator m,
          int from,
          int to,
        ) async {
          if (from < 2) {
            await m.addColumn(
              fishingSessions,
              fishingSessions.synced,
            );
          }

          if (from < 3) {
            await m.createTable(
              spots,
            );
          }

          if (from < 4) {
            await m.addColumn(
              fishingSessions,
              fishingSessions.spotId,
            );
          }

          if (from < 5) {
            await m.addColumn(
              spots,
              spots.synced,
            );
          }
          if (from < 6) {
            await m.addColumn(
              fishingSessions,
              fishingSessions.temperaturaAcqua,
            );
          }
        },
      );

  Future<List<Spot>> getAllSpots() {
    return select(
      spots,
    ).get();
  }

Future<NearbySpotResult> findNearestSpot({
  required double latitude,
  required double longitude,
  double maxDistanceMeters = 8,
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

  Future<List<FishingSession>> getAllSessions() {
    return select(
      fishingSessions,
    ).get();
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

    await creaSpotSeManca(
      nome: session.luogo.value,
      lat: session.latitudine.present ? session.latitudine.value : null,
      lon: session.longitudine.present ? session.longitudine.value : null,
    );
  }

  Future<void> deleteSession(
    String id,
  ) async {
    await (delete(
      fishingSessions,
    )..where(
            (tbl) => tbl.id.equals(
              id,
            ),
          ))
        .go();

    try {
      await Supabase.instance.client
          .from(
            'fishing_sessions',
          )
          .delete()
          .eq(
            'id',
            id,
          );
    } catch (e) {}
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

    print(
      session.id,
    );
  }

  Future<void> syncPendingSessions() async {
    try {
      final pending = await (select(
        fishingSessions,
      )..where(
              (t) => t.synced.equals(
                false,
              ),
            ))
          .get();

      for (final s in pending) {
        await Supabase.instance.client
            .from(
          'fishing_sessions',
        )
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

        await (update(
          fishingSessions,
        )..where(
                (t) => t.id.equals(
                  s.id,
                ),
              ))
            .write(
          const FishingSessionsCompanion(
            synced: Value(
              true,
            ),
          ),
        );
      }
    } catch (e) {}
  }

  Future<void> syncFromSupabase() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      final data = await Supabase.instance.client
          .from(
            'fishing_sessions',
          )
          .select()
          .eq(
            'user_id',
            user.id,
          );

      for (final item in data) {
        final locale = await (select(
          fishingSessions,
        )..where(
                (t) => t.id.equals(
                  item['id'],
                ),
              ))
            .getSingleOrNull();

        if (locale != null && locale.synced == false) {
          continue;
        }

        final cloudSession = FishingSessionsCompanion.insert(
          id: item['id'],
          userId: item['user_id'],
          spotId: Value(
            item['spot_id'],
          ),
          luogo: item['luogo'],
          tipoPescata: item['tipo_pescata'],
          data: DateTime.parse(
            item['data'],
          ),
          oraInizio: DateTime.parse(
            item['ora_inizio'],
          ),
          oraFine: DateTime.parse(
            item['ora_fine'],
          ),
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
          vento: Value(
            item['vento'],
          ),
          condizioni: Value(
            item['condizioni'],
          ),
          faseLunare: Value(
            item['fase_lunare'],
          ),
          note: Value(
            item['note'],
          ),
          synced: const Value(
            true,
          ),
          createdAt: DateTime.parse(
            item['created_at'],
          ),
          updatedAt: DateTime.parse(
            item['updated_at'],
          ),
        );

        await into(
          fishingSessions,
        ).insert(
          cloudSession,
          mode: InsertMode.insertOrReplace,
        );
      }
    } catch (e) {}
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

        if (locale != null && locale.synced == false) {
          print(
            "Spot locale modificato -> skip",
          );

          continue;
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

      final tutti = await select(
        spots,
      ).get();
    } catch (e) {
      print(
        "Errore sync spot: $e",
      );
    }
  }

  Future<void> syncPendingSpots() async {
    try {
      final pending = await (select(
        spots,
      )..where(
              (t) => t.synced.equals(
                false,
              ),
            ))
          .get();

      print(
        pending.length,
      );

      for (final s in pending) {
        await Supabase.instance.client
            .from(
          'spots',
        )
            .upsert({
          'id': s.id,
          'user_id': s.userId,
          'nome': s.nome,
          'latitudine': s.latitudine,
          'longitudine': s.longitudine,
          'created_at': s.createdAt.toUtc().toIso8601String(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        });

        await (update(
          spots,
        )..where(
                (t) => t.id.equals(
                  s.id,
                ),
              ))
            .write(
          const SpotsCompanion(
            synced: Value(
              true,
            ),
          ),
        );
      }
    } catch (e) {}
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

  Future<int> getSpotCount() async {
    final data = await select(
      spots,
    ).get();

    return data.length;
  }

  Future<Spot?> getSpotByNome(
    String nome,
  ) async {
    final pulito = nome.trim();

    // Cerca locale
    final risultati = await (select(spots)
          ..where(
            (t) => t.nome.equals(
              pulito,
            ),
          ))
        .get();

    final locale = risultati.isEmpty ? null : risultati.first;
    if (locale != null) {
      return locale;
    }

    try {
      // Cerca Supabase
      final remoto = await Supabase.instance.client
          .from(
            'spots',
          )
          .select()
          .eq(
            'user_id',
            Supabase.instance.client.auth.currentUser!.id,
          )
          .eq(
            'nome',
            pulito,
          )
          .maybeSingle();

      if (remoto == null) {
        return null;
      }

      // restituisce direttamente lo spot dal cloud
      // senza reinserirlo localmente

      return Spot(
        id: remoto['id'],
        userId: remoto['user_id'],
        nome: remoto['nome'],
        latitudine: (remoto['latitudine'] as num?)?.toDouble(),
        longitudine: (remoto['longitudine'] as num?)?.toDouble(),
        note: remoto['note'],
        preferito: remoto['preferito'] ?? false,
        synced: true,
        createdAt: DateTime.parse(
          remoto['created_at'],
        ),
        updatedAt: DateTime.parse(
          remoto['updated_at'],
        ),
      );
    } catch (e) {
      return null;
    }
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
    await (update(
      spots,
    )..where(
            (t) => t.id.equals(
              id,
            ),
          ))
        .write(
      SpotsCompanion(
        nome: Value(
          nome,
        ),
        latitudine: Value(
          latitudine,
        ),
        longitudine: Value(
          longitudine,
        ),
        updatedAt: Value(DateTime.now().toUtc()),
        synced: const Value(
          false,
        ),
      ),
    );
  }

  Future<void> deleteSpot(
    String id,
  ) async {
    await (delete(
      spots,
    )..where(
            (t) => t.id.equals(
              id,
            ),
          ))
        .go();

    try {
      await Supabase.instance.client
          .from(
            'spots',
          )
          .delete()
          .eq(
            'id',
            id,
          );
    } catch (e) {}
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();

      final file = File(
        p.join(
          dbFolder.path,
          'fishing_app.sqlite',
        ),
      );

      return NativeDatabase(
        file,
      );
    },
  );
}
