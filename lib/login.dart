import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wormhole/api.dart';
import 'package:wormhole/providers.dart';

import 'log.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends ConsumerState<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  String error = "";

  void login() async {
    if (username.text.isEmpty || password.text.isEmpty) return;

    setState(() => error = "");

    try {
      final res = await apiPost("/login", { "username": username.text, "password": password.text });

      final token = res["token"];
      ref.read(tokenProvider.notifier).set(token);

      if (mounted) context.go("/chat");
    }
    on ApiException catch (e) {
      setState(() => error = e.error);
      log.error(e);
    }
  }

  void register() async {
    if (username.text.isEmpty || password.text.isEmpty) return;

    setState(() => error = "");

    try {
      final res = await apiPost("/register", { "username": username.text, "password": password.text });

      final token = res["token"];
      ref.read(tokenProvider.notifier).set(token);

      if (mounted) context.go("/chat");
    }
    on ApiException catch (e) {
      setState(() => error = e.error);
      log.error(e);
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints.loose(const Size.fromWidth(400)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Wormhole",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: username,
                decoration: const InputDecoration(
                  labelText: "Username"
                ),
              ),
              TextField(
                controller: password,
                decoration: const InputDecoration(
                  labelText: "Password"
                ),
                obscureText: true
              ),
              const SizedBox(height: 12),
              if (error.isNotEmpty) ...[
                Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: login,
                      style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(16))
                      ),
                      child: const Text("Login"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: register,
                      style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(16))
                      ),
                      child: const Text("Register"),
                    ),
                  ),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}