import 'package:flutter/material.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import 'package:project_kss/screens/brochures/movement_screen/my_move_screen.dart';
import 'package:project_kss/screens/brochures/notification/local_notifications.dart';
import 'package:project_kss/models/policlinic.dart';
import '../../../models/brochure.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/custom_navigation_bar.dart';

TimeOfDay? _selectedTime = null;
DateTime dt = DateTime(0, 0, 0, 0, 0);

class Physiotherapy_screen extends StatefulWidget {
  final Policlinic? selectedPoliklinik;

  const Physiotherapy_screen({Key? key, this.selectedPoliklinik}) : super(key: key);

  @override
  State<Physiotherapy_screen> createState() => _FizyoterapiEkranState();
}

class _FizyoterapiEkranState extends State<Physiotherapy_screen> {
  int _currentIndex = 2;
  var link = '';
  List<Policlinic> poliklinikListesi = [];
  List<Brosur> brosurListesi = [];

  @override
  void initState() {
    _currentIndex = 2;

    super.initState();
    _getBrosurLink();
    _getPoliklinikListesi();
    _getBrosur();
  }

  void _getPoliklinikListesi() {
    MySQLHelper.getConnection().then((conn) {
      String sql = 'SELECT * FROM kssapp.text';
      conn?.query(sql).then((results) {
        setState(() {
          poliklinikListesi = results.map((row) => Policlinic(row[0], row[1], row[2])).toList();
        });
      });
    });
  }

  void _getBrosurLink() {
    MySQLHelper.getConnection().then((conn) {
      String sql = 'select link from kssapp.brochures where Isım = \'Acil Servis Bilgilendirme Broşürü\';';

      conn?.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            link = row[0];
          });
        }
      });
    });
  }

  void _getBrosur() {
    MySQLHelper.getConnection().then((conn) {
      String sql = 'SELECT * FROM kssapp.brochures';
      conn?.query(sql).then((results) {
        for (var row in results) {
          print(row[1]);
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
        backgroundColor: const Color.fromARGB(255, 24, 150, 144),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyMoveScreen()));
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 147, 204, 204)),
                            ),
                            child: const Text(
                              'Hareket Listesi',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const HatirlaticiKurPopup(),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 147, 204, 204)),
                            ),
                            child: const Text(
                              'Hatırlatıcı Kur',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_selectedTime != null) {
                                //LocalNotifications.cancelScheduledNotificationsAtHour(_selectedTime!.hour);
                                LocalNotifications.kapatBildirimi(1);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Hata"),
                                      content: const Text("Herhangi bir Fizyoterapi hatırlatıcınız bulunmamaktadır."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Tamam"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 147, 204, 204)),
                            ),
                            child: const Text(
                              'Hatırlatıcı Kapat',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildDynamicInkwell(widget.selectedPoliklinik!.name),
                ],
              ),
            ),
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
          }),
    );
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
                  color: Colors.red[400],
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

class HatirlaticiKurPopup extends StatefulWidget {
  const HatirlaticiKurPopup({super.key});

  @override
  _HatirlaticiKurPopupState createState() => _HatirlaticiKurPopupState();
}

class _HatirlaticiKurPopupState extends State<HatirlaticiKurPopup> {
  bool _reminderSet = false;
  int _reminderDays = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Hatırlatıcı Saatini Seç",
            style: TextStyle(fontSize: 20),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _reminderSet
              ? const Text("Hatırlatıcı Kapatıldı")
              : _selectedTime == null
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("Henüz bir saat seçilmedi."),
                    )
                  : Column(
                      children: [
                        Text("Seçilen Saat: ${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}"),
                        const SizedBox(height: 15),
                      ],
                    ),
          ElevatedButton(
            onPressed: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );

              if (pickedTime != null && pickedTime != _selectedTime) {
                setState(() {
                  _selectedTime = pickedTime;
                  _reminderSet = false;
                });
              }
            },
            child: const Text("Saat Seç"),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (_selectedTime != null) {
              setState(() {
                _reminderSet = true;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Hatırlatıcı Bilgisi"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Gün Sayısı: $_reminderDays"),
                        Text("Seçilen Saat: ${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}"),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          print(_selectedTime);
                          LocalNotifications.showScheduleNotificationWithHour(
                              id: 1,
                              title: "Fizyoterapi",
                              body: "Egzersiz saatiniz geldi!!",
                              payload: "paylfoadfd",
                              hour: _selectedTime!.hour,
                              minute: _selectedTime!.minute);
                        },
                        child: const Text("Tamam"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text("Tamam"),
        ),
      ],
    );
  }
}
