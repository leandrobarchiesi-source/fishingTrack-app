import 'dart:async';

import 'package:flutter/material.dart';

import '../../../database/app_database.dart';

class LiveSessionPage extends StatefulWidget {
  final AppDatabase database;
  final FishingSession session;

  const LiveSessionPage({
    super.key,
    required this.database,
    required this.session,
  });

  @override
  State<LiveSessionPage> createState() => _LiveSessionPageState();
}

class _LiveSessionPageState extends State<LiveSessionPage> {
  bool sessionStarted = false;

  int casts = 0;
  int totalFish = 0;

  Duration sessionTime = Duration.zero;
  Duration castTime = Duration.zero;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted || !sessionStarted) return;

        setState(() {
          sessionTime += const Duration(seconds: 1);
          castTime += const Duration(seconds: 1);
        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');

    return "$h:$m:$s";
  }

  void startSession() {
    setState(() {
      sessionStarted = true;
      sessionTime = Duration.zero;
      castTime = Duration.zero;
      casts = 0;
      totalFish = 0;
    });
  }

  void cast() {
    if (!sessionStarted) return;

    setState(() {
      casts++;
      castTime = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("SESSIONE LIVE"),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              Text(
                widget.session.luogo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                "${widget.session.data.day.toString().padLeft(2, '0')}/"
                "${widget.session.data.month.toString().padLeft(2, '0')}/"
                "${widget.session.data.year}",
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                format(castTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                sessionStarted
                    ? "Tempo dal CAST"
                    : "Pronto ad iniziare",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 80,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sessionStarted
                        ? Colors.blue
                        : Colors.green,
                  ),

                  onPressed: sessionStarted
                      ? cast
                      : startSession,

                  child: Text(
                    sessionStarted
                        ? "🎣 CAST"
                        : "▶ START SESSIONE",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [

                  Expanded(
                    child: Card(
                      color: const Color(0xff202020),

                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 20),

                        child: Column(
                          children: [

                            const Text(
                              "CAST",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              casts.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Card(
                      color: const Color(0xff202020),

                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 20),

                        child: Column(
                          children: [

                            const Text(
                              "PESCI",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              totalFish.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Text(
                "Durata Sessione\n${format(sessionTime)}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),

                  icon: const Icon(Icons.stop),

                  label: const Text(
                    "TERMINA PESCATA",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}