// ignore_for_file: must_be_immutable, avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_kss/models/movement.dart';
import 'my_move_screen.dart';

class MoveDetailScreen extends StatefulWidget {
  Movement hareket1 = Movement(
    brosurName: "brosur 1",
    id: 1,
    name: "Hareket 1.6",
    imagePath: "images/fizyo1.png",
  );
  final List<Movement?> hareketler;

  MoveDetailScreen({
    Key? key,
    required this.hareketler,
  }) : super(key: key);

  @override
  State<MoveDetailScreen> createState() => _MoveDetailScreenState();
}

class _MoveDetailScreenState extends State<MoveDetailScreen> {
  bool isMarked = false;
  List<Movement> secilmisHareketler = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedHareketler();
  }

  Future<void> _loadSelectedHareketler() async {
    final prefs = await SharedPreferences.getInstance();
    final hareketNames = prefs.getStringList('selectedHareketler') ?? [];
    setState(() {
      secilmisHareketler = hareketNames.map((name) => Movement(name: name)).toList();
    });
  }

  Future<void> _saveSelectedHareketler() async {
    final prefs = await SharedPreferences.getInstance();
    final hareketNames = secilmisHareketler.map((hareket) => hareket.name).toList();
    prefs.setStringList('selectedHareketler', hareketNames);
  }

  void updateSelectedHareketler(Movement hareket) {
    setState(() {
      bool isExisting = secilmisHareketler.any((existingHareket) => existingHareket.name == hareket.name);
      if (!isExisting) {
        secilmisHareketler.add(hareket);
        _saveSelectedHareketler();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Uyarı'),
            content: const Text('Bu hareket zaten listeye eklenmiş.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hareket Detayı'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.hareketler.isNotEmpty && widget.hareketler[1] != null) Text(widget.hareketler[1]!.name),
            InkWell(
              onTap: () {
                setState(() {
                  isMarked = !isMarked;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2, color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.hareket1.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isMarked = !isMarked;
                            });
                            updateSelectedHareketler(widget.hareket1);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: isMarked ? Colors.blue : Colors.transparent,
                              border: Border.all(width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 10,
                    ),
                    Image.asset(
                      widget.hareket1.imagePath,
                      width: 145,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.hareket1.name != null) {
                  updateSelectedHareketler(widget.hareket1);
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyMoveScreen(),
                  ),
                );
                print(secilmisHareketler[0].name);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
