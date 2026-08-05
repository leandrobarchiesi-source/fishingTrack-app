import 'package:flutter/material.dart';

import '../../models/catch_row.dart';
import '../../../../core/t.dart';
import 'species_field.dart';

class CatchRowWidget extends StatelessWidget {
  final CatchRow catchRow;
  final List<String> availableSpecies;

  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const CatchRowWidget({
    super.key,
    required this.catchRow,
    required this.availableSpecies,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: catchRow.species ?? '',
    );

    return Row(
      children: [
        Expanded(
          child: SpeciesField(
            controller: controller,
            availableSpecies: availableSpecies,
            onChanged: (value) {
              catchRow.species = value;
            },
            onSelected: (value) {
              catchRow.species = value;
            },
          ),
        ),

        const SizedBox(width: 8),

        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: onRemove,
        ),

        SizedBox(
          width: 28,
          child: Center(
            child: Text(
              catchRow.quantity.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: onAdd,
        ),

        IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
          tooltip: T.delete,
          onPressed: onDelete,
        ),
      ],
    );
  }
}