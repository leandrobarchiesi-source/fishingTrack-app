import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../database/app_database.dart';
import '../../../core/wheater/weather_service.dart';
import '../../../services/moon_service.dart';
import '../../map/presentation/map_picker_page.dart';
import '../../../services/connectivity_service.dart';
import '../../spots/presentation/spot_selection_page.dart';
import '../../../core/t.dart';
import '../../../core/gps/gps_service.dart';
import '../../../core/session_constants.dart';
import 'widgets/location_section.dart';
import 'widgets/weather_section.dart';
import 'widgets/datetime_section.dart';
import 'widgets/notes_section.dart';
import '../models/catch_row.dart';
import 'widgets/catch_row_widget.dart';
import 'widgets/catches_section.dart';
import 'widgets/fishing_type_section.dart';
import 'widgets/session_buttons.dart';
import 'session_detail_page.dart';

const uuid = Uuid();


class NewSessionPage extends StatefulWidget {
  final AppDatabase database;
  final FishingSession? session;

  const NewSessionPage({
    super.key,
    required this.database,
    this.session,
  });


  @override
  State<NewSessionPage> createState() => _NewSessionPageState();
}

class _NewSessionPageState extends State<NewSessionPage> {

final List<CatchRow> catches = [];

final List<String> availableSpecies = [];

  late TextEditingController luogoController;
  late TextEditingController noteController;
  late TextEditingController temperaturaAcquaController;
  final weatherService = WeatherService();

  final moonService = MoonService();
  final gpsService = GpsService.instance;
  String tipoPescata = 'Libera';

  DateTime data = DateTime.now();

  TimeOfDay oraInizio = TimeOfDay.now();

  TimeOfDay oraFine = TimeOfDay(
    hour: (TimeOfDay.now().hour + 4) % 24,
    minute: TimeOfDay.now().minute,
  );

  double? latitudine;
  double? longitudine;
  double? gpsAccuracy;
  double? gpsSpeed;

  String? gpsSpotName;
double? gpsSpotDistance;
bool gpsSearching = false;

  bool acquiringGps = false;

  double? temperatura;
  double? temperaturaAcqua;
  double? pressione;

  String? vento;
  String? condizioni;
  String? faseLunare;

  bool loading = false;

  String? selectedSpotId;
  String? selectedSpotNome;

String? sessionMode;

  @override
  void initState() {
    super.initState();

    loadAvailableSpecies();

    final s = widget.session;

    luogoController = TextEditingController(
      text: s?.luogo ?? '',
    );

    noteController = TextEditingController(
      text: s?.note ?? '',
    );

    temperaturaAcquaController = TextEditingController(
      text: s?.temperaturaAcqua?.toString() ?? '',
    );
    if (s != null) {

      sessionMode = s.mode;

      tipoPescata = s.tipoPescata;

      data = s.data;

      latitudine = s.latitudine;

      longitudine = s.longitudine;

      temperatura = s.temperatura;

      temperaturaAcqua = s.temperaturaAcqua;

      pressione = s.pressione;

      vento = s.vento;

      condizioni = s.condizioni;

      faseLunare = s.faseLunare ??
          moonService.getMoonPhase(
            s.data ,
          );

      oraInizio = TimeOfDay(
        hour: s.oraInizio.hour,
        minute: s.oraInizio.minute,
      );

      oraFine = TimeOfDay(
        hour: s.oraFine.hour,
        minute: s.oraFine.minute,
      );

      loadSessionCatches();

    } else {
      faseLunare = moonService.getMoonPhase(
        data,
      );
    }
  }

  Future<void> loadAvailableSpecies() async {
  final lista = await widget.database.getUsedSpecies();

  if (!mounted) return;

  setState(() {
    availableSpecies
      ..clear()
      ..addAll(lista);
  });
}

Future<void> loadSessionCatches() async {
  catches.clear();

  final lista = await widget.database.getSessionCatches(
    widget.session!.id,
  );

  for (final c in lista) {
    catches.add(
      CatchRow(
        species: c.species,
        quantity: c.quantity,
      ),
    );
  }

  if (mounted) {
    setState(() {});
  }
}


