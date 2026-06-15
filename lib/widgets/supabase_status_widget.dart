import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';

class SupabaseStatusWidget extends StatefulWidget {
  const SupabaseStatusWidget({
    super.key,
  });

  @override
  State<SupabaseStatusWidget> createState() => _SupabaseStatusWidgetState();
}

class _SupabaseStatusWidgetState extends State<SupabaseStatusWidget> {
  bool online = false;

  Timer? timer;

  final database = AppDatabase();

  @override
  void initState() {
    super.initState();

    verificaConnessione();

    timer = Timer.periodic(
      const Duration(
        seconds: 10,
      ),
      (_) => verificaConnessione(),
    );
  }

  Future<void> verificaConnessione() async {
    bool nuovoStato = false;

    try {
      await Supabase.instance.client
          .from(
            'fishing_sessions',
          )
          .select(
            'id',
          )
          .limit(
            1,
          );

      nuovoStato = true;
    } catch (_) {}

    if (!mounted) {
      return;
    }

    if (!online && nuovoStato) {
      await database.syncPendingSessions();
    }

    setState(() {
      online = nuovoStato;
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: online ? "Supabase connesso" : "Offline - solo locale",
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Icon(
          Icons.cloud_circle,
          color: online ? Colors.green : Colors.red,
          size: 28,
        ),
      ),
    );
  }
}
