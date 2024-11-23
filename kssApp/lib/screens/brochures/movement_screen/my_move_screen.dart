import 'package:flutter/material.dart';
import 'package:project_kss/screens/brochures/movement_screen/add_move_screen.dart';
import 'package:project_kss/screens/brochures/movement_screen/delete_move_screen.dart';
import 'package:project_kss/models/movement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMoveScreen extends StatefulWidget {
  const MyMoveScreen({Key? key}) : super(key: key);

  @override
  State<MyMoveScreen> createState() => _HareketlerimEkraniState();
}

class _HareketlerimEkraniState extends State<MyMoveScreen> {
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
      secilmisHareketler =
          hareketNames.map((name) => Movement(name: name)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hareketlerim'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMoveScreen(
                          secilmisHareketler: secilmisHareketler,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/brochure_screen/plus.png",
                            width: MediaQuery.of(context).size.width / 19,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Hareket Ekle",
                            style: TextStyle(fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeleteMoveScreen(
                          secilmisHareketler: secilmisHareketler,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/brochure_screen/cross.png",
                            width: MediaQuery.of(context).size.width / 19,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Hareket Sil",
                            style: TextStyle(fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: secilmisHareketler.isEmpty
                ? Center(child: Text('Seçili hareketiniz bulunmamaktadır.'))
                : ListView.builder(
              itemCount: secilmisHareketler.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(secilmisHareketler[index].name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
