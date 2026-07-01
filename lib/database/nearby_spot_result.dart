import 'app_database.dart';

class NearbySpotResult {
  final Spot? spot;

  final double? distance;

  const NearbySpotResult({
    this.spot,
    this.distance,
  });

  bool get found => spot != null;
}