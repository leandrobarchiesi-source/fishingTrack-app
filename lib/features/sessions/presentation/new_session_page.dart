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

const uuid = Uuid();

class CatchRow {
  String? species;
  int quantity;

  CatchRow({
    this.species,
    this.quantity = 0,
  });
}

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

      await aggiornaMeteo();
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
      await aggiornaMeteo();
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
        await aggiornaMeteo();
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

      await aggiornaMeteo();

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

    await aggiornaMeteo();

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

Widget buildSpeciesField(CatchRow catchRow) {
  return SizedBox(
    height: 46,
    child: Autocomplete<String>(
      initialValue: TextEditingValue(
        text: catchRow.species ?? '',
      ),
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return availableSpecies;
        }

        return availableSpecies.where(
          (s) => s.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              ),
        );
      },
      onSelected: (value) {
        catchRow.species = value;
      },
      fieldViewBuilder: (
        context,
        controller,
        focusNode,
        onFieldSubmitted,
      ) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: T.species,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) {
            catchRow.species = value;
          },
        );
      },
    ),
  );
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
          note: Value(noteController.text),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
    }

    // ===== SALVATAGGIO CATTURE =====

    await widget.database.deleteSessionCatches(sessionId);

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
    }

    if (!mounted) return;

    Navigator.pop(context, true);
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
            TextField(
              controller: luogoController,
              decoration: InputDecoration(
                labelText: T.location,
              ),
            ),
if (gpsAccuracy != null || gpsSearching)
  Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📡 GPS",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

if (gpsSearching)
  Row(
    children: [
      const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      const SizedBox(width: 10),
      Text(T.searchingPosition),
    ],
  ),
  
