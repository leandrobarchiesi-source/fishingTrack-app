import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../database/app_database.dart';
import '../../../database/session_event_type.dart';

class SessionLogPage extends StatelessWidget {
  final AppDatabase database;
  final FishingSession session;

  const SessionLogPage({
    super.key,
    required this.database,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session Log"),
      ),
      body: FutureBuilder<List<SessionLogData>>(
        future: database.getSessionEvents(session.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final events = snapshot.data!;

          if (events.isEmpty) {
            return const Center(
              child: Text("Nessun evento registrato"),
            );
          }

return ListView.separated(
  physics: const AlwaysScrollableScrollPhysics(),
  padding: const EdgeInsets.all(16),
  itemCount: events.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 20),
            itemBuilder: (context, index) {
              final event = events[index];

              return ListTile(
                leading: Icon(
                  _icon(event.eventType),
                  size: 30,
                ),
                title: Text(
                  _description(event),
                ),
                subtitle: Text(
                  DateFormat(
                    "HH:mm:ss",
                  ).format(event.timestamp),
                ),
              );
            },
          );
        },
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

  String _description(SessionLogData event) {
    switch (event.eventType) {
      case SessionEventType.start:
        return "Session started";

      case SessionEventType.cast:
        return "Cast";

      case SessionEventType.catchFish:
        return "Catch - Counter ${event.counter}";

      case SessionEventType.end:
        return "Session ended";

      default:
        return event.eventType;
    }
  }
}