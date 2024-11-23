import 'package:flutter/material.dart';

import 'package:project_kss/models/policlinic.dart';
import '../../../models/brochure.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/custom_navigation_bar.dart';

class PoliclinicDetail extends StatefulWidget {
  final Policlinic? selectedPoliklinik;

  const PoliclinicDetail({Key? key, this.selectedPoliklinik}) : super(key: key);

  @override
  State<PoliclinicDetail> createState() => _PoliklinikDetayState();
}

class _PoliklinikDetayState extends State<PoliclinicDetail> {
  int _currentIndex = 2;
  var link = '';
  List<Policlinic> poliklinikListesi = [];
  List<Brosur> brosurListesi = [];

  @override
  void initState() {
    _currentIndex = 2;
    super.initState();
    _getPoliklinikListesi();
    _getBrosur();
  }

  void _getPoliklinikListesi() {
    MySQLHelper.getConnection().then((conn) {
      String sql = 'SELECT * FROM kssapp.polyclinics';
      conn?.query(sql).then((results) {
        setState(() {
          poliklinikListesi = results.map((row) => Policlinic(row[0], row[1], row[2])).toList();
        });
      });
    });
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
          title: Text(widget.selectedPoliklinik?.name ?? 'Poliklinik'),
          backgroundColor: Colors.grey[200],
        ),
        body: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Image.asset(
                    widget.selectedPoliklinik!.imagePath,
                    height: MediaQuery.of(context).size.width / 5,
                    width: MediaQuery.of(context).size.width / 5,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              buildDynamicInkwell(widget.selectedPoliklinik!.name)
            ],
          ),
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
                Future.delayed(const Duration(milliseconds: 600), () {
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

  Widget buildDynamicInkwell(String poliklinik) {
    List<Widget> brochures = [];
    for (int i = 0; i < brosurListesi.length; i++) {
      if (brosurListesi[i].poliklinik == poliklinik) {
        if (i % 2 == 0) {
          brochures.add(
            InkWell(
              key: UniqueKey(),
              onTap: () async {
                await launch(brosurListesi[i].url);
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
              key: UniqueKey(),
              onTap: () async {
                await launch(brosurListesi[i].url);
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
