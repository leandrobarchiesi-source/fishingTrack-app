import 'package:geolocator/geolocator.dart';

class GpsFix {
  final Position position;

  final double accuracy;

  final Duration acquisitionTime;

  final bool timeoutReached;

  const GpsFix({
    required this.position,
    required this.accuracy,
    required this.acquisitionTime,
    required this.timeoutReached,
  });
}
