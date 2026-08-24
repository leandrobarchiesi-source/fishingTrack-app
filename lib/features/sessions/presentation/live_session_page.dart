import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../database/app_database.dart';
import '../../../core/t.dart';
import '../models/live_counter.dart';
import '../../../database/session_event_type.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

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
    LiveCounter(counter: 1),
  ];

  int casts = 0;

  // Ultimi 10 lanci CONCLUSI.
  //
  // true  = cattura
  // false = nessuna cattura
  //
  // Il lancio attualmente in corso non viene inserito.
  final List<bool> castResults = [];

  Duration lastCastTime = Duration.zero;
  Duration lastCatchTime = Duration.zero;
  Duration recoveryTime = Duration.zero;
  Duration sessionTime = Duration.zero;
  Duration? recoveryDuration;

  bool recoveryExpired = false;
  bool recoveryAlerted = false;
  bool recoverySoundEnabled = true;

  DateTime? lastCatchAt;

  Timer? timer;

  int get totalFish => counters.fold(
        0,
        (sum, c) => sum + c.quantity,
      );

  final AudioPlayer recoveryPlayer = AudioPlayer();


  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();

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

          if (lastCatchAt != null) {
            lastCatchTime = DateTime.now().difference(
              lastCatchAt!,
            );
          }

if (recoveryDuration != null) {
  recoveryTime += const Duration(seconds: 1);

  if (recoveryTime >= recoveryDuration! &&
      !recoveryAlerted) {
    recoveryTime = recoveryDuration!;
    triggerRecoveryAlert();
  }
}        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
    recoveryPlayer.dispose();
  }

  String format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');

    return "$h:$m:$s";
  }

Future<void> selectRecovery() async {
  final result = await showModalBottomSheet<double?>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('OFF'),
              onTap: () => Navigator.pop(context, 0.0),
            ),
            ListTile(
              title: const Text('1 min'),
              onTap: () => Navigator.pop(context, 1.0),
            ),
            ListTile(
              title: const Text('2 min'),
              onTap: () => Navigator.pop(context, 2.0),
            ),
            ListTile(
              title: const Text('3 min'),
              onTap: () => Navigator.pop(context, 3.0),
            ),
            ListTile(
              title: const Text('5 min'),
              onTap: () => Navigator.pop(context, 5.0),
            ),
            ListTile(
              title: const Text('8 min'),
              onTap: () => Navigator.pop(context, 8.0),
            ),
            ListTile(
              title: const Text('Personalizza...'),
              onTap: () async {
                final controller = TextEditingController();

                final custom = await showDialog<double>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Recupero personalizzato'),
                      content: TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Minuti',
                          hintText: 'Es. 2,5',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          child: const Text('Annulla'),
                        ),
                        FilledButton(
                          onPressed: () {
                            final text = controller.text
                                .trim()
                                .replaceAll(',', '.');

                            final value = double.tryParse(text);

                            if (value == null || value <= 0) {
                              return;
                            }

                            Navigator.of(dialogContext).pop(value);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );

                if (!context.mounted || custom == null) {
                  return;
                }

                Navigator.of(context).pop(custom);
              },
            ),
          ],
        ),
      );
    },
  );

  if (!mounted || result == null) {
    return;
  }

  setState(() {
    if (result == 0.0) {
      recoveryDuration = null;
      recoveryTime = Duration.zero;
      recoveryExpired = false;
      recoveryAlerted = false;
    } else {
      recoveryDuration = Duration(
        milliseconds: (result * 60 * 1000).round(),
      );

      recoveryTime = Duration.zero;
      recoveryExpired = false;
      recoveryAlerted = false;
    }
  });
}

