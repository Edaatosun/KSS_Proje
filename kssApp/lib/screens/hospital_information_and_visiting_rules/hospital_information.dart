import 'package:flutter/material.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import '../../util/custom_navigation_bar.dart';
import 'IconObject.dart';

class HospitalInformation extends StatefulWidget {
  const HospitalInformation({super.key});

  @override
  State<StatefulWidget> createState() => _HospitalInformationState();
}

class _HospitalInformationState extends State<HospitalInformation> {
  String title = "Kanuni Sultan Süleyman Hastanesi";
  String hastaneTanitimYazisi1 = "Sağlık hizmetlerinde; uluslararası düzeyde uygulamaları takip ederek, ekip bilincini benimsemiş, kurumsal kimliği öne çıkan, çağdaş bilimin gerektirdiği bilgi ve becerilerle donatılmış uzman kadromuz ile ülkemizin en tercih edilen hastanesi olmaktır.";
  String hastaneTanitimYazisi2 = "Uzmanlaştığımız tüm sağlık hizmetlerinde, tıbbın ulaştığı en üst düzeyde, güvenilir, hasta odaklı ve kaliteli hizmet veren, hasta ve çalışan güvenliğini ön planda tutan, hasta haklarına saygılı, çevreye duyarlı, nitelikli sağlık çalışanı yetiştiren yenilikçi ve sürekli kendini geliştiren öncü bir kuruluş olmaktır.";
  String title2 = "Rakamlara Hastanemiz";
  // ignore: unused_field
  bool _isVisible = false;
  // final bool _isContainerVisible = true;
  List<IconObject> iconsList = [];
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();

    // initState metodu içerisinde bir süre bekleyerek yazının yavaşça görünmesini sağlar
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
    _getIconList();
  }

  void _getIconList() {
    MySQLHelper.getConnection().then((conn) {
      String sql = 'SELECT * FROM kssapp.icon_object_hospital_intro';
      conn?.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            iconsList.add(IconObject(row[0].toString(), row[1].toString(), row[2]));
            // for (var text in iconsList) {
            //   print("a");
            // }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 24, 150, 144),
        elevation: 0,
        title: const Text('K.S.S Hastanesi'),
      ),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Stack(children: [
                  Image.asset(
                    'assets/images/others/istanbul-kanuni-sultan-suleyman-egitim-ve-arastirma-hastanesi.jpg',
                  ),
                ]),
                Positioned(
                  top: 120,
                  child: Material(
                    color: Colors.white.withOpacity(0.7),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.01,
                          child: Padding(
                            padding: EdgeInsets.only(top: 23.0, bottom: 11.0, left: MediaQuery.of(context).size.width / 60, right: MediaQuery.of(context).size.width / 60),
                            child: Container(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Color.fromRGBO(179, 165, 157, 0.2)),
                              child: Center(
                                child: Text(
                                  title,
                                  style: TextStyle(fontSize: 20, color: Colors.indigo[900], fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // SizedBox(height: 9),
                Positioned(
                  top: 120,
                  child: Material(
                    color: Colors.white.withOpacity(0.7),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.02,
                          child: Padding(
                            padding: EdgeInsets.only(top: 23.0, bottom: 11.0, left: MediaQuery.of(context).size.width / 60, right: MediaQuery.of(context).size.width / 60),
                            child: Container(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                hastaneTanitimYazisi1,
                                style: TextStyle(fontSize: 18, color: Colors.indigo[600], fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.blue[50],
                  ),
                  child: Image.asset(
                    'assets/images/others/I6NikQQ4.jpg',
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 1.1,
                  ),
                ),

                Positioned(
                  top: 120,
                  child: Material(
                    color: Colors.white.withOpacity(0.7),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.02,
                          child: Padding(
                            padding: EdgeInsets.only(top: 23.0, bottom: 11.0, left: MediaQuery.of(context).size.width / 60, right: MediaQuery.of(context).size.width / 60),
                            child: Container(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                hastaneTanitimYazisi2,
                                style: TextStyle(fontSize: 18, color: Colors.indigo[600], fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 120,
                  child: Material(
                    color: Colors.white.withOpacity(0.7),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.01,
                          child: Padding(
                            padding: EdgeInsets.only(top: 23.0, bottom: 11.0, left: MediaQuery.of(context).size.width / 60, right: MediaQuery.of(context).size.width / 60),
                            child: Container(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Color.fromRGBO(179, 165, 157, 0.2)),
                              child: Center(
                                child: Text(
                                  title2,
                                  style: TextStyle(fontSize: 20, color: Colors.indigo[900], fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Yatay kaydırma
                  child: Row(
                    children: [
                      const SizedBox(width: 10), // Başlangıç için boşluk
                      for (int index = 0; index < iconsList.length; index++)
                        Row(
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(iconsList[index].imagePath),
                                ),
                                Text(
                                  iconsList[index].number.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(iconsList[index].title),
                              ],
                            ),
                            const SizedBox(width: 20), // İstenen boşluk
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 70),
              ],
            )),
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
        },
      ),
    );
  }
}
