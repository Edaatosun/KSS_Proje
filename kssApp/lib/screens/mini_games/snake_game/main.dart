import 'package:flutter/material.dart';

import 'package:project_kss/screens/mini_games/snake_game/splash_screen.dart';

void main() {
  runApp(const MyAppSnake());
}

class MyAppSnake extends StatelessWidget {
  const MyAppSnake({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 13, 58, 19),
        primaryColor: Colors.green,
        hintColor: Colors.red,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
