import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

import '../../../database/app_database.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({
    super.key,
  });

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final mapController = MapController();

  final searchController = TextEditingController();

  final database = AppDatabase();

  List<Spot> spots = [];

  LatLng posizione = const LatLng(
    40.8518,
    14.2681,
  );

  @override
  void initState() {
    super.initState();

    caricaSessioni();
  }

  Future<void> caricaSessioni() async {
    final dati = await database.getAllSpots();

    print("SPOTS TROVATI:");
    print(dati.length);

    for (final s in dati) {
      print("${s.nome} - ${s.latitudine}, ${s.longitudine}");
    }

    setState(() {
      spots = dati
          .where(
            (e) => e.latitudine != null && e.longitudine != null,
          )
          .toList();
    });
  }

  Future<void> cercaLuogo() async {
    if (searchController.text.trim().isEmpty) {
      return;
    }

    try {
      final places = await locationFromAddress(
        searchController.text,
      );

      if (places.isEmpty) {
        return;
      }

      final p = places.first;

      final nuovaPosizione = LatLng(
        p.latitude,
        p.longitude,
      );

      setState(() {
        posizione = nuovaPosizione;
      });

      mapController.move(
        nuovaPosizione,
        14,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scegli luogo",
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(
            context,
            posizione,
          );
        },
        icon: const Icon(
          Icons.check,
        ),
        label: const Text(
          "Conferma",
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              10,
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Cerca luogo...",
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.send,
                  ),
                  onPressed: cercaLuogo,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: posizione,
                initialZoom: 12,
                onTap: (
                  tapPosition,
                  point,
                ) {
                  setState(() {
                    posizione = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.fishing_app',
                  errorTileCallback: (tile, error, stack) {
                    print("Tile offline");
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: posizione,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.location_pin,
                        size: 45,
                        color: Colors.red,
                      ),
                    ),
                    ...spots.map(
                      (s) {
                        return Marker(
                          point: LatLng(
                            s.latitudine!,
                            s.longitudine!,
                          ),
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                useSafeArea: true,
                                isScrollControlled: true,
                                builder: (_) {
                                  return SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 25,
                                        left: 16,
                                        right: 16,
                                        top: 16,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(
                                            context,
                                          );

                                          Navigator.pop(
                                            context,
                                            {
                                              'id': s.id,
                                              'nome': s.nome,
                                              'latitude': s.latitudine,
                                              'longitude': s.longitudine,
                                            },
                                          );
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                              20,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  s.nome,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.touch_app,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "Tocca per selezionare",
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.phishing,
                              color: Colors.orange,
                              size: 34,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
