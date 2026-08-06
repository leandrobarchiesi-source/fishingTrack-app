import 'package:flutter/material.dart';

import '../../../../core/t.dart';
import '../../models/catch_row.dart';
import 'catch_row_widget.dart';

class CatchesSection extends StatelessWidget {
  final List<CatchRow> catches;
  final List<String> availableSpecies;

  final VoidCallback onAddSpecies;
  final void Function(int index) onAddQuantity;
  final void Function(int index) onRemoveQuantity;
  final void Function(int index) onDelete;

  const CatchesSection({
    super.key,
    required this.catches,
    required this.availableSpecies,
    required this.onAddSpecies,
    required this.onAddQuantity,
    required this.onRemoveQuantity,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.phishing,
                  color: Colors.green,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  T.catches,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            if (catches.isNotEmpty) ...[
              const SizedBox(height: 16),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: catches.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return CatchRowWidget(
                    catchRow: catches[index],
                    availableSpecies: availableSpecies,
                    onAdd: () => onAddQuantity(index),
                    onRemove: () => onRemoveQuantity(index),
                    onDelete: () => onDelete(index),
                  );
                },
              ),
            ],

            const SizedBox(height: 12),

            Center(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(T.addSpecies),
                onPressed: onAddSpecies,
              ),
            ),
          ],
        ),
      ),
    );
  }
}