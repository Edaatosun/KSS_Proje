// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: PuzzleGame()));
}

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key}) : super(key: key);

  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  List<int> arr = List.generate(16, (index) => index)..shuffle();

  void restartGame() {
    setState(() {
      arr.shuffle();
    });
  }

  void checkWin() {
    if (arr.asMap().entries.every((entry) => entry.key == entry.value)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tebrikler!'),
            content: const Text('Yapbozu başarıyla tamamladınız!'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Tekrar Oyna'),
                onPressed: () {
                  Navigator.of(context).pop();
                  restartGame();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yapboz Oyunu')),
      body: GridView.builder(
        itemCount: 16,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {
          return Draggable<int>(
            data: arr[index],
            feedback: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: Image.asset('assets/images/puzzle_game/card${arr[index]}.png'),
            ),
            childWhenDragging: Container(),
            child: DragTarget<int>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(2),
                  child: Image.asset('assets/images/puzzle_game/card${arr[index]}.png'),
                );
              },
              onWillAcceptWithDetails: (data) => true,
              onAcceptWithDetails: (data) {
                if (mounted) {
                  setState(() {
                    int dataIndex = arr.indexOf(data.data);
                    arr[dataIndex] = arr[index];
                    arr[index] = data.data;
                    checkWin();
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
