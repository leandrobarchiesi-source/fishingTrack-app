import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GpsService {
  GpsService._();

  static final GpsService instance = GpsService._();

  StreamSubscription<Position>? _subscription;

  Position? bestPosition;

  double? bestAccuracy;

  bool acquiring = false;

  bool get isAcquiring => acquiring;

  Position? get currentPosition => bestPosition;

  double? get currentAccuracy => bestAccuracy;

  Future<void> stopAcquisition() async {
    await _subscription?.cancel();
    _subscription = null;
    acquiring = false;
  }

  Future<Position> acquireBestPosition({
    double targetAccuracy = 5,
    Duration timeout = const Duration(seconds: 20),
    void Function(Position)? onUpdate,
  }) async {
    await stopAcquisition();

    acquiring = true;

    bestPosition = null;
    bestAccuracy = null;

    final completer = Completer<Position>();

    final start = DateTime.now();

    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    ).listen(
      (position) async {
        if (bestPosition == null || position.accuracy < bestAccuracy!) {
          bestPosition = position;
          bestAccuracy = position.accuracy;
        }

        onUpdate?.call(bestPosition!);

        final elapsed = DateTime.now().difference(start);

        if (bestAccuracy! <= targetAccuracy || elapsed >= timeout) {
          await stopAcquisition();

          if (!completer.isCompleted) {
            completer.complete(bestPosition);
          }
        }
      },
      onError: (e) async {
        await stopAcquisition();

        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
    );

    final result = await completer.future;

    if (result == null) {
      throw Exception("Posizione non disponibile");
    }

    return result;
  }
}
