// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import '../../../models/brochure.dart';
import 'package:project_kss/screens/brochures/movement_screen/move_detail_screen.dart';
import '../../../models/movement.dart';

class AddMoveScreen extends StatefulWidget {
  final Movement? hareket;
  List<Movement?> secilmisHareketler;

  AddMoveScreen({Key? key, this.hareket, required this.secilmisHareketler}) : super(key: key) {
    secilmisHareketler = [];
  }

  @override
  State<AddMoveScreen> createState() => _AddMoveScreenState();
}

class _AddMoveScreenState extends State<AddMoveScreen> {
  List<Brosur> brosurListesi = [];
  late String brosurIsmi;

  @override
  void initState() {
    super.initState();

    _getBrosur();
  }

  void _getBrosur() {
    MySQLHelper.getConnection().then((conn) {
      String sql = 'SELECT * FROM kssapp.brochures';
      conn?.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            brosurListesi.add(Brosur(row[0], row[1], row[2], row[3], row[4]));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hareket broşür seçme"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Lütfen eklemek istediğiniz hareketin broşürünü seçiniz"),
              if (widget.hareket != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.hareket!.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              const SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [buildDynamicInkwell()],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDynamicInkwell() {
    String poliklinik = "Fizyoterapi";
    List<Widget> brochures = [];
    for (int i = 0; i < brosurListesi.length; i++) {
      if (brosurListesi[i].poliklinik == poliklinik) {
        if (i % 2 == 0) {
          brochures.add(
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoveDetailScreen(
                      hareketler: const [],
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.circular(44.0),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                    child: Text(brosurListesi[i].brosurIsmi),
                  ),
                ),
              ),
            ),
          );
        } else {
          brochures.add(
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.circular(44.0),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                    child: Text(brosurListesi[i].brosurIsmi),
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
    return isEmpty(brochures);
  }

  Widget isEmpty(List<Widget> brochures) {
    if (brochures.isEmpty) {
      return const Center(
        child: Text("Broşür Bulunamadı"),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: brochures,
    );
  }
}
