import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wormhole/log.dart';
import 'package:wormhole/providers.dart';

import 'chat.dart';
import 'login.dart';

void main() async {
  initLog();

  // Make sure necessary providers are initialized
  await container.read(tokenProvider.notifier).init();

  // Run app
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp()
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String location = "/";

    if (ref.read(tokenProvider).isNotEmpty) {
      location = "/chat";
    }

    return MaterialApp.router(
      title: "Wormhole",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: GoRouter(
        initialLocation: location,
        routes: [
          GoRoute(
            path: "/",
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: "/chat",
            builder: (context, state) => const ChatPage(),
          )
        ]
      ),
    );
  }
}
