import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/presentation/login_page.dart';
import '../../../core/app_settings.dart';
import '../../../core/t.dart';
import '../../../core/restart_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nomeController = TextEditingController();

  final cognomeController = TextEditingController();

  String lingua = "it";

  bool loading = true;

  @override
  void initState() {
    super.initState();

    caricaProfilo();
  }

  Future<void> caricaProfilo() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          loading = false;
        });

        return;
      }

      final profilo = await Supabase.instance.client
          .from(
            'profiles',
          )
          .select()
          .eq(
            'id',
            user.id,
          )
          .single();

      nomeController.text = profilo['nome'] ?? "";

      cognomeController.text = profilo['cognome'] ?? "";

      lingua = profilo['language'] ?? "it";
    } catch (e) {
      print(
        "Profilo offline: $e",
      );
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

    await Supabase.instance.client
        .from(
      'profiles',
    )
        .update({
      'nome': nomeController.text,
      'cognome': cognomeController.text,
      'language': lingua,
    }).eq(
      'id',
      user.id,
    );

    AppSettings.language = lingua;

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
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          T.profile,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          16,
        ),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: nomeController,
            decoration: InputDecoration(
              labelText: T.firstName,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            controller: cognomeController,
            decoration: InputDecoration(
              labelText: T.lastName,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          DropdownButtonFormField<String>(
            initialValue: lingua,
            decoration: InputDecoration(
              labelText: T.language,
            ),
            items: const [
              DropdownMenuItem(
                value: "it",
                child: Text(
                  "🇮🇹 Italiano",
                ),
              ),
              DropdownMenuItem(
                value: "en",
                child: Text(
                  "🇬🇧 English",
                ),
              ),
              DropdownMenuItem(
                value: "fr",
                child: Text(
                  "🇫🇷 Français",
                ),
              ),
              DropdownMenuItem(
                value: "es",
                child: Text(
                  "🇪🇸 Español",
                ),
              ),
            ],
            onChanged: (v) {
              setState(() {
                lingua = v!;
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await salva();
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      T.onlineOnlyProfile,
                    ),
                  ),
                );
              }
            },
            child: Text(
              T.saveProfile,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton.icon(
            onPressed: cambiaPassword,
            icon: const Icon(
              Icons.lock,
            ),
            label: Text(
              T.changePassword,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: logout,
            icon: const Icon(
              Icons.logout,
            ),
            label: Text(
              T.logout,
            ),
          ),
        ],
      ),
    );
  }
}
