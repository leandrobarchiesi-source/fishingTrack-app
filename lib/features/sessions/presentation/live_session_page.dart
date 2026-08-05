import 'dart:async';
import 'package:flutter/services.dart';

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

/// Tempo dall'ultima cattura
Duration lastCatchTime = Duration.zero;

/// Tempo dall'ultimo CAST
Duration recoveryTime = Duration.zero;

/// Timer recupero impostato dall'utente
Duration recoveryLimit = Duration.zero;

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
  lastCatchTime += const Duration(seconds: 1);
  recoveryTime += const Duration(seconds: 1);
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
lastCatchTime = Duration.zero;
recoveryTime = Duration.zero;

casts = 0;
totalFish = 0;    });
  }

void cast() {
  if (!sessionStarted) return;

  setState(() {
    casts++;
    recoveryTime = Duration.zero;
  });
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        child: Column(
          children: [
            // HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.session.luogo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  "${widget.session.data.day.toString().padLeft(2, '0')}/"
                  "${widget.session.data.month.toString().padLeft(2, '0')}/"
                  "${widget.session.data.year}",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            const Divider(
              color: Colors.white24,
              height: 1,
            ),

            const SizedBox(height: 18),

            // TEMPO ULTIMA CATTURA
            Text(
              format(lastCatchTime),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 54,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Tempo ultima cattura",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              recoveryLimit == Duration.zero
                  ? "Recupero: OFF"
                  : "Recupero: ${recoveryTime.inMinutes}:${(recoveryTime.inSeconds % 60).toString().padLeft(2, '0')} / ${recoveryLimit.inMinutes}:00",
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 20),

            const Divider(
              color: Colors.white24,
              height: 1,
            ),

            const SizedBox(height: 18),

            // START / CAST
GestureDetector(
  onTap: sessionStarted ? cast : startSession,
  child: Container(
    width: double.infinity,
    height: 72,
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      border: Border.all(
        color: Colors.white24,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    alignment: Alignment.center,
    child: Text(
      sessionStarted
          ? "CAST ($casts)"
          : "START SESSIONE",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w300,
        letterSpacing: 1.2,
      ),
    ),
  ),
),

Row(
  children: [

    Expanded(
      child: Text(
        "CATTURE ($totalFish)",
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    GestureDetector(
      onTap: () {},
      child: const Padding(
        padding: EdgeInsets.all(6),
        child: Text(
          "+",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    ),
  ],
),

const Divider(color: Colors.white24),

buildSpeciesRow(
  name: "Carpa",
  quantity: 0,
  onMinus: () {},
  onPlus: () {},
),

buildSpeciesRow(
  name: "Barbo",
  quantity: 0,
  onMinus: () {},
  onPlus: () {},
),

buildSpeciesRow(
  name: "Carassio",
  quantity: 0,
  onMinus: () {},
  onPlus: () {},
),

buildSpeciesRow(
  name: "Breme",
  quantity: 0,
  onMinus: () {},
  onPlus: () {},
),

const Spacer(),





            const SizedBox(height: 4),

            Text(
              "Durata sessione",
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              format(sessionTime),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Divider(
              color: Colors.white24,
              height: 1,
            ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "TERMINA SESSIONE",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildSpeciesRow({
  required String name,
  required int quantity,
  required VoidCallback onMinus,
  required VoidCallback onPlus,
}) {
  return Column(
    children: [
      SizedBox(
        height: 52,
        child: Row(
          children: [
            Expanded(
              child: Text(
                name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),

            GestureDetector(
              onTap: onMinus,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(
                width: 56,
                child: Center(
                  child: Text(
                    "-",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 50,
              child: Center(
                child: Text(
                  quantity.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: onPlus,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(
                width: 56,
                child: Center(
                  child: Text(
                    "+",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      const Divider(
        color: Colors.white24,
        height: 1,
      ),
    ],
  );
}

}