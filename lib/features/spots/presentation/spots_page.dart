import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';

import '../../../database/app_database.dart';
import '../../../services/connectivity_service.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/t.dart';
import '../../../repository/spot_repository.dart';

class SpotsPage extends StatefulWidget {
  const SpotsPage({super.key});

  @override
  State<SpotsPage> createState() => _SpotsPageState();
}

class _SpotsPageState extends State<SpotsPage> {
final database = AppDatabase();
late final SpotRepository repository = SpotRepository(database);

  List<Spot> spots = [];

  Spot? selectedSpot;

  bool modificaSpot = false;

  LatLng? posizioneModificata;

  final modificaController = TextEditingController();

  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    carica();
  }

  Future<void> carica() async {
final data = await repository.getAllSpots();
    if (!mounted) return;

    setState(() {
      spots = data;
    });
  }

  Future<void> salvaModificaSpot() async {
    if (selectedSpot == null || posizioneModificata == null) {
      return;
    }

    await repository.updateSpot(
  id: selectedSpot!.id,
  nome: modificaController.text,
  latitudine: posizioneModificata!.latitude,
  longitudine: posizioneModificata!.longitude,
);
// SYNC IMMEDIATA

    await database.syncPendingSpots();

    await database.syncSpotsFromSupabase();

    await carica();

    final nuovo = spots.firstWhere(
      (s) => s.id == selectedSpot!.id,
    );

    setState(() {
      selectedSpot = nuovo;

      modificaSpot = false;
    });
  }

  Future<void> eliminaSpot() async {
    if (selectedSpot == null) return;

    final sessioni = await database.getAllSessions();

    final associate = sessioni.where(
      (s) => s.spotId == selectedSpot!.id,
    );

    if (associate.isNotEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(T.spotLinkedSessions(
            associate.length,
          )),
        ),
      );

      return;
    }

    await repository.deleteSpot(
      selectedSpot!.id,
    );

    await carica();

    if (!mounted) return;

    setState(() {
      selectedSpot = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(T.spotDeleted),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        T.spots,
      )),
      body: FutureBuilder<bool>(
        future: ConnectivityService.isOnline(),
        builder: (context, snapshot) {
          final online = snapshot.data ?? false;

          // OFFLINE
          if (!online) {
            return ListView.builder(
              itemCount: spots.length,
              itemBuilder: (_, index) {
                final s = spots[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.place,
                    ),
                    title: Text(
                      s.nome,
                    ),
                    subtitle: Text(
                      "${s.latitudine?.toStringAsFixed(5)}, "
                      "${s.longitudine?.toStringAsFixed(5)}",
                    ),
                  ),
                );
              },
            );
          }

          // ONLINE

          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: const MapOptions(
                  initialCenter: LatLng(
                    41.8719,
                    12.5674,
                  ),
                  initialZoom: 5.8,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.fishing_app',
                  ),
                  MarkerLayer(
                    markers: spots.map(
                      (s) {
                        return Marker(
                          point: LatLng(
                            s.latitudine!,
                            s.longitudine!,
                          ),
                          width: 60,
                          height: 60,
                          child: GestureDetector(
                            onTap: () {
                              mapController.move(
                                LatLng(
                                  s.latitudine!,
                                  s.longitudine!,
                                ),
                                14,
                              );

                              setState(
                                () {
                                  selectedSpot = s;

                                  modificaSpot = false;

                                  posizioneModificata = LatLng(
                                    s.latitudine!,
                                    s.longitudine!,
                                  );

                                  modificaController.text = s.nome;
                                },
                              );
                            },
                            child: const Icon(
                              Icons.location_pin,
                              size: 50,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  if (modificaSpot && posizioneModificata != null)
                    DragMarkers(
                      markers: [
                        DragMarker(
                          point: posizioneModificata!,
                          size: const Size(
                            80,
                            80,
                          ),
                          builder: (
                            context,
                            point,
                            dragging,
                          ) {
                            return const Icon(
                              Icons.edit_location,
                              size: 60,
                              color: Colors.orange,
                            );
                          },
                          onDragUpdate: (
                            details,
                            point,
                          ) {
                            setState(() {
                              posizioneModificata = point;
                            });
                          },
                        ),
                      ],
                    ),
                ],
              ),
              if (selectedSpot != null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 250,
                      ),
                      padding: const EdgeInsets.all(
                        20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: modificaSpot
                                      ? TextField(
                                          controller: modificaController,
                                        )
                                      : Text(
                                          selectedSpot!.nome,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        selectedSpot = null;
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Lat: ${posizioneModificata?.latitude.toStringAsFixed(5)}",
                            ),
                            Text(
                              "Lon: ${posizioneModificata?.longitude.toStringAsFixed(5)}",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!modificaSpot) {
                                        setState(
                                          () {
                                            modificaSpot = true;
                                          },
                                        );

                                        return;
                                      }

                                      await salvaModificaSpot();
                                    },
                                    child: Text(modificaSpot
                                        ? "💾 ${T.save}"
                                        : "✏ ${T.edit}"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      final conferma = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(
                                            T.deleteSpot,
                                          ),
                                          content: Text(
                                            T.deleteSpotQuestion,
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

                                      if (conferma == true) {
                                        await eliminaSpot();
                                      }
                                    },
                                    child: Text(
                                      T.delete,
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