Future<void> triggerRecoveryAlert() async {
  if (recoveryAlerted) return;

  recoveryAlerted = true;
  recoveryExpired = true;

  final hasVibrator = await Vibration.hasVibrator();

  if (hasVibrator) {
    await Vibration.vibrate(
      duration: 700,
    );
  }

  if (recoverySoundEnabled) {
    await recoveryPlayer.play(
      AssetSource('sounds/recovery_beep.wav'),
    );
  }

  if (!mounted) return;

  setState(() {});
}
  // ------------------------------------------------------------
  // START SESSIONE
  // ------------------------------------------------------------

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

  recoveryExpired = false;
  recoveryAlerted = false;

  sessionTime = Duration.zero;

  casts = 1;

  castResults.clear();
});
  }

  // ------------------------------------------------------------
  // CARICAMENTO SESSIONE
  // ------------------------------------------------------------

  Future<void> loadLiveData() async {
    final castCount = await widget.database.getCastCount(
      widget.session.id,
    );

    final catchCounters = await widget.database.getCatchCounters(
      widget.session.id,
    );

    final lastCast = await widget.database.getLastCastTime(
      widget.session.id,
    );

    final lastCatch = await widget.database.getLastCatchTime(
      widget.session.id,
    );

    await loadCastResults();

    if (!mounted) return;

    setState(() {
      casts = castCount == 0 ? 1 : castCount;

      counters.clear();

      catchCounters.forEach((number, qty) {
        counters.add(
          LiveCounter(
            counter: number,
            quantity: qty,
          ),
        );
      });

      lastCastTime = lastCast == null
          ? Duration.zero
          : DateTime.now().difference(lastCast);

      lastCatchTime = lastCatch == null
          ? Duration.zero
          : DateTime.now().difference(lastCatch);
    });
  }

  // ------------------------------------------------------------
  // CALCOLO DEI 10 CERCHI
  // ------------------------------------------------------------
  //
  // Esempio:
  //
  // CAST
  // CATCH
  // CAST
  //
  // => primo cerchio VERDE
  //
  // CAST
  // CAST
  //
  // => secondo cerchio ROSSO
  //
  // L'ultimo CAST non viene mai visualizzato.
  //
  // ------------------------------------------------------------

  Future<void> loadCastResults() async {
    final events = await widget.database.getSessionEvents(
      widget.session.id,
    );

    final results = <bool>[];

    bool hasCurrentCast = false;
    bool catchFromCurrentCast = false;

    for (final event in events) {
      // START = primo lancio
      if (event.eventType == SessionEventType.start) {
        hasCurrentCast = true;
        catchFromCurrentCast = false;
        continue;
      }

      // Un nuovo CAST chiude il lancio precedente
      if (event.eventType == SessionEventType.cast) {
        if (hasCurrentCast) {
          results.add(catchFromCurrentCast);
        }

        // Il nuovo lancio diventa quello attualmente in corso
        hasCurrentCast = true;
        catchFromCurrentCast = false;
        continue;
      }

      // Una cattura appartiene al lancio attualmente in corso
      if (event.eventType == SessionEventType.catchFish) {
        if (hasCurrentCast) {
          catchFromCurrentCast = true;
        }
      }
    }

    // L'ultimo lancio NON viene aggiunto:
    // è ancora quello in corso.

    final visibleResults =
        results.length <= 15 ? results : results.sublist(results.length - 15);

    if (!mounted) return;

    setState(() {
      castResults
        ..clear()
        ..addAll(visibleResults);
    });
  }
  // ------------------------------------------------------------
  // CAST
  // ------------------------------------------------------------

  Future<void> cast() async {
    if (!sessionStarted) return;

    await widget.database.addCastEvent(
      widget.session.id,
    );

    await widget.database.printSessionLog(
      widget.session.id,
    );

    // Aggiorniamo i cerchi leggendo il log.
    await loadCastResults();

    if (!mounted) return;

setState(() {
  lastCastTime = Duration.zero;
  recoveryTime = Duration.zero;

  recoveryExpired = false;
  recoveryAlerted = false;

  casts++;
});  }

  // ------------------------------------------------------------
  // FINE SESSIONE
  // ------------------------------------------------------------

  Future<void> endSession() async {
    await widget.database.addEndEvent(
      widget.session.id,
    );

    await widget.database.endLiveSession(
      widget.session.id,
    );

    await widget.database.completaMeteoSessione(
      widget.session.id,
    );

    if (!mounted) return;

    // TODO: dialog temperatura acqua

    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

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
              // ------------------------------------------------
              // HEADER
              // ------------------------------------------------

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

              const SizedBox(height: 12),


// ------------------------------------------------
// TEMPO ULTIMO CAST
// ------------------------------------------------

Text(
  format(lastCastTime),
  style: TextStyle(
    color: recoveryExpired
        ? Colors.orange
        : Colors.white,
    fontSize: 54,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 6),

// ------------------------------------------------
// RECUPERO
// ------------------------------------------------

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    GestureDetector(
      onTap: selectRecovery,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${T.recovery}: ",
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: recoveryDuration == null
                  ? T.off
                  : "${recoveryDuration!.inMinutes}:"
                      "${(recoveryDuration!.inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),

    const SizedBox(width: 12),

    GestureDetector(
      onTap: () {
        setState(() {
          recoverySoundEnabled = !recoverySoundEnabled;
        });
      },
      child: Icon(
        recoverySoundEnabled
            ? Icons.volume_up
            : Icons.volume_off,
        color: Colors.white54,
        size: 22,
      ),
    ),
  ],
),

const SizedBox(height: 3),

// ------------------------------------------------
// ULTIMA CATTURA
// ------------------------------------------------

Text(
  "${T.lastCatch} ${format(lastCatchTime)}",
  style: const TextStyle(
    color: Colors.white54,
    fontSize: 14,
  ),
),

const SizedBox(height: 20),

const Divider(
  color: Colors.white24,
  height: 1,
),

const SizedBox(height: 18),
       // ------------------------------------------------
              // START / CAST
              // ------------------------------------------------

              GestureDetector(
                onTap: () async {
                  if (sessionStarted) {
                    await cast();
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

              // ------------------------------------------------
              // SEQUENZA 10 LANCI
              // ------------------------------------------------

              const SizedBox(height: 10),

              SizedBox(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    15,
                    (index) {
                      final hasResult = index < castResults.length;

                      return Container(
                        width: 17,
                        height: 17,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasResult
                              ? (castResults[index] ? Colors.green : Colors.red)
                              : Colors.white12,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // ------------------------------------------------
              // CATTURE
              // ------------------------------------------------

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
              if (counters.length < 4)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      counters.add(
                        LiveCounter(
                          counter: counters.length + 1,
                        ),
                      );
                    });
                  },
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

          const Divider(
            color: Colors.white24,
          ),

              // ------------------------------------------------
              // CONTATORI
              // ------------------------------------------------

              ...counters.map(
                (c) => buildCounterRow(
                  counterNumber: c.counter,
                  quantity: c.quantity,
                  onMinus: () async {
                    if (c.quantity > 0) {
                      await widget.database.removeLastCatchEvent(
                        sessionId: widget.session.id,
                        counter: c.counter,
                      );

                      await loadLiveData();
                      return;
                    }

                    if (c.counter == 1) {
                      return;
                    }

                    final elimina = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              T.deleteCounter,
                            ),
                            content: Text(
                              T.deleteCounterQuestion(
                                c.counter,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(
                                  context,
                                  false,
                                ),
                                child: Text(T.cancel),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(
                                  context,
                                  true,
                                ),
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
                  onPlus: () async {
                    await widget.database.addCatchEvent(
                      sessionId: widget.session.id,
                      counter: c.counter,
                    );

                    await widget.database.printSessionLog(
                      widget.session.id,
                    );

                    await loadCastResults();

                    if (!mounted) return;

                    setState(() {
                      c.quantity++;

                      lastCatchAt = DateTime.now();
                      lastCatchTime = Duration.zero;
                    });
                  },
                ),
              ),

              const SizedBox(height: 8),
              
              // ------------------------------------------------
              // SPAZIO CONTATORI
              // ------------------------------------------------

              const Spacer(),

              // ------------------------------------------------
              // DURATA
              // ------------------------------------------------

              Text(
                "${T.duration}: ${format(sessionTime)}",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              const Divider(
                color: Colors.white24,
                height: 1,
              ),

              const SizedBox(height: 4),

              // ------------------------------------------------
              // FINE SESSIONE
              // ------------------------------------------------

              TextButton(
                onPressed: () async {
                  await endSession();
                },
                child: Text(
                  T.endSession,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // RIGA CONTATORE
  // ------------------------------------------------------------

  Widget buildCounterRow({
    required int counterNumber,
    required int quantity,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 58,
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
