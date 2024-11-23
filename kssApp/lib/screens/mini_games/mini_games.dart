// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../util/custom_navigation_bar.dart';
import 'card_game/main.dart';
import 'memory_game.dart';
import 'capture_pills_game.dart';
import 'puzzle_game.dart';
import 'package:project_kss/util/page_tile.dart';

import 'snake_game/main.dart';
import 'tetris/main.dart';

class MiniGames extends StatefulWidget {
  const MiniGames({Key? key}) : super(key: key);

  @override
  State<MiniGames> createState() => _MainPageState();
}

class _MainPageState extends State<MiniGames> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: const Color.fromARGB(255, 218, 239, 247),
        body: Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: buildButtons(),
            )
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 3) {
                CustomBottomNavigationBar.launchAppOrStore(context);
              } else {
                Future.delayed(const Duration(milliseconds: 650), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomBottomNavigationBar.pages[_currentIndex],
                    ),
                  );
                });
              }
            }));
  }

  List pages = [
    [
      "Puzzle",
      const Color.fromARGB(255, 244, 99, 3),
      "assets/images/icons/puzzle.png",
      const PuzzleGame(),
    ],
    [
      "İlaç Yakalama",
      const Color.fromARGB(255, 74, 226, 79),
      "assets/images/icons/capture_pills.png",
      const CapturePillsGame(),
    ],
    [
      "Hafıza oyunu",
      const Color.fromARGB(255, 63, 55, 225),
      "assets/images/icons/memory_game.png",
      const MemoryGame(),
    ],
    [
      "Yılan Oyunu",
      const Color.fromARGB(175, 255, 224, 25),
      "assets/images/snake_game/snake.png",
      const MyAppSnake(),
    ],
    [
      "Kart Oyunu",
      const Color.fromARGB(200, 173, 16, 16),
      "assets/images/icons/memory_game.png",
      const MyAppCard(),
    ],
    [
      "Tetris",
      const Color.fromARGB(175, 109, 9, 194),
      "assets/images/icons/memory_game.png",
      const MyAppTetris(),
    ],
  ];

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 24, 150, 144),
      title: const Text("Mini Oyunlar"),
      elevation: 0,
    );
  }

  Widget buildButtons() {
    return Center(
      child: GridView.builder(
        itemCount: pages.length,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.37,
        ),
        itemBuilder: (context, index) {
          return PageTile(
            name: pages[index][0],
            buttonColor: pages[index][1],
            imageName: pages[index][2],
            destinationScreen: pages[index][3],
          );
        },
      ),
    );
  }
}
