import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart' hide Column;
import '../../auth/presentation/login_page.dart';
import '../../../core/app_settings.dart';
import '../../../core/t.dart';
import '../../../core/restart_widget.dart';
import '../../../database/app_database.dart';
import '../../../services/connectivity_service.dart';


class ProfilePage extends StatefulWidget {
  final AppDatabase database;

  const ProfilePage({
    super.key,
    required this.database,
  });
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nomeController = TextEditingController();

  final cognomeController = TextEditingController();

  String lingua = "it";

  bool loading = true;

  bool online = false;

  @override
  void initState() {
    super.initState();

    caricaProfilo();
  }

Future<void> caricaProfilo() async {
  online = await ConnectivityService.isOnline();
  try {
    // 1. Cerca prima il profilo locale
    final locale = await widget.database.getProfile();

    if (locale != null) {
      nomeController.text = locale.nome ?? "";
      cognomeController.text = locale.cognome ?? "";
      lingua = locale.language;
      AppSettings.language = locale.language;

      if (mounted) {
        setState(() {
          loading = false;
        });
      }

      return;
    }

    // 2. Se non esiste localmente prova Supabase
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      return;
    }

    final profilo = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    // 3. Salva in SQLite
    await widget.database.saveProfile(
      ProfilesCompanion.insert(
        id: user.id,
        nome: Value(profilo['nome']),
        cognome: Value(profilo['cognome']),
        email: Value(user.email),
        language: profilo['language'] ?? 'it',
        avatar: Value(profilo['avatar']),
        createdAt: DateTime.parse(profilo['created_at']),
        updatedAt: DateTime.parse(profilo['updated_at']),
      ),
    );

    // 4. Aggiorna la UI
    nomeController.text = profilo['nome'] ?? "";
    cognomeController.text = profilo['cognome'] ?? "";
    lingua = profilo['language'] ?? "it";
  } catch (e) {
    debugPrint("Errore caricamento profilo: $e");
  }

  if (!mounted) return;

  setState(() {
    loading = false;
  });
}
  Future<void> salva() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return;
    }

// 1. Aggiorna SQLite
final locale = await widget.database.getProfile();

if (locale != null) {
  await widget.database.updateProfile(
    Profile(
      id: locale.id,
      nome: nomeController.text,
      cognome: cognomeController.text,
      email: locale.email,
      language: lingua,
      avatar: locale.avatar,
      synced: true,
      createdAt: locale.createdAt,
      updatedAt: DateTime.now().toUtc(),
    ),
  );
}

// 2. Aggiorna Supabase
await Supabase.instance.client
    .from('profiles')
    .update({
      'nome': nomeController.text,
      'cognome': cognomeController.text,
      'language': lingua,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    })
    .eq('id', user.id);

    await widget.database.updateProfile(
  Profile(
    id: user.id,
    nome: nomeController.text,
    cognome: cognomeController.text,
    email: user.email,
    language: lingua,
    avatar: null, // oppure il valore salvato se lo gestisci
    synced: true,
    createdAt: DateTime.now().toUtc(), // lo sistemiamo meglio dopo
    updatedAt: DateTime.now().toUtc(),
  ),
);

await AppSettings.saveLanguage(lingua);

    RestartWidget.restartApp(
      context,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          T.profileUpdated,
        ),
      ),
    );
  }

  Future<void> cambiaPassword() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            T.newPassword,
          ),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: T.password,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: Text(
                T.cancel,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (controller.text.length < 6) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          T.minimum6Chars,
                        ),
                      ),
                    );

                    return;
                  }

                  await Supabase.instance.client.auth.updateUser(
                    UserAttributes(
                      password: controller.text,
                    ),
                  );

                  if (!mounted) {
                    return;
                  }

                  Navigator.pop(
                    context,
                  );

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        T.passwordUpdated,
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                T.save,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }


@override
Widget build(BuildContext context) {
  if (loading) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4FBFF),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  return Scaffold(
    backgroundColor: const Color(0xFFF4FBFF),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [

          const SizedBox(height: 10),

          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFFD9EEF8),
            child: Icon(
              Icons.person,
              size: 44,
              color: Color(0xFF1565C0),
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              "${nomeController.text} ${cognomeController.text}".trim(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Center(
            child: Text(
              Supabase.instance.client.auth.currentUser?.email ?? "",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 24),

          if (!online)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_off),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      T.profileViewOnlyOffline,
                    ),
                  ),
                ],
              ),
            ),

          if (!online)
            const SizedBox(height: 20),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [

                  TextField(
                    controller: nomeController,
                    readOnly: !online,
                    decoration: InputDecoration(
                      labelText: T.firstName,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: cognomeController,
                    readOnly: !online,
                    decoration: InputDecoration(
                      labelText: T.lastName,
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                  ),

                  const SizedBox(height: 18),

                  DropdownButtonFormField<String>(
                    initialValue: lingua,
                    decoration: InputDecoration(
                      labelText: T.language,
                      prefixIcon: const Icon(Icons.language),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "it",
                        child: Text("🇮🇹 Italiano"),
                      ),
                      DropdownMenuItem(
                        value: "en",
                        child: Text("🇬🇧 English"),
                      ),
                      DropdownMenuItem(
                        value: "fr",
                        child: Text("🇫🇷 Français"),
                      ),
                      DropdownMenuItem(
                        value: "es",
                        child: Text("🇪🇸 Español"),
                      ),
                    ],
                    onChanged: online
                        ? (v) {
                            setState(() {
                              lingua = v!;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
                    if (online)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await salva();

                    if (mounted) {
                      setState(() {});
                    }
                  } catch (e) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(T.onlineOnlyProfile),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: Text(T.saveProfile),
              ),
            ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: online ? cambiaPassword : null,
              icon: const Icon(Icons.lock),
              label: Text(T.changePassword),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}
}