import 'package:flutter/material.dart';

import '../../../../core/t.dart';

class WeatherSection extends StatelessWidget {
  final double? temperatura;
  final TextEditingController temperaturaAcquaController;
  final String? vento;
  final double? pressione;
  final String? faseLunare;

  const WeatherSection({
    super.key,
    required this.temperatura,
    required this.temperaturaAcquaController,
    required this.vento,
    required this.pressione,
    required this.faseLunare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (temperatura != null) ...[
          Row(
            children: [
              const Icon(
                Icons.thermostat,
                color: Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  T.airTemperature,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                "${temperatura!.toStringAsFixed(1)} °C",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        Row(
          children: [
            const Icon(
              Icons.water_drop,
              color: Color(0xFF29B6F6),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                T.waterTemperature,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 72,
              child: TextField(
                controller: temperaturaAcquaController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  suffixText: "°",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),

        if (vento != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.air,
                color: Colors.blueGrey,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  T.wind,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                vento!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],

        if (pressione != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.speed,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  T.pressure,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                "$pressione hPa",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],

        if (faseLunare != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.nightlight_round,
                color: Colors.indigo,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  T.moonPhase(faseLunare!),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}