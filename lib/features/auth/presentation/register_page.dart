import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nomeController = TextEditingController();

  final cognomeController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  String lingua = "it";

  bool loading = false;

  Future<void> registrati() async {
    try {
      setState(() {
        loading = true;
      });

      final result = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final user = result.user;

      if (user == null) {
        return;
      }

      await Supabase.instance.client
          .from(
        'profiles',
      )
          .insert({
        'id': user.id,
        'nome': nomeController.text,
        'cognome': cognomeController.text,
        'language': lingua,
      });

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
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

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registration',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: "First Name",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: cognomeController,
              decoration: const InputDecoration(
                labelText: "Last Name",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              initialValue: lingua,
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
              onPressed: loading ? null : registrati,
              child: const Text(
                "Register",
              ),
            )
          ],
        ),
      ),
    );
  }
}
