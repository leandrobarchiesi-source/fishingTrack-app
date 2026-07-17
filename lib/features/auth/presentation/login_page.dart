import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../core/auth/auth_service.dart';
import 'register_page.dart';
import '../../../services/connectivity_service.dart';

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

await database.downloadProfile();

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
    backgroundColor: const Color(0xFFF4FBFF),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ValueListenableBuilder<bool>(
            valueListenable: ConnectivityService.online,
            builder: (context, online, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Center(
                    child: Image.asset(
                      "assets/logo.png",
                      height: 90,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Center(
                    child: Text(
                      "FishingTrack",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Center(
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Center(
                    child: Text(
                      "Sign in to continue",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (!online)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.cloud_off),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Please connect to the Internet to sign in or create an account.",
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (!online)
                    const SizedBox(height: 20),

                  TextField(
                    controller: emailController,
                    enabled: online,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: passwordController,
                    enabled: online,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (!online || loading)
                          ? null
                          : login,
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(fontSize: 17),
                            ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextButton(
                    onPressed: online
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          }
                        : null,
                    child: const Text(
                      "Don't have an account? Register",
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
}