if (gpsAccuracy != null) ...[
  const SizedBox(height: 8),
  Text(
    T.accuracy(gpsAccuracy!),
  ),
],
          if (gpsSpotName != null) ...[
            const SizedBox(height: 8),
            Text(
              "📍 Spot: $gpsSpotName",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],

if (gpsSpotDistance != null)
  Text(
    T.distance(gpsSpotDistance!),
  ),
          if (!gpsSearching &&
              gpsAccuracy != null &&
              gpsSpotName == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "⚠ ${T.noNearbySpot}",
              ),
            ),
          ],
        ),
    ),
  ),
              const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed: usaPosizioneAttuale,
              icon: const Icon(
                Icons.location_on,
              ),
              label: Text(
                T.useCurrentLocation,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<bool>(
              future: ConnectivityService.isOnline(),
              builder: (context, snapshot) {
                final online = snapshot.data ?? false;

                return ElevatedButton.icon(
                  onPressed: online ? scegliDaMappa : scegliDaLista,
                  icon: Icon(
                    online ? Icons.map : Icons.list,
                  ),
                  label: Text(
                    online ? T.selectFromMap : T.selectFromList,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
if (temperatura != null) ...[
  Row(
    children: [
      const Icon(
        Icons.thermostat,
        color: Colors.redAccent,
        size: 20,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          T.airTemperature,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      Text(
        "${temperatura!.toStringAsFixed(1)} °C",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
  const SizedBox(height: 12),
],

Row(
  children: [
    const Icon(
      Icons.water_drop,
      color: Color(0xFF29B6F6),
      size: 20,
    ),
    const SizedBox(width: 10),
    Expanded(
      child: Text(
        T.waterTemperature,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    ),
    SizedBox(
      width: 72,
      child: TextField(
        controller: temperaturaAcquaController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
    textAlign: TextAlign.center,
    textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 6,
          ),
          suffixText: "°",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
  ],
),

if (vento != null) ...[
  const SizedBox(height: 12),
  Row(
    children: [
      const Icon(
        Icons.air,
        color: Colors.blueGrey,
        size: 20,
      ),
      const SizedBox(width: 10),
       Expanded(
        child: Text(
          T.wind,
          style: TextStyle(fontSize: 16),
        ),
      ),
      Text(
        vento!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
],

if (pressione != null) ...[
  const SizedBox(height: 12),
  Row(
    children: [
      const Icon(
        Icons.speed,
        color: Colors.orange,
        size: 20,
      ),
      const SizedBox(width: 10),
       Expanded(
        child: Text(
          T.pressure,
          style: TextStyle(fontSize: 16),
        ),
      ),
      Text(
        "$pressione hPa",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
],

if (faseLunare != null) ...[
  const SizedBox(height: 12),
  Row(
    children: [
      const Icon(
        Icons.nightlight_round,
        color: Colors.indigo,
        size: 20,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          T.moonPhase(faseLunare!),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    ],
  ),
],

const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: tipoPescata,
              items: [
                DropdownMenuItem(
                  value: 'Gara',
                  child: Text(
                    T.sessionType('Gara'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Test-Match',
                  child: Text(
                    T.sessionType('Test-Match'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Pool',
                  child: Text(
                    T.sessionType('Pool'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Prova',
                  child: Text(
                    T.sessionType('Prova'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Libera',
                  child: Text(
                    T.sessionType('Libera'),
                  ),
                ),
              ],
              onChanged: (v) {
                setState(() {
                  tipoPescata = v!;
                });
              },
              decoration: InputDecoration(
                labelText: T.fishingType,
              ),
            ),
            const SizedBox(height: 16),
Row(
  children: [
    Expanded(
      child: InkWell(
        onTap: selezionaData,
        borderRadius: BorderRadius.circular(12),
        child: 
Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
              child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
children: [
  const Icon(
    Icons.calendar_month,
    color: Colors.deepPurple,
    size: 26,
  ),

  const SizedBox(height: 10),

  Text(
    "${data.day.toString().padLeft(2, '0')}/"
    "${data.month.toString().padLeft(2, '0')}/"
    "${data.year.toString().substring(2)}",
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
  ),
],
            ),
          ),
        ),
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: InkWell(
        onTap: () => selezionaOra(true),
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
children: [
  const Icon(
    Icons.schedule,
    color: Colors.deepPurple,
    size: 26,
  ),

  const SizedBox(height: 10),

  Text(
    oraInizio.format(context),
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
  ),
],
            ),
          ),
        ),
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: InkWell(
        onTap: () => selezionaOra(false),
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
children: [
  const Icon(
    Icons.schedule,
    color: Colors.deepPurple,
    size: 26,
  ),

  const SizedBox(height: 10),

  Text(
    oraFine.format(context),
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
  ),
],
            ),
          ),
        ),
      ),
    ),
  ],
),
 const SizedBox(height: 10),
 
TextField(
  controller: noteController,
  minLines: 3,
  maxLines: 3,
  decoration: InputDecoration(
    labelText: T.notes,
    alignLabelWithHint: true,
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.deepPurple,
        width: 2,
      ),
    ),
  ),
),

const SizedBox(height: 20),

Card(
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.phishing,
              color: Colors.green,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              T.catches,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        if (catches.isNotEmpty) ...[
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: catches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final catchRow = catches[index];

return Row(
  children: [
    Expanded(
      child: buildSpeciesField(catchRow),
    ),

    const SizedBox(width: 8),

    IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Icons.remove_circle_outline,
        size: 22,
      ),
      onPressed: () {
        setState(() {
          if (catchRow.quantity > 0) {
            catchRow.quantity--;
          }
        });
      },
    ),

    SizedBox(
      width: 24,
      child: Center(
        child: Text(
          catchRow.quantity.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    ),

    IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Icons.add_circle_outline,
        size: 22,
      ),
      onPressed: () {
        setState(() {
          catchRow.quantity++;
        });
      },
    ),

    const SizedBox(width: 4),

    IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Icons.close,
        color: Colors.red,
        size: 20,
      ),
      tooltip: T.delete,
      onPressed: () {
        setState(() {
          catches.removeAt(index);
        });
      },
    ),
  ],
);
   },
          ),
        ],

        const SizedBox(height: 12),

        Center(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(T.addSpecies),
            onPressed: () {
              setState(() {
                catches.add(CatchRow());
              });
            },
          ),
        ),
      ],
    ),
  ),
),
const SizedBox(height: 10),

SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
    onPressed: loading ? null : saveSession,
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
    child: Text(
      widget.session == null ? T.saveSession : T.saveChanges,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),          ],
        ),
      ),
    );
  }
}
