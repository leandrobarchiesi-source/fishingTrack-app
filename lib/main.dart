import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database/app_database.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/sessions/presentation/new_session_page.dart';
import 'features/sessions/presentation/session_detail_page.dart';
import 'widgets/supabase_status_widget.dart';
import 'services/profile_service.dart';
import 'features/language/presentation/language_page.dart';
import 'features/profile/presentation/profile_page.dart';
import 'features/spots/presentation/spots_page.dart';
import 'services/connectivity_service.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'core/t.dart';
import 'core/restart_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yvkzmkkecwbmimbvckso.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl2a3pta2tlY3dibWltYnZja3NvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3MTcwODksImV4cCI6MjA5NDI5MzA4OX0.6IsjDm5egHBpDw04Z5CUvNGGUKeCY3BGtpJIyhy1qXg',
  );

  print(
    "SESSIONE AVVIO:",
  );

  print(
    Supabase.instance.client.auth.currentSession,
  );

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  runApp(
    const RestartWidget(
      child: FishingApp(),
    ),
  );
}

final database = AppDatabase();

class FishingApp extends StatelessWidget {
  const FishingApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FishingTrack',
      home: session != null ? const HomePage() : const LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final profileService = ProfileService();

  bool loadingIniziale = true;
  int spotCount = 0;

  StreamSubscription? connectivitySubscription;

  @override
  void initState() {
    super.initState();

    inizializza();

    connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (result) async {
        if (result != ConnectivityResult.none) {

        }
      },
    );
  }

  Future<void> inizializza() async {
    print(
      "USER:",
    );

    print(
      Supabase.instance.client.auth.currentUser,
    );

    print(
      "SESSION:",
    );

    print(
      Supabase.instance.client.auth.currentSession,
    );

    try {
      spotCount = await database.getSpotCount();

      final online = await ConnectivityService.isOnline();

      if (online) {
        await profileService.creaProfiloSeManca();
        await profileService.caricaLingua();


        spotCount = await database.getSpotCount();
      }

      // MINIMO TEMPO DI VISUALIZZAZIONE

      await Future.delayed(
        const Duration(
          milliseconds: 1200,
        ),
      );
    } catch (e) {
      print(
        "Errore inizializzazione: $e",
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      loadingIniziale = false;
    });
  }

  Future<void> sincronizza() async {
    try {
      await database.syncPendingSessions();
      await database.syncPendingSpots();
      await database.syncFromSupabase();
      await database.syncSpotsFromSupabase();
      await database.syncMissingWeather();
    } catch (e) {
      print(
        "Errore sync iniziale: $e",
      );
    }

    // SEMPRE locale
    spotCount = await database.getSpotCount();

    if (!mounted) return;

    setState(() {});
  }

  Future<List<FishingSession>> loadSessions() async {
    return database.getAllSessions();
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loadingIniziale) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4FBFF),
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: Color(0xFF1976D2),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
            ),
            onPressed: () async {
              final online = await ConnectivityService.isOnline();

              if (!online) {
                if (!mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Profilo disponibile solo online",
                    ),
                  ),
                );

                return;
              }

              if (!mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewSessionPage(
                database: database,
              ),
            ),
          );

          if (result == true) {
            setState(
              () {},
            );
          }
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder<List<FishingSession>>(
        future: loadSessions(),
        builder: (
          context,
          snapshot,
        ) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final sessions = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(
              16,
            ),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFD9EEF8),
                      Color(0xFFBFE3F7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/logo.png",
                        height: 85,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _boxStat(
                          Icons.phishing,
                          sessions.length.toString(),
                          T.sessions,
                        ),
                        FutureBuilder<bool>(
                          future: ConnectivityService.isOnline(),
                          builder: (context, snapshot) {
                            final online = snapshot.data ?? false;

                            return _boxStat(
                              Icons.cloud,
                              online ? "ON" : "OFF",
                              T.cloud,
                            );
                          },
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SpotsPage(),
                                ),
                              );
                            },
                            child: _boxStat(
                              Icons.place,
                              spotCount.toString(),
                              T.spots,
                            )),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                T.recentSessions,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: sincronizza,
    icon: const Icon(Icons.sync),
    label: const Text("Sincronizza"),
  ),
),
              const SizedBox(
                height: 15,
              ),
              ...sessions.map(
                (session) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(
                        16,
                      ),
                      leading: const CircleAvatar(
                        child: Icon(
                          Icons.phishing,
                        ),
                      ),
                      title: Text(
                        session.luogo,
                      ),
                      subtitle: Text("${session.data.toString().split(" ")[0]}"
                          "\n${T.sessionType(session.tipoPescata)}"),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SessionDetailPage(
                              session: session,
                              database: database,
                            ),
                          ),
                        );

                        if (result == true) {
                          setState(
                            () {},
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _boxStat(
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF0D47A1),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1)),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1565C0),
          ),
        ),
      ],
    );
  }
}
