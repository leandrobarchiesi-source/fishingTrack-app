import 'dart:async';

import 'package:flutter/material.dart';

import '../../../database/app_database.dart';
import '../../../core/t.dart';
import '../models/live_counter.dart';
import '../../../database/session_event_type.dart';

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
  final List<LiveCounter> counters = [
  LiveCounter(counter: 1),];

  int casts = 0;
  int get totalFish =>
    counters.fold(0, (sum, c) => sum + c.quantity);

Duration lastCastTime = Duration.zero;     // timer grande
Duration lastCatchTime = Duration.zero;    // Last catch
Duration recoveryTime = Duration.zero;     // Recovery
Duration sessionTime = Duration.zero;      // Durata sessione

  Timer? timer;

@override
void initState() {
  debugPrint("STATUS: ${widget.session.status}");
  debugPrint("ORA INIZIO: ${widget.session.oraInizio}");

  super.initState();

  if (widget.session.status == "running") {
    sessionStarted = true;

    sessionTime = DateTime.now().difference(
      widget.session.oraInizio,
    );
    loadLiveData();
  }
  

  timer = Timer.periodic(
    const Duration(seconds: 1),
    (_) {
      if (!mounted || !sessionStarted) return;

      setState(() {
        sessionTime += const Duration(seconds: 1);
        lastCastTime += const Duration(seconds: 1);
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

Future<void> startSession() async {
  await widget.database.startLiveSession(
    widget.session.id,
  );

await widget.database.addStartEvent(
  widget.session.id,
);

  await widget.database.printSessionLog(
    widget.session.id,
  );

  setState(() {
    sessionStarted = true;

    lastCastTime = Duration.zero;
    lastCatchTime = Duration.zero;
    recoveryTime = Duration.zero;
    sessionTime = Duration.zero;

    casts = 1;
  });
}

Future<void> loadLiveData() async {
  final castCount =
      await widget.database.getCastCount(widget.session.id);

  if (!mounted) return;

  setState(() {
    casts = castCount == 0 ? 1 : castCount;
  });
}


Future<void> cast() async {
  if (!sessionStarted) return;

await widget.database.addCastEvent(
  widget.session.id,
);

  await widget.database.printSessionLog(
    widget.session.id,
  );

  setState(() {
    lastCastTime = Duration.zero;
    recoveryTime = Duration.zero;
    casts++;
  });
}

Future<void> endSession() async {
  await widget.database.endLiveSession(
    widget.session.id,
  );

  if (!mounted) return;

  Navigator.pop(context, true);
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

              Text(
  "${T.lastCatch} ${format(lastCatchTime)}",
                  style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              recoveryTime == Duration.zero
                  ? T.off
                  : "${T.recovery}: ${recoveryTime.inMinutes}:${(recoveryTime.inSeconds % 60).toString().padLeft(2, '0')} / ${recoveryTime.inMinutes}:00",
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
onTap: () async {
  if (sessionStarted) {
    cast();
  } else {
    await startSession();
  }
},
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
    ? T.casts(casts)
    : T.startSession.toUpperCase(),
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
T.catchesCount(totalFish),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    GestureDetector(
onTap: () {
  setState(() {
    counters.add(
      LiveCounter(
        counter: counters.length + 1,
      ),
    );
  });
},      child: const Padding(
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

...counters.map(
  (c) => buildCounterRow(
    counterNumber: c.counter,
    quantity: c.quantity,
onMinus: () async {
  if (c.quantity > 0) {
    setState(() {
      c.quantity--;
    });
    return;
  }

  if (c.counter == 1) {
    return;
  }

  final elimina = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(T.deleteCounter),
          content: Text(
            T.deleteCounterQuestion(c.counter),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(T.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(T.delete),
            ),
          ],
        ),
      ) ??
      false;

  if (!elimina) return;

  setState(() {
    counters.remove(c);

    for (int i = 0; i < counters.length; i++) {
      counters[i].counter = i + 1;
    }
  });
},
    onPlus: () {
      setState(() {
        c.quantity++;
        lastCatchTime = Duration.zero;
      });
    },
  ),
),

const Spacer(),

            const SizedBox(height: 4),

Text(
  T.duration,
                style: TextStyle(
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
              onPressed: () async {
                await endSession();
              },
              child: Text(
                T.endSession,
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

Widget buildCounterRow({
  required int counterNumber,
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
               T.counterNumber(counterNumber).toUpperCase(),
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