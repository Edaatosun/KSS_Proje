import 'package:flutter/material.dart';
import 'package:project_kss/screens/mini_games/tetris/game/tetris.dart';

void main() {
  runApp(const MyAppTetris());
}

class MyAppTetris extends StatelessWidget {
  const MyAppTetris({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(brightness: Brightness.dark).copyWith(
          scaffoldBackgroundColor: Colors.black,
          dividerColor: const Color(0xFF2F2F2F),
          dividerTheme: const DividerThemeData(thickness: 10),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const Tetris(),
      );
}
