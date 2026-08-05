import 'package:flutter/material.dart';

import '../../../../core/t.dart';

class LocationSection extends StatelessWidget {
  final TextEditingController luogoController;

  final double? gpsAccuracy;
  final bool gpsSearching;
  final String? gpsSpotName;
  final double? gpsSpotDistance;

  final VoidCallback onCurrentLocation;
  final Future<void> Function() onSelectLocation;

  const LocationSection({
    super.key,
    required this.luogoController,
    required this.gpsAccuracy,
    required this.gpsSearching,
    required this.gpsSpotName,
    required this.gpsSpotDistance,
    required this.onCurrentLocation,
    required this.onSelectLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: luogoController,
          decoration: InputDecoration(
            labelText: T.location,
          ),
        ),

        if (gpsAccuracy != null || gpsSearching)
          Card(
            margin: const EdgeInsets.only(top: 16, bottom: 12),
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
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
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

        const SizedBox(height: 16),

        ElevatedButton.icon(
          onPressed: onCurrentLocation,
          icon: const Icon(Icons.location_on),
          label: Text(T.useCurrentLocation),
        ),

        const SizedBox(height: 10),

        ElevatedButton.icon(
          onPressed: () => onSelectLocation(),
          icon: const Icon(Icons.map),
          label: Text(T.selectFromMap),
        ),
      ],
    );
  }
}