  Future<void> aggiornaMeteo() async {
    if (latitudine == null || longitudine == null) {
      return;
    }

    try {
      final meteo = await weatherService.getWeather(
        lat: latitudine!,
        lon: longitudine!,
        data: data,
        oraInizio: DateTime(
          data.year,
          data.month,
          data.day,
          oraInizio.hour,
          oraInizio.minute,
        ),
      );

      setState(() {
        temperatura = meteo.temperatura;

        pressione = meteo.pressione;

        vento = meteo.vento;

        condizioni = meteo.condizioni;
      });
    } catch (_) {}
  }

  Future<void> selezionaData() async {
    final nuovaData = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: data,
    );

    if (nuovaData != null) {
      setState(() {
        data = nuovaData;

        faseLunare = moonService.getMoonPhase(
          nuovaData,
        );
      });

if (sessionMode == SessionMode.standard) {
  await aggiornaMeteo();
}
    }
  }

  Future<void> selezionaOra(bool inizio) async {
    final ora = await showTimePicker(
      context: context,
      initialTime: inizio ? oraInizio : oraFine,
    );

    if (ora == null) {
      return;
    }

    setState(() {
      if (inizio) {
        oraInizio = ora;
      } else {
        oraFine = ora;
      }
    });

    if (inizio) {
if (sessionMode == SessionMode.standard) {
  await aggiornaMeteo();
}
    }
  }

  Future<void> usaPosizioneAttuale() async {
    try {

      setState(() {
  gpsSearching = true;
  gpsSpotName = null;
  gpsSpotDistance = null;
});

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(T.gpsDisabled),
          ),
        );

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

final gpsFix = await gpsService.acquireBestPosition(
          targetAccuracy: 10,
        timeout: const Duration(seconds: 20),
        onUpdate: (position) {
          gpsAccuracy = position.accuracy;
          gpsSpeed = position.speed;

          if (mounted) {
            setState(() {});
          }
        },
      );
latitudine = gpsFix.latitude;
longitudine = gpsFix.longitude;

final result = await widget.database.findNearestSpot(
  latitude: latitudine!,
  longitude: longitudine!,
);

if (result.found) {
  gpsSpotName = result.spot!.nome;
  gpsSpotDistance = result.distance;



  const suggestDistance = 20.0;

  if (result.distance! <= suggestDistance) {
    final usaSpot = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
title: Text(T.spotAlreadyExists),
content: Text(
  "${T.foundSpot}\n\n"
  "${result.spot!.nome}\n\n"
  "${T.distance(result.distance!)}\n\n"
  "${T.useExistingSpotQuestion}",
),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
child: Text(T.createNewSpot),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
child: Text(T.useExistingSpot),          ),
        ],
      ),
    );

    if (usaSpot == true) {
      selectedSpotId = result.spot!.id;
      luogoController.text = result.spot!.nome;
    } else {
      selectedSpotId = null;
    }
  } else {
    selectedSpotId = null;
  }
} else {
  selectedSpotId = null;
  gpsSpotName = null;
  gpsSpotDistance = null;
}
if (selectedSpotId == null) {
final online = await ConnectivityService.isOnline();

if (selectedSpotId == null && online) {
  try {
    final places = await placemarkFromCoordinates(
      latitudine!,
      longitudine!,
    );

    if (places.isNotEmpty) {
      luogoController.text =
          places.first.locality ??
          places.first.subAdministrativeArea ??
          T.positionFound;
    }
  } catch (_) {}
}
}
      try {
if (sessionMode == SessionMode.standard) {
  await aggiornaMeteo();
}
      } catch (_) {
        // offline: ignora
      }

