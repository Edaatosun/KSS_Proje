// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import '../../util/custom_navigation_bar.dart';
import 'myText.dart';

class VisitingRules extends StatefulWidget {
  const VisitingRules({super.key});

  @override
  State<VisitingRules> createState() => _VisitingRulesState();
}

class _VisitingRulesState extends State<VisitingRules> {
  late String mainTitle;
  List<MyText> textList = [];
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();

    _getText();

    mainTitle = "Hasta Ziyaret Kuralları";
  }

  void _getText() {
    MySQLHelper.getConnection().then((conn) {
      String sql = 'SELECT * FROM kssapp.texts_for_visit_rules';
      conn?.query(sql).then((results) {
        setState(() {
          for (var row in results) {
            // Her satır için bir MyText nesnesi oluşturun ve textList'e ekleyin
            textList.add(MyText(title: row[0].toString(), text: row[1].toString()));
          }
          // for (var text in textList) {
          // print('Title: ${text.title}, Text: ${text.text}');
          // }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(mainTitle),
          backgroundColor: const Color.fromARGB(255, 24, 150, 144),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Image.asset('assets/images/others/hastaZiyaret2.png'),
                Positioned(
                  top: 120,
                  child: Material(
                    color: Colors.white.withOpacity(0.7),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 400,
                          child: Text(
                            mainTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.indigo[900],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
              buildText(textList),
              const SizedBox(height: 40),
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

  Widget buildText(List<MyText> textList) {
    List<Widget> textBox = [];
    for (int i = 0; i < textList.length; i++) {
      textBox.add(Padding(
        padding: EdgeInsets.only(top: 23.0, bottom: 11.0, left: MediaQuery.of(context).size.width / 28, right: MediaQuery.of(context).size.width / 28),
        child: Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Color.fromRGBO(179, 165, 157, 0.2)),
          child: Text(
            textList[i].title,
            style: TextStyle(fontSize: 21, color: Colors.indigo[900], fontWeight: FontWeight.bold),
          ),
        ),
      ));

      textBox.add(Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 28, right: MediaQuery.of(context).size.width / 28, top: 10),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Color.fromRGBO(249, 221, 207, 0.5),
                ),
                child: Text(textList[i].text,
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center),
              ),
            ]),
          ),
        ]),
      ));
    }
    return isEmpty(textBox);
  }

  Widget isEmpty(List<Widget> textBox) {
    if (textBox.isEmpty) {
      return const Center(
        child: Text("Metin Bulunamadı"),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: textBox,
    );
  }
}
