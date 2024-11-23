import 'package:flutter/material.dart';
import 'package:project_kss/screens/mini_games/card_game/main.dart';

class TimeOutDialog extends StatelessWidget {
  const TimeOutDialog({Key? key, required this.title, required this.content})
      : super(key: key);
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAppCard(),
              ),
            );
          },
          child: const Text('Yeniden Oyna'),
        ),
      ],
    );
  }
}