setState(() {
  gpsSearching = false;
});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
content: Text(
  T.gpsError(e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> scegliDaMappa() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MapPickerPage(),
      ),
    );

    if (result == null) return;

    // Spot esistente selezionato dalla mappa

    if (result is Map) {
      latitudine = result['latitude'];

      longitudine = result['longitude'];

      selectedSpotId = result['id'];

      selectedSpotNome = result['nome'];

      luogoController.text = selectedSpotNome!;

      if (mounted) {
        setState(() {});
      }

      if (sessionMode == SessionMode.standard) {
        await aggiornaMeteo();
      }

      return;
    }

    // Punto libero

    latitudine = result.latitude;

    longitudine = result.longitude;

    selectedSpotId = null;

    selectedSpotNome = null;

    try {
      final placemarks = await placemarkFromCoordinates(
        latitudine!,
        longitudine!,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        luogoController.text = p.locality?.isNotEmpty == true
            ? p.locality!
            : p.subAdministrativeArea ?? "Spot";
      }
    } catch (e) {

      luogoController.text =
          "Spot ${latitudine!.toStringAsFixed(4)}, ${longitudine!.toStringAsFixed(4)}";
    }

    if (sessionMode == SessionMode.standard) {
      await aggiornaMeteo();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> scegliDaLista() async {
    final spot = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SpotSelectionPage(
          database: widget.database,
        ),
      ),
    );

    if (spot == null) return;

    selectedSpotId = spot['id'];

    selectedSpotNome = spot['nome'];

    luogoController.text = spot['nome'];

    latitudine = spot['latitudine'];

    longitudine = spot['longitudine'];

if (await ConnectivityService.isOnline()) {
  await aggiornaMeteo();
}

if (mounted) {
  setState(() {});
} 
}

Future<void> saveSession() async {
  if (luogoController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(T.enterLocation),
      ),
    );
    return;
  }

