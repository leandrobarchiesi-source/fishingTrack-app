import '../database/app_database.dart';

class SpotRepository {
  final AppDatabase database;

  SpotRepository(this.database);

  Future<List<Spot>> getAllSpots() {
    return database.getAllSpots();
  }

  Future<void> insertSpot(SpotsCompanion spot) {
    return database.insertSpot(spot);
  }

  Future<void> updateSpot({
    required String id,
    required String nome,
    required double latitudine,
    required double longitudine,
  }) {
    return database.updateSpot(
      id: id,
      nome: nome,
      latitudine: latitudine,
      longitudine: longitudine,
    );
  }

  Future<void> deleteSpot(String id) {
    return database.deleteSpot(id);
  }
}