//! first code, everything works except the game over and lives
// // ignore_for_file: library_private_types_in_public_api

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';

// class CapturePillsGame extends StatefulWidget {
//   const CapturePillsGame({super.key});

//   @override
//   _CapturePillsGameState createState() => _CapturePillsGameState();
// }

// class _CapturePillsGameState extends State<CapturePillsGame> {
//   List<Offset> objectPositions = [];
//   Offset characterPosition = const Offset(0.5, 0.9);
//   int score = 0;
//   int lives = 3;
//   bool gameOver = false;
//   final double characterSpeed = 0.01;
//   final double objectSpeed = 0.02;
//   Timer? objectTimer;

//   @override
//   void initState() {
//     super.initState();
//     startGame();
//   }

//   @override
//   void dispose() {
//     objectTimer?.cancel();
//     super.dispose();
//   }

//   void startGame() {
//     gameOver = false;
//     score = 0;
//     lives = 3;
//     objectPositions.clear();
//     objectTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
//       if (!gameOver) {
//         addRandomObject();
//       } else {
//         timer.cancel();
//       }
//     });
//     Timer.periodic(const Duration(milliseconds: 50), (timer) {
//       if (!gameOver) {
//         moveCharacter();
//         moveObjects();
//         checkCollision();
//         if (mounted) {
//           setState(() {});
//         }
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   void addRandomObject() {
//     double randomX = Random().nextDouble();
//     objectPositions.add(Offset(randomX, 0));
//   }

//   void moveCharacter() {
//     if (characterPosition.dx < 0) {
//       characterPosition = Offset(0, characterPosition.dy);
//     }
//     if (characterPosition.dx > 1) {
//       characterPosition = Offset(1, characterPosition.dy);
//     }
//   }

//   void moveObjects() {
//     for (int i = 0; i < objectPositions.length; i++) {
//       if (mounted) {
//         setState(() {
//           objectPositions[i] = Offset(
//             objectPositions[i].dx,
//             objectPositions[i].dy + objectSpeed,
//           );
//         });
//       }
//     }
//   }

//   void checkCollision() {
//     bool collided = false;
//     for (int i = 0; i < objectPositions.length; i++) {
//       double distance =
//           (characterPosition.dx - objectPositions[i].dx).abs() + (characterPosition.dy - objectPositions[i].dy).abs();
//       double collisionTolerance = 0.08;
//       if (distance < collisionTolerance) {
//         if (mounted) {
//           setState(() {
//             objectPositions.removeAt(i);
//             score++;
//           });
//         }
//         collided = true;
//         break; // Çarpışma varsa döngüyü sonlandır
//       }
//     }

//     if (!collided) {
//       if (objectPositions.isNotEmpty && objectPositions.last.dy > 1.0) {
//         objectPositions.removeLast();
//         if (lives > 0) {
//           if (mounted) {
//             setState(() {
//               lives--;
//             });
//           }
//           if (lives == 0) {
//             gameOver = true;
//             showGameOverDialog();
//           }
//         }
//       }
//     }
//   }

//   void showGameOverDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Game Over'),
//           content: Text('You lost the game. Your score: $score'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 startGame();
//               },
//               child: const Text('Restart'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           color: Colors.white, // Arka plan rengi
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//         ),
//         GestureDetector(
//           onHorizontalDragUpdate: (details) {
//             if (mounted) {
//               setState(() {
//                 characterPosition += Offset(
//                   details.primaryDelta! / MediaQuery.of(context).size.width,
//                   0,
//                 );
//               });
//             }
//           },
//           child: Container(
//             color: const Color.fromARGB(255, 162, 155, 155),
//             child: Align(
//               alignment: Alignment(characterPosition.dx * 2 - 1, 0.8),
//               child: Transform.scale(
//                 scale: 8.0,
//                 child: Image.asset(
//                   'assets/images/patient.png',
//                   width: 50,
//                   height: 50,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         ...objectPositions
//             .map((position) => Positioned(
//                   left: position.dx * MediaQuery.of(context).size.width,
//                   top: position.dy * MediaQuery.of(context).size.height,
//                   child: Image.asset(
//                     'assets/images/pill.png',
//                     width: 30,
//                     height: 30,
//                   ),
//                 ))
//             .toList(),
//         Positioned(
//           top: 10,
//           right: 10,
//           child: Row(
//             children: List.generate(
//               lives,
//               (index) => const Icon(Icons.favorite, color: Colors.red),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 10,
//           left: 10,
//           child: Text(
//             'Score: $score',
//             style: const TextStyle(
//               fontSize: 20,
//               color: Colors.red,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

//! second
// ignore_for_file: library_private_types_in_public_api

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';

// class CapturePillsGame extends StatefulWidget {
//   const CapturePillsGame({Key? key}) : super(key: key);

//   @override
//   _CapturePillsGameState createState() => _CapturePillsGameState();
// }

// class _CapturePillsGameState extends State<CapturePillsGame> {
//   List<Offset> objectPositions = [];
//   Offset characterPosition = const Offset(0.5, 0.9);
//   int score = 0;
//   int lives = 3;
//   bool gameOver = false;
//   final double characterSpeed = 0.01;
//   final double objectSpeed = 0.02;
//   Timer? objectTimer;

//   @override
//   void initState() {
//     super.initState();
//     startGame();
//   }

//   @override
//   void dispose() {
//     objectTimer?.cancel();
//     super.dispose();
//   }

//   void startGame() {
//     gameOver = false;
//     score = 0;
//     lives = 3;
//     objectPositions.clear();
//     objectTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
//       if (!gameOver) {
//         addRandomObject();
//       } else {
//         timer.cancel();
//       }
//     });
//     Timer.periodic(const Duration(milliseconds: 50), (timer) {
//       if (!gameOver) {
//         moveCharacter();
//         moveObjects();
//         checkCollision();
//         if (mounted) {
//           setState(() {});
//         }
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   void addRandomObject() {
//     double randomX = Random().nextDouble();
//     objectPositions.add(Offset(randomX, 0));
//   }

//   void moveCharacter() {
//     if (characterPosition.dx < 0) {
//       characterPosition = Offset(0, characterPosition.dy);
//     }
//     if (characterPosition.dx > 1) {
//       characterPosition = Offset(1, characterPosition.dy);
//     }
//   }

//   void moveObjects() {
//     for (int i = 0; i < objectPositions.length; i++) {
//       if (mounted) {
//         setState(() {
//           objectPositions[i] = Offset(
//             objectPositions[i].dx,
//             objectPositions[i].dy + objectSpeed,
//           );
//         });
//       }
//     }
//   }

//   void checkCollision() {
//     bool collided = false;
//     for (int i = 0; i < objectPositions.length; i++) {
//       double distance =
//           (characterPosition.dx - objectPositions[i].dx).abs() + (characterPosition.dy - objectPositions[i].dy).abs();
//       double collisionTolerance = 0.08;
//       if (distance < collisionTolerance) {
//         if (mounted) {
//           setState(() {
//             objectPositions.removeAt(i);
//             score++;
//           });
//         }
//         collided = true;
//         break;
//       }
//     }

//     if (!collided) {
//       if (objectPositions.isNotEmpty && objectPositions.last.dy > 1.0) {
//         objectPositions.removeLast();
//         if (lives > 0) {
//           if (mounted) {
//             setState(() {
//               lives--;
//             });
//           }
//         }
//         if (lives == 0) {
//           if (mounted) {
//             setState(() {
//               gameOver = true;
//             });
//           }
//           showGameOverDialog();
//         }
//       }
//     }
//     // Update the UI when lives change
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void showGameOverDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Game Over'),
//           content: Text('You lost the game. Your score: $score'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 startGame();
//               },
//               child: const Text('Restart'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           color: Colors.white, // Background color
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//         ),
//         GestureDetector(
//           onHorizontalDragUpdate: (details) {
//             if (mounted) {
//               setState(() {
//                 characterPosition += Offset(
//                   details.primaryDelta! / MediaQuery.of(context).size.width,
//                   0,
//                 );
//               });
//             }
//           },
//           child: Container(
//             color: const Color.fromARGB(255, 162, 155, 155),
//             child: Align(
//               alignment: Alignment(characterPosition.dx * 2 - 1, 0.8),
//               child: Transform.scale(
//                 scale: 8.0,
//                 child: Image.asset(
//                   'assets/images/patient.png',
//                   width: 50,
//                   height: 50,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         ...objectPositions
//             .map((position) => Positioned(
//                   left: position.dx * MediaQuery.of(context).size.width,
//                   top: position.dy * MediaQuery.of(context).size.height,
//                   child: Image.asset(
//                     'assets/images/pill.png',
//                     width: 30,
//                     height: 30,
//                   ),
//                 ))
//             .toList(),
//         Positioned(
//           top: 10,
//           right: 10,
//           child: Row(
//             children: List.generate(
//               lives,
//               (index) => const Icon(Icons.favorite, color: Colors.red),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 10,
//           left: 10,
//           child: Text(
//             'Score: $score',
//             style: const TextStyle(
//               fontSize: 20,
//               color: Colors.red,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CapturePillsGame extends StatefulWidget {
  const CapturePillsGame({super.key});

  @override
  _CapturePillsGameState createState() => _CapturePillsGameState();
}

class _CapturePillsGameState extends State<CapturePillsGame> {
  List<Map<String, dynamic>> objectPositions = [];
  Offset characterPosition = const Offset(0.5, 0.9);
  int score = 0;
  bool gameOver = false;
  final double objectSpeed = 0.02;
  Timer? objectTimer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    objectTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    gameOver = false;
    score = 0;
    objectPositions.clear();
    objectTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!gameOver) {
        addObjects();
      } else {
        timer.cancel();
      }
    });
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!gameOver) {
        moveObjects();
        checkCollision();
        if (mounted) {
          setState(() {});
        }
      } else {
        timer.cancel();
      }
    });
  }

  void addObjects() {
    double randomX = Random().nextDouble();
    bool isPoison = Random().nextBool();
    objectPositions.add({'position': Offset(randomX, 0), 'isPoison': isPoison});
  }

  void moveObjects() {
    for (int i = 0; i < objectPositions.length; i++) {
      if (mounted) {
        setState(() {
          objectPositions[i]['position'] = Offset(
            objectPositions[i]['position'].dx,
            objectPositions[i]['position'].dy + objectSpeed,
          );
        });
      }
    }

    objectPositions.removeWhere((element) => element['position'].dy >= 1.0);
  }

  void checkCollision() {
    bool collided = false;
    for (int i = 0; i < objectPositions.length; i++) {
      double distance =
          (characterPosition.dx - objectPositions[i]['position'].dx).abs() + (characterPosition.dy - objectPositions[i]['position'].dy).abs();
      double collisionTolerance = 0.08;
      if (distance < collisionTolerance) {
        if (mounted) {
          setState(() {
            if (objectPositions[i]['isPoison']) {
              score -= 5; // Zehir -5 puan
            } else {
              score += 1; // İlaç +1 puan
            }
            objectPositions.removeAt(i);
          });
        }
        collided = true;
        break;
      }
    }

    if (!collided) {
      if (objectPositions.isNotEmpty && objectPositions.last['position'].dy > 1.0) {
        objectPositions.removeLast();
      }
    }

    if (score >= 30) {
      if (mounted) {
        setState(() {
          gameOver = true;
        });
      }
      showGameOverDialog();
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oyun Sonu!'),
          content: Text('Kazandınız! Skorunuz: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: const Text('Yeniden Başla.'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                characterPosition += Offset(
                  details.primaryDelta! / MediaQuery.of(context).size.width,
                  0,
                );
              });
            },
            child: Container(
              color: const Color.fromARGB(255, 204, 204, 204),
              child: Align(
                alignment: Alignment(characterPosition.dx * 2 - 1, 0.8),
                child: Transform.scale(
                  scale: 8.0, // Ölçek faktörü
                  child: Image.asset(
                    'assets/images/patient.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ),
          ...objectPositions
              .map(
                (position) => Positioned(
                  left: (position['position'].dx * MediaQuery.of(context).size.width).clamp(0.0, MediaQuery.of(context).size.width - 30.0),
                  top: (position['position'].dy * MediaQuery.of(context).size.height).clamp(0.0, MediaQuery.of(context).size.height - 30.0),
                  child: Image.asset(
                    position['isPoison'] ? 'assets/images/poison.png' : 'assets/images/pill.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              )
              .toList(),
          Positioned(
            top: 20,
            left: 20,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 20,
              child: LinearProgressIndicator(
                value: score / 30.0,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 146, 219, 29)),
                minHeight: 15, // Çubuğun minimum yüksekliği
              ),
            ),
          ),
        ],
      ),
    );
  }
}