if (sessionMode == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(T.select),
    ),
  );
  return;
}

  try {
    setState(() {
      loading = true;
    });

    late final String sessionId;

    final inizio = DateTime(
      data.year,
      data.month,
      data.day,
      oraInizio.hour,
      oraInizio.minute,
    );

    final fine = DateTime(
      data.year,
      data.month,
      data.day,
      oraFine.hour,
      oraFine.minute,
    );

    String? spotId;

    if (selectedSpotId != null) {
      spotId = selectedSpotId;
    } else {
      final spot = await widget.database.getSpotByNome(
        luogoController.text.trim(),
      );

      if (spot != null) {
        spotId = spot.id;
      } else {
        final nuovoId = uuid.v4();

        await widget.database.insertSpot(
          SpotsCompanion.insert(
            id: nuovoId,
            userId: Supabase.instance.client.auth.currentUser!.id,
            nome: luogoController.text.trim(),
            latitudine: Value(latitudine),
            longitudine: Value(longitudine),
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );

        spotId = nuovoId;
      }
    }

    final acqua = double.tryParse(
      temperaturaAcquaController.text.replaceAll(',', '.'),
    );

    if (widget.session == null) {
      sessionId = uuid.v4();

      await widget.database.insertSession(
        FishingSessionsCompanion.insert(
          id: sessionId,
          userId: Supabase.instance.client.auth.currentUser!.id,
          spotId: Value(spotId),
          luogo: luogoController.text.trim(),
          tipoPescata: tipoPescata,
          data: data,
          oraInizio: inizio,
          oraFine: fine,
          latitudine: Value(latitudine),
          longitudine: Value(longitudine),
          temperatura: Value(temperatura),
          temperaturaAcqua: Value(acqua),
          vento: Value(vento),
          pressione: Value(pressione),
          condizioni: Value(condizioni),
          faseLunare: Value(faseLunare),
          mode: Value(sessionMode!),
          status: Value(
          sessionMode == SessionMode.live
            ? SessionStatus.planned
            : SessionStatus.completed,),
          note: Value(noteController.text),
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
    } else {
      sessionId = widget.session!.id;

      await widget.database.updateSession(
        widget.session!.copyWith(
          spotId: Value(spotId),
          luogo: luogoController.text.trim(),
          tipoPescata: tipoPescata,
          data: data,
          oraInizio: inizio,
          oraFine: fine,
          latitudine: Value(latitudine),
          longitudine: Value(longitudine),
          temperatura: Value(temperatura),
          temperaturaAcqua: Value(acqua),
          vento: Value(vento),
          pressione: Value(pressione),
          condizioni: Value(condizioni),
          faseLunare: Value(faseLunare),
          mode: sessionMode,
          status: sessionMode == SessionMode.live
            ? SessionStatus.planned
            : SessionStatus.completed,
          note: Value(noteController.text),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
    }

    // ===== SALVATAGGIO CATTURE =====

    await widget.database.deleteSessionCatches(sessionId);

    final test = await widget.database.getSessionCatches(sessionId);
debugPrint("DOPO DELETE: ${test.length}");

    for (final c in catches) {
      if (c.species == null || c.species!.trim().isEmpty) continue;

      if (c.quantity <= 0) continue;

await widget.database.saveSessionCatch(
  SessionCatchCompanion.insert(
    id: uuid.v4(),
    sessionId: sessionId,
    species: c.species!,
    quantity: Value(c.quantity),
  ),
);

final test2 = await widget.database.getSessionCatches(sessionId);
debugPrint("DOPO INSERT: ${test2.length}");
    }

    if (!mounted) return;

if (sessionMode == SessionMode.standard) {
  Navigator.pop(context, true);
} else {
  final nuovaSessione =
      await widget.database.getSessionById(sessionId);

  if (!mounted || nuovaSessione == null) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => SessionDetailPage(
        database: widget.database,
        session: nuovaSessione,
      ),
    ),
  );
}
} catch (e, st) {
  debugPrint('ERRORE: $e');
  debugPrint('STACK:');
  debugPrint(st.toString());
      if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}

  @override
  void dispose() {
    luogoController.dispose();
    noteController.dispose();
    temperaturaAcquaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.session == null ? T.newSession : T.editSession,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
LocationSection(
  luogoController: luogoController,
  gpsAccuracy: gpsAccuracy,
  gpsSearching: gpsSearching,
  gpsSpotName: gpsSpotName,
  gpsSpotDistance: gpsSpotDistance,
  onCurrentLocation: usaPosizioneAttuale,
  onSelectLocation: () async {
    final online = await ConnectivityService.isOnline();

    if (online) {
      await scegliDaMappa();
    } else {
      await scegliDaLista();
    }
  },
),
          
const SizedBox(height: 16),
FishingTypeSection(
  tipoPescata: tipoPescata,
  onChanged: (value) {
    setState(() {
      tipoPescata = value;
    });
  },
),

const SizedBox(height: 16),
            const SizedBox(height: 16),

DropdownButtonFormField<String>(
  initialValue: sessionMode,
  decoration: const InputDecoration(
    labelText: "Modalità sessione",
  ),
  items: const [
    DropdownMenuItem(
      value: SessionMode.standard,
      child: Text("Standard"),
    ),
    DropdownMenuItem(
      value: SessionMode.live,
      child: Text("Live"),
    ),
  ],
  
onChanged: (value) async {
  setState(() {
    sessionMode = value!;
  });

  

  if (sessionMode == SessionMode.standard &&
      latitudine != null &&
      longitudine != null) {
if (sessionMode == SessionMode.standard) {
  await aggiornaMeteo();
}
  }
  
},

),

const SizedBox(height: 16),

            if (sessionMode == SessionMode.standard) ...[

              WeatherSection(
  temperatura: temperatura,
  temperaturaAcquaController: temperaturaAcquaController,
  vento: vento,
  pressione: pressione,
  faseLunare: faseLunare,
),

            ],


const SizedBox(height: 16),

if (sessionMode == SessionMode.standard) ...[
  DateTimeSection(
    data: data,
    oraInizio: oraInizio,
    oraFine: oraFine,
    onSelectDate: selezionaData,
    onSelectStart: () => selezionaOra(true),
    onSelectEnd: () => selezionaOra(false),
  ),
],
 const SizedBox(height: 10),

 if (sessionMode == SessionMode.standard) ...[
 
NotesSection(
  controller: noteController,
),
 ],

const SizedBox(height: 20),

if (sessionMode == SessionMode.standard) ...[
  CatchesSection(
    catches: catches,
    availableSpecies: availableSpecies,

    onAddSpecies: () {
      setState(() {
        catches.add(CatchRow());
      });
    },

    onAddQuantity: (index) {
      setState(() {
        catches[index].quantity++;
      });
    },

    onRemoveQuantity: (index) {
      setState(() {
        if (catches[index].quantity > 0) {
          catches[index].quantity--;
        }
      });
    },

    onDelete: (index) {
      setState(() {
        catches.removeAt(index);
      });
    },
  ),
],
const SizedBox(height: 10),

SessionButtons(
  loading: loading,
  isNewSession: widget.session == null,
  onSave: saveSession,
),
    ],
        ),
      ),
    );
  }
}
