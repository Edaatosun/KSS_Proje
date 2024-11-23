import 'package:flutter/material.dart';
import '../../../models/movement.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_kss/screens/brochures/movement_screen/my_move_screen.dart';

class DeleteMoveScreen extends StatefulWidget {
  final List<Movement> secilmisHareketler;

  DeleteMoveScreen({required this.secilmisHareketler});

  @override
  _DeleteMoveScreenState createState() => _DeleteMoveScreenState();
}

class _DeleteMoveScreenState extends State<DeleteMoveScreen> {
  List<Movement> _silinmisHareketler = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hareket Sil'),
      ),
      body: ListView.builder(
        itemCount: widget.secilmisHareketler.length,
        itemBuilder: (context, index) {
          final hareket = widget.secilmisHareketler[index];
          return CheckboxListTile(
            title: Text(hareket.name),
            value: _silinmisHareketler.contains(hareket),
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  _silinmisHareketler.add(hareket);
                } else {
                  _silinmisHareketler.remove(hareket);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final hareketNames = prefs.getStringList('selectedHareketler') ?? [];
          for (var hareket in _silinmisHareketler) {
            hareketNames.remove(hareket.name);
          }
          prefs.setStringList('selectedHareketler', hareketNames);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyMoveScreen(),
            ),
          );
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}
