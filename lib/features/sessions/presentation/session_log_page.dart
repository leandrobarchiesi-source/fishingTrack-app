import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../database/app_database.dart';
import '../../../database/session_event_type.dart';
import '../../../core/t.dart';

class SessionLogPage extends StatelessWidget {
  final AppDatabase database;
  final FishingSession session;

  const SessionLogPage({
    super.key,
    required this.database,
    required this.session,
  });

  Future<_SessionLogData> _loadData() async {
    final events = await database.getSessionEvents(
      session.id,
    );

    final counters = await database.getCatchCounters(
      session.id,
    );

    final counterNames = await database.getSessionCounterNames(
      session.id,
    );

    final totalFish = counters.values.fold<int>(
      0,
      (sum, value) => sum + value,
    );

    return _SessionLogData(
      events: events,
      totalFish: totalFish,
      counterCount: counters.length,
      counterNames: counterNames,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(T.sessionLog),
      ),
      body: FutureBuilder<_SessionLogData>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          final events = data.events;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(data),
              const SizedBox(height: 20),
              if (events.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      T.noEventsRecorded,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ...events.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final event = entry.value;

                    return Column(
                      children: [
                        _buildEvent(
                          event,
                          data.counterNames,
                        ),
                        if (index < events.length - 1)
                          const Divider(
                            height: 20,
                          ),
                      ],
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(_SessionLogData data) {
    final duration = session.oraFine.difference(
      session.oraInizio,
    );

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              T.sessionLog.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    session.luogo,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "${DateFormat('HH:mm').format(session.oraInizio)}"
                  " → "
                  "${DateFormat('HH:mm').format(session.oraFine)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "${T.duration}: ${_formatDuration(duration)}",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.phishing,
                    T.catches,
                    data.totalFish.toString(),
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    Icons.filter_1_outlined,
                    T.counters,
                    data.counterCount.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.thermostat,
                    T.temperature,
                    session.temperatura == null
                        ? "--"
                        : "${session.temperatura!.toStringAsFixed(1)}°C",
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    Icons.water_drop_outlined,
                    T.waterTemperature,
                    session.temperaturaAcqua == null
                        ? "--"
                        : "${session.temperaturaAcqua!.toStringAsFixed(1)}°C",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEvent(
    SessionLogData event,
    Map<int, String> counterNames,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        _icon(event.eventType),
        size: 30,
      ),
      title: Text(
        _description(
          event,
          counterNames,
        ),
      ),
      subtitle: Text(
        DateFormat(
          "HH:mm:ss",
        ).format(event.timestamp),
      ),
    );
  }

  IconData _icon(String type) {
    switch (type) {
      case SessionEventType.start:
        return Icons.play_arrow;

      case SessionEventType.cast:
        return Icons.outbound;

      case SessionEventType.catchFish:
        return Icons.phishing;

      case SessionEventType.end:
        return Icons.stop_circle;

      default:
        return Icons.circle;
    }
  }

  String _description(
    SessionLogData event,
    Map<int, String> counterNames,
  ) {
    switch (event.eventType) {
      case SessionEventType.start:
        return T.sessionStarted;

      case SessionEventType.cast:
        return T.cast;

      case SessionEventType.catchFish:
        final counter = event.counter;

        if (counter != null) {
          final name = counterNames[counter];

          if (name != null && name.isNotEmpty) {
            return name;
          }
        }

        return T.catchCounter(
          counter ?? 0,
        );

      case SessionEventType.end:
        return T.sessionEnded;

      default:
        return event.eventType;
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    }

    return "${minutes}m";
  }
}

class _SessionLogData {
  final List<SessionLogData> events;
  final int totalFish;
  final int counterCount;
  final Map<int, String> counterNames;

  const _SessionLogData({
    required this.events,
    required this.totalFish,
    required this.counterCount,
    required this.counterNames,
  });
}
