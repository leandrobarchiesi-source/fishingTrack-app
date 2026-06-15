import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../database/app_database.dart';
import '../../../services/weather_service.dart';
import '../../../services/moon_service.dart';
import '../../map/presentation/map_picker_page.dart';
import '../../../services/connectivity_service.dart';
import '../../spots/presentation/spot_selection_page.dart';
import '../../../core/t.dart';

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
  late TextEditingController luogoController;
  late TextEditingController noteController;
  late TextEditingController temperaturaAcquaController;

  final weatherService = WeatherService();

  final moonService = MoonService();

  String tipoPescata = 'Libera';

  DateTime data = DateTime.now();

  TimeOfDay oraInizio = TimeOfDay.now();

  TimeOfDay oraFine = TimeOfDay(
    hour: (TimeOfDay.now().hour + 4) % 24,
    minute: TimeOfDay.now().minute,
  );

  double? latitudine;
  double? longitudine;

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
            s.data ?? data,
          );

      oraInizio = TimeOfDay(
        hour: s.oraInizio.hour,
        minute: s.oraInizio.minute,
      );

      oraFine = TimeOfDay(
        hour: s.oraFine.hour,
        minute: s.oraFine.minute,
      );
    } else {
      faseLunare = moonService.getMoonPhase(
        data,
      );
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

      final posizione = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitudine = posizione.latitude;

      longitudine = posizione.longitude;

      luogoController.text = "Posizione GPS";

      try {
        final places = await placemarkFromCoordinates(
          latitudine!,
          longitudine!,
        );

        if (places.isNotEmpty) {
          luogoController.text = places.first.locality ??
              places.first.subAdministrativeArea ??
              "Posizione trovata";
        }
      } catch (_) {
        // offline: ignora
      }

      try {
        await aggiornaMeteo();
      } catch (_) {
        // offline: ignora
      }

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Errore GPS: $e",
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
      print(
        "Errore geocoding: $e",
      );

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

    await aggiornaMeteo();

    setState(() {});
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
        // spot scelto dalla mappa:
        // usa direttamente id e non creare nulla

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

          await Supabase.instance.client
              .from(
            'spots',
          )
              .insert({
            'id': nuovoId,
            'user_id': Supabase.instance.client.auth.currentUser!.id,
            'nome': luogoController.text.trim(),
            'latitudine': latitudine,
            'longitudine': longitudine,
            'created_at': DateTime.now().toUtc().toIso8601String(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          });

          spotId = nuovoId;
        }
      }

      final acqua = double.tryParse(
        temperaturaAcquaController.text.replaceAll(',', '.'),
      );

      if (widget.session == null) {
        await widget.database.insertSession(
          FishingSessionsCompanion.insert(
            id: uuid.v4(),
            userId: Supabase.instance.client.auth.currentUser!.id,
            spotId: Value(spotId),
            luogo: luogoController.text,
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
            note: Value(
              noteController.text,
            ),
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      } else {
        await widget.database.updateSession(widget.session!.copyWith(
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
          note: Value(
            noteController.text,
          ),
          updatedAt: DateTime.now().toUtc(),
        ));
      }

      if (!mounted) return;

      await widget.database.syncPendingSpots();
      await widget.database.syncPendingSessions();

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
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
            if (temperatura != null)
              Text(
                "🌡 ${temperatura!.toStringAsFixed(1)} °C",
              ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(
                  Icons.water_drop,
                  color: Color(0xFF29B6F6),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    T.waterTemperature,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: temperaturaAcquaController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      suffixText: "°C",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            if (vento != null) Text("💨 $vento"),
            if (pressione != null) Text("📈 $pressione hPa"),
            if (faseLunare != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                  bottom: 6,
                ),
                child: Text(
                  T.moonPhase(faseLunare!),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(
              height: 16,
            ),
            DropdownButtonFormField<String>(
              value: tipoPescata,
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
            ListTile(
              title: Text(
                T.date,
              ),
              subtitle: Text(
                data.toString().split(' ')[0],
              ),
              trailing: const Icon(
                Icons.calendar_month,
              ),
              onTap: selezionaData,
            ),
            ListTile(
              title: Text(
                T.startTime,
              ),
              subtitle: Text(
                oraInizio.format(context),
              ),
              trailing: const Icon(
                Icons.access_time,
              ),
              onTap: () => selezionaOra(true),
            ),
            ListTile(
              title: Text(
                T.endTime,
              ),
              subtitle: Text(
                oraFine.format(context),
              ),
              trailing: const Icon(
                Icons.access_time,
              ),
              onTap: () => selezionaOra(false),
            ),
            TextField(
              controller: noteController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: T.notes,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: loading ? null : saveSession,
              child:
                  Text(widget.session == null ? T.saveSession : T.saveChanges),
            ),
          ],
        ),
      ),
    );
  }
}
