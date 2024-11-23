import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kss/screens/mini_games/card_game/screens/start_screen.dart';
import 'package:project_kss/screens/mini_games/card_game/screens/play_screen.dart';

void main() {
  runApp(MyAppCard());
}

class MyAppCard extends StatelessWidget {
  const MyAppCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routes: {
          '/start_screen': (context) => const StartScreen(),
          '/play_screen': (context) => const PlayScreen(),
        },
        initialRoute: '/start_screen',
      ),
    );
  }
}
