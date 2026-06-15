import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/auth_service.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = AuthService();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> login() async {
    final email = emailController.text.trim();

    final password = passwordController.text.trim();

    if (!email.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid email',
          ),
        ),
      );

      return;
    }

    try {
      setState(() {
        loading = true;
      });

      await auth.signIn(
        email: email,
        password: password,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

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
  void dispose() {
    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: loading ? null : login,
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Login',
                    ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterPage(),
                  ),
                );
              },
              child: const Text(
                "Don't have an account? Register",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
