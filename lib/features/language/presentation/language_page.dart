import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({
    super.key,
  });

  Future<void> salvaLingua(
    BuildContext context,
    String lingua,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    await Supabase.instance.client
        .from(
      'profiles',
    )
        .update({
      'language': lingua,
    }).eq(
      'id',
      user.id,
    );

    if (!context.mounted) return;

    Navigator.pop(
      context,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Seleziona lingua",
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Text(
              "🇮🇹",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            title: const Text(
              "Italiano",
            ),
            onTap: () => salvaLingua(
              context,
              'it',
            ),
          ),
          ListTile(
            leading: const Text(
              "🇬🇧",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            title: const Text(
              "English",
            ),
            onTap: () => salvaLingua(
              context,
              'en',
            ),
          ),
          ListTile(
            leading: const Text(
              "🇫🇷",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            title: const Text(
              "Français",
            ),
            onTap: () => salvaLingua(
              context,
              'fr',
            ),
          ),
          ListTile(
            leading: const Text(
              "🇪🇸",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            title: const Text(
              "Español",
            ),
            onTap: () => salvaLingua(
              context,
              'es',
            ),
          ),
        ],
      ),
    );
  }
}
