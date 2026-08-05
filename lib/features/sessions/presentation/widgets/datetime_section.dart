import 'package:flutter/material.dart';

class DateTimeSection extends StatelessWidget {
  final DateTime data;
  final TimeOfDay oraInizio;
  final TimeOfDay oraFine;

  final VoidCallback onSelectDate;
  final VoidCallback onSelectStart;
  final VoidCallback onSelectEnd;

  const DateTimeSection({
    super.key,
    required this.data,
    required this.oraInizio,
    required this.oraFine,
    required this.onSelectDate,
    required this.onSelectStart,
    required this.onSelectEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onSelectDate,
            borderRadius: BorderRadius.circular(12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.deepPurple,
                      size: 26,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${data.day.toString().padLeft(2, '0')}/"
                      "${data.month.toString().padLeft(2, '0')}/"
                      "${data.year.toString().substring(2)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: InkWell(
            onTap: onSelectStart,
            borderRadius: BorderRadius.circular(12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: Colors.deepPurple,
                      size: 26,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      oraInizio.format(context),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: InkWell(
            onTap: onSelectEnd,
            borderRadius: BorderRadius.circular(12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: Colors.deepPurple,
                      size: 26,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      oraFine.format(context),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}