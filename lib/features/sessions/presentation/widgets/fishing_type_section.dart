import 'package:flutter/material.dart';

import '../../../../core/t.dart';

class FishingTypeSection extends StatelessWidget {
  final String tipoPescata;
  final ValueChanged<String> onChanged;

  const FishingTypeSection({
    super.key,
    required this.tipoPescata,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: tipoPescata,
      decoration: InputDecoration(
        labelText: T.fishingType,
      ),
      items: [
        DropdownMenuItem(
          value: 'Gara',
          child: Text(T.sessionType('Gara')),
        ),
        DropdownMenuItem(
          value: 'Test-Match',
          child: Text(T.sessionType('Test-Match')),
        ),
        DropdownMenuItem(
          value: 'Pool',
          child: Text(T.sessionType('Pool')),
        ),
        DropdownMenuItem(
          value: 'Prova',
          child: Text(T.sessionType('Prova')),
        ),
        DropdownMenuItem(
          value: 'Libera',
          child: Text(T.sessionType('Libera')),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}