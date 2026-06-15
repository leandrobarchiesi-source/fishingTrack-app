import 'package:flutter/material.dart';
import '../../../database/app_database.dart';

class SpotSelectionPage extends StatefulWidget {
  final AppDatabase database;

  const SpotSelectionPage({
    super.key,
    required this.database,
  });

  @override
  State<SpotSelectionPage> createState() => _SpotSelectionPageState();
}

class _SpotSelectionPageState extends State<SpotSelectionPage> {
  List<Spot> spots = [];

  @override
  void initState() {
    super.initState();

    carica();
  }

  Future<void> carica() async {
    final data = await widget.database.getAllSpots();

    setState(() {
      spots = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Seleziona Spot",
        ),
      ),
      body: ListView.builder(
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
                "${s.latitudine?.toStringAsFixed(4)}"
                ", "
                "${s.longitudine?.toStringAsFixed(4)}",
              ),
              onTap: () {
                Navigator.pop(
                  context,
                  {
                    'id': s.id,
                    'nome': s.nome,
                    'latitudine': s.latitudine,
                    'longitudine': s.longitudine,
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
