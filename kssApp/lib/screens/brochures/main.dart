import 'package:flutter/material.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import 'package:project_kss/screens/brochures/main_screens/physiotherapy_screen.dart';
import 'package:project_kss/models/policlinic.dart';
import 'package:project_kss/screens/brochures/main_screens/policlinic_detail.dart';
import 'package:project_kss/util/custom_navigation_bar.dart';
import 'package:timezone/data/latest.dart' as tz;

class PoliklinikBrosurleri extends StatefulWidget {
  const PoliklinikBrosurleri({Key? key}) : super(key: key);

  @override
  State<PoliklinikBrosurleri> createState() => _PoliklinikBrosurleriState();
}

class _PoliklinikBrosurleriState extends State<PoliklinikBrosurleri> {
  int _currentIndex = 2;
  List<Policlinic> poliklinikListesi = [];
  bool isLoading = true;

  @override
  void initState() {
    _currentIndex = 2;
    super.initState();
    _getPoliklinikListesi();
  }

  Future<void> _getPoliklinikListesi() async {
    final conn = await MySQLHelper.getConnection();
    final results = await conn?.query('SELECT * FROM kssapp.polyclinics');
    if (results != null) {
      setState(() {
        poliklinikListesi = results.map((row) => Policlinic(row[0], row[1], row[2])).toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Poliklinik Broşürleri"),
          backgroundColor: const Color.fromARGB(255, 24, 150, 144),
        ),
        body: Container(
          color: Colors.grey[200],
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 5),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14.5,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.08,
                  ),
                  itemCount: poliklinikListesi.length,
                  itemBuilder: (context, index) {
                    Policlinic poliklinik = poliklinikListesi[index];
                    return InkWell(
                      onTap: () {
                        if (poliklinik.id != 1003) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PoliclinicDetail(selectedPoliklinik: poliklinik)));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Physiotherapy_screen(selectedPoliklinik: poliklinik)));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 147, 204, 204),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                poliklinik.imagePath,
                                height: 65,
                                width: 65,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  width: 150.0,
                                  child: Text(
                                    poliklinik.name,
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  runApp(const MaterialApp(
    home: PoliklinikBrosurleri(),
  ));
}
