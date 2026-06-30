import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GpsService {
  Future<Position> acquireBestPosition({
    double targetAccuracy = 5,
    Duration timeout = const Duration(seconds: 20),
    void Function(Position)? onUpdate,
  }) async {
    Position? bestPosition;

    final start = DateTime.now();

    await for (final position in Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    )) {
      if (bestPosition == null || position.accuracy < bestPosition.accuracy) {
        bestPosition = position;
      }

      onUpdate?.call(bestPosition);

      final elapsed = DateTime.now().difference(start);

      if (bestPosition.accuracy <= targetAccuracy || elapsed >= timeout) {
        break;
      }
    }

    if (bestPosition == null) {
      throw Exception("Posizione non disponibile");
    }

    return bestPosition;
  }
}
