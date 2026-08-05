import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database/app_database.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/sessions/presentation/session_detail_page.dart';
import 'services/profile_service.dart';
import 'features/spots/presentation/spots_page.dart';
import 'dart:async';
import 'core/t.dart';
import 'core/restart_widget.dart';
import 'features/auth/presentation/splash_page.dart';
import 'core/app_settings.dart';
import 'features/settings/presentation/settings_page.dart';
import 'services/sync_service.dart';
import 'services/connectivity_service.dart';
import 'features/sessions/presentation/new_session_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
]);

  await Supabase.initialize(
    url: 'https://yvkzmkkecwbmimbvckso.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl2a3pta2tlY3dibWltYnZja3NvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3MTcwODksImV4cCI6MjA5NDI5MzA4OX0.6IsjDm5egHBpDw04Z5CUvNGGUKeCY3BGtpJIyhy1qXg',
  );

await Supabase.instance.client.auth.signOut();
await AppSettings.load();
await ConnectivityService.initialize();

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
    return const MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'FishingTrack',
  home: SplashPage(),
);  }
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
  String lastSync = T.never;


@override
void initState() {
  super.initState();
  inizializza();
}

Future<void> inizializza() async {
  print("USER:");
  print(Supabase.instance.client.auth.currentUser);

  print("SESSION:");
  print(Supabase.instance.client.auth.currentSession);

  try {
    await refreshDashboard();
  } catch (e) {
    print("Errore inizializzazione: $e");
  }

  // Leggi sempre l'ultima sincronizzazione
  final dt = AppSettings.lastSync;

  if (dt == null) {
    lastSync = T.never;
  } else {
    lastSync =
        "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  if (!mounted) return;

  setState(() {
    loadingIniziale = false;
  });
}

Future<void> sincronizza() async {
  try {
    await SyncService.sync(database);
  } catch (e) {
    debugPrint("Errore sincronizzazione: $e");
  }

  await refreshDashboard();

  final dt = AppSettings.lastSync;

  lastSync = dt == null
      ? T.never
      : "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";

  if (!mounted) return;

  setState(() {});
}

  Future<List<FishingSession>> loadSessions() async {
    return database.getAllSessions();
  }

Future<void> loadDashboardData() async {
  spotCount = await database.getSpotCount();
}

Future<void> refreshDashboard() async {
  try {
    await loadDashboardData();

    final dt = AppSettings.lastSync;

    lastSync = dt == null
        ? T.never
        : "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year} "
          "${dt.hour.toString().padLeft(2, '0')}:"
          "${dt.minute.toString().padLeft(2, '0')}";
  } catch (e) {
    debugPrint("Errore refresh dashboard: $e");
  }

  if (!mounted) return;

  setState(() {});
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
  await refreshDashboard();
}


        },
        child: const Icon(
Icons.add_rounded
        ),
      ),
body: SafeArea(
  child: FutureBuilder<List<FishingSession>>(
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
              _buildDashboard(sessions),
              const SizedBox(
                height: 10,
              ),
Center(
  child: Text(
    T.recentSessions,
    style: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
),
      
              const SizedBox(
                height: 10,
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
  await refreshDashboard();
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
),
    );
  }

Widget _buildDashboard(List<FishingSession> sessions) {
  return Column(
    children: [
      // Header
      Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/logo.png",
              height: 85,
            ),
          ),

          Positioned(
            top: -6,
            right: -12,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.settings,
                size: 28,
                color: Color(0xFF1565C0),
              ),
onPressed: () async {
await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => SettingsPage(
      database: database,
    ),
  ),
);
  await refreshDashboard();
},            ),
          ),
        ],
      ),

      const SizedBox(height: 10),

      Container(
padding: const EdgeInsets.only(
  left: 18,
  right: 18,
  top: 12,
  bottom: 6,
),        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFD9EEF8),
              Color(0xFFBFE3F7),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _boxStat(
                  Icons.phishing,
                  sessions.length.toString(),
                  T.sessions,
                ),

ValueListenableBuilder<bool>(
  valueListenable: ConnectivityService.online,
  builder: (context, online, _) {
    return _boxStat(
      Icons.circle,
      online ? T.online : T.offline,
      T.status,
      color: online ? Colors.green : Colors.red,
    );
  },
),

InkWell(
  borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SpotsPage(),
                      ),
                    );

                    await refreshDashboard();
                  },
                  child: _boxStat(
                    Icons.place,
                    spotCount.toString(),
                    T.spots,
                    open: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Divider(),

            const SizedBox(height: 4),

            Center(
              child: Text(
                "🕒 ${T.lastSync}: $lastSync",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    ],
  );
}

Widget _boxStat(
  IconData icon,
  String value,
  String label, {
  Color color = const Color(0xFF0D47A1),
  bool open = false,
})
  {
    return Column(
      children: [
Icon(
  icon,
  size: 22,
  color: color,
),
        const SizedBox(
          height: 6,
        ),
        Text(
          value,
style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: color,
),     
   ),
Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(
      label,
      style: const TextStyle(
        color: Color(0xFF1565C0),
      ),
    ),
    if (open) ...[
      const SizedBox(width: 3),
      const Icon(
        Icons.arrow_forward_ios,
        size: 11,
        color: Color(0xFF1565C0),
      ),
    ]
  ],
),
      ],
    );
  }
}
