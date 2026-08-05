import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'new_session_page.dart';
import '../../../database/app_database.dart';
import '../../../core/t.dart';
import 'live_session_page.dart';
import '../../../core/session_constants.dart';

class SessionDetailPage extends StatefulWidget {
    final FishingSession session;

  final AppDatabase database;

  const SessionDetailPage({
    super.key,
    required this.session,
    required this.database,
  });

  @override
State<SessionDetailPage> createState() =>
    _SessionDetailPageState();
}

class _SessionDetailPageState
    extends State<SessionDetailPage> {

      late FishingSession session;
      List<SessionCatchData> catches = [];

@override
void initState() {
  super.initState();

  session = widget.session;

loadCatches();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    aggiornaMeteoSeNecessario();
  });
}

Future<void> loadCatches() async {
  catches = await widget.database.getSessionCatches(
    session.id,
  );

  if (mounted) {
    setState(() {});
  }
}

Future<void> aggiornaMeteoSeNecessario() async {
  print("Controllo meteo per sessione ${session.id}");

  final aggiornato =
      await widget.database.completaMeteoSessione(session.id);

  print("Meteo aggiornato? $aggiornato");

  if (!mounted || !aggiornato) {
    return;
  }

  final nuova =
      await widget.database.getSessionById(session.id);

  if (nuova != null) {
    setState(() {
      session = nuova;
    });
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(T.weatherUpdated),
    ),
  );
}
  String formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/"
        "${d.month.toString().padLeft(2, '0')}/"
        "${d.year}";
  }

  String formatTime(DateTime d) {
    return "${d.hour.toString().padLeft(2, '0')}:"
        "${d.minute.toString().padLeft(2, '0')}";
  }

  Future<void> apriMappa() async {
    if (session.latitudine == null || session.longitudine == null) {
      return;
    }

    final Uri url = Uri.parse(
      "https://www.google.com/maps?q="
      "${session.latitudine},${session.longitudine}",
    );

    await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    );
  }

  @override
  Widget build(BuildContext context) {
    final durata = session.oraFine.difference(
      session.oraInizio,
    );

    final ore = durata.inHours;

    final minuti = durata.inMinutes % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          T.sessionSummary,
        ),
        actions: [
                    IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () async {
              final conferma = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    T.deleteSession,
                  ),
                  content: Text(
                    T.deleteSessionQuestion,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          false,
                        );
                      },
                      child: Text(
                        T.cancel,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          true,
                        );
                      },
                      child: Text(
                        T.delete,
                      ),
                    ),
                  ],
                ),
              );

              if (conferma != true) {
                return;
              }

              await widget.database.deleteSession(
                session.id,
              );

              if (context.mounted) {
                Navigator.pop(
                  context,
                  true,
                );
              }
            },
          ),
        

if (session.mode == SessionMode.standard)
  IconButton(
    icon: const Icon(Icons.edit),
    onPressed: () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewSessionPage(
            database: widget.database,
            session: session,
          ),
        ),
      );

      if (context.mounted && result == true) {
        Navigator.pop(context, true);
      }
    },
  ),        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "📍 ${session.luogo}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
Text(
  "🎣 ${T.sessionType(session.tipoPescata)}",
),

if (session.mode == SessionMode.standard ||
    session.status == SessionStatus.completed) ...[
  const SizedBox(
    height: 10,
  ),
  Text(
    "📅 ${formatDate(session.data)}",
  ),
  const SizedBox(
    height: 10,
  ),
  Text(
    "🕒 ${formatTime(session.oraInizio)} → ${formatTime(session.oraFine)}",
  ),
  const SizedBox(
    height: 10,
  ),
  Text(
    "${T.duration}: ${ore}h ${minuti}m",
  ),
],

const SizedBox(
  height: 20,
),
                  if (session.latitudine != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "📍 ${T.coordinates}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "${session.latitudine}, "
                          "${session.longitudine}",
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton.icon(
                          onPressed: apriMappa,
                          icon: const Icon(
                            Icons.map,
                          ),
                          label: Text(
                            T.openInMaps,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        if (session.mode == SessionMode.standard ||
    session.status == SessionStatus.completed) ...[
                        Text(
                          "🌤 ${T.weather}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          session.temperaturaAcqua != null
                              ? "💧 ${session.temperaturaAcqua!.toStringAsFixed(1)}°C"
                              : "💧 -",
                        ),
                        if (session.temperatura != null)
                          Text(
                            "🌡 ${session.temperatura}°C",
                          ),
                        if (session.vento != null)
                          Text(
                            "💨 ${session.vento}",
                          ),
                        if (session.pressione != null)
                          Text(
                            "📈 ${session.pressione} hPa",
                          ),
                        if (session.condizioni != null)
                          Text(
                            "☁ ${T.weatherCondition(session.condizioni!)}",
                          ),
                        if (session.faseLunare != null)
                          Text(
                            T.moonPhase(
                              session.faseLunare!,
                            ),
                          ),
    ],
                      ],
                    ),
                  const SizedBox(
                    height: 8,
                  ),

if (catches.isNotEmpty)
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),

      Text(
        "🎣 ${T.catches}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 8),

      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: catches.map((c) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(c.species),
                    ),
                    Text(
                      c.quantity.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );



            }).toList(),
          ),
        ),
      ),

      const SizedBox(height: 8),
    ],
  ),

                  if (session.note != null && session.note!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "📝 ${T.notes}",
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              session.note!,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

if (session.mode == SessionMode.live &&
    session.status == SessionStatus.planned)
  SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LiveSessionPage(
              database: widget.database,
              session: session,
            ),
          ),
        );
      },
      child: const Text(
        "APRI LIVE",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),        ],
      ),
    );
      }
}
