import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/app_settings.dart';

class ProfileService {
  Future<void> creaProfiloSeManca() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return;
    }

    final result = await Supabase.instance.client
        .from(
          'profiles',
        )
        .select()
        .eq(
          'id',
          user.id,
        )
        .maybeSingle();

    if (result != null) {
      return;
    }

    await Supabase.instance.client
        .from(
      'profiles',
    )
        .insert({
      'id': user.id,
      'nome': '',
      'cognome': '',
      'language': 'it',
    });
  }

  Future<void> caricaLingua() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      AppSettings.language = 'it';
      return;
    }

    final profilo = await Supabase.instance.client
        .from('profiles')
        .select('language')
        .eq('id', user.id)
        .maybeSingle();

    AppSettings.language = profilo?['language'] ?? 'it';

    print(
      "LINGUA UTENTE: ${AppSettings.language}",
    );
  }
}
