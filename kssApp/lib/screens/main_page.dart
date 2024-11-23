// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_kss/screens/announcements/announcements.dart';
import 'package:project_kss/screens/brochures/main.dart';
import 'package:project_kss/screens/doctors_info/doctors_info.dart';
import 'package:project_kss/screens/emergency/emergency.dart';
import 'package:project_kss/screens/hospital_information_and_visiting_rules/hospital_information.dart';
import 'package:project_kss/screens/indoor_navigation/indoor_navigation.dart';
import 'package:project_kss/screens/medicine_tracking_system/medicine_tracking_system.dart';
import 'package:project_kss/screens/mini_games/mini_games.dart';
import 'package:project_kss/screens/nurse_calling_system/nurse_calling_system.dart';
import 'package:project_kss/screens/queue_tracking_system/queue_tracking_system.dart';
import 'package:project_kss/util/custom_navigation_bar.dart';
import 'package:project_kss/util/page_tile.dart';

import 'hospital_information_and_visiting_rules/ziyaretci_kurallari.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 2;

  @override
  void initState() {
    _currentIndex = 2;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: const Color.fromARGB(255, 252, 248, 244),
        drawer: buildDrawer(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5),
              const ImageSlider(),
              const SizedBox(height: 10),
              buildButtons(),
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

  List pages = [
    [
      "Duyurular",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/advertisement.png",
      const Announcements(),
    ],
    [
      "Hastane İçi\nNavigasyon",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/map.png",
      const IndoorNavigation(),
    ],
    [
      "İlaç Takip",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/medicine.png",
      const MedicineTrackingSystem(),
    ],
    [
      "Acil Sıra\n  Takip",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/queue_tracking_icon.png",
      const QueueTrackingSystem(),
    ],
    [
      "Mini Oyunlar",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/game-console.png",
      const MiniGames(),
    ],
    [
      "Broşürler",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/brochure.png",
      const PoliklinikBrosurleri(),
    ],
    [
      "Hemşire Çağrı\nSistemi",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/nurse.png",
      const NurseCallingSystem(),
    ],
    [
      "Tahlillerim",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/medicine.png",
      null,
      null,
      null,
      null,
      "https://kanunieah.istanbulsaglik.gov.tr:4443/hastaportal/#/?p=results"
    ],
    [
      "E-Randevu",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/medicine.png",
      null,
      "tr.gov.saglik.MHRSMOBIL",
      "https://play.google.com/store/apps/details?id=tr.gov.saglik.MHRSMOBIL",
      "https://apps.apple.com/tr/app/mhrs/id1539508996?l=tr",
      null
    ],
    [
      "Acil Durum",
      const Color.fromARGB(255, 147, 204, 204),
      "assets/images/icons/emergency.png",
       EmergencyScreen(),
    ],
  ];

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 24, 150, 144),
      elevation: 0,
      title: const Text('K.S.S Hastanesi'),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 24, 150, 144),
            ),
            child: Center(
              child: Image.asset("assets/images/kss.png"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.announcement),
            title: const Text(
              'Duyurular',
              style: TextStyle(
                fontFamily: 'Avenir',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Announcements(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital),
            title: const Text('Hastane Tanıtım'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HospitalInformation(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Ziyaret Kuralları'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VisitingRules(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('Doktorlarımız'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DoctorsInfo(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Acil Durum'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmergencyScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pages.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.37,
      ),
      itemBuilder: (context, index) {
        return PageTile(
          name: pages[index][0],
          buttonColor: pages[index][1],
          imageName: pages[index][2],
          destinationScreen: pages[index][3],
          appPackage: pages[index].length > 4 ? pages[index][4] : null,
          googlePlayUrl: pages[index].length > 5 ? pages[index][5] : null,
          appStoreUrl: pages[index].length > 6 ? pages[index][6] : null,
          websiteUrl: pages[index].length > 7 ? pages[index][7] : null,
        );
      },
    );
  }
}

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _controller = PageController(
    viewportFraction: 1,
  );
  int _currentPage = 0;
  final List<String> images = [
    "assets/images/d1.png",
    "assets/images/d2.png",
    "assets/images/d3.png",
    "assets/images/d4.png",
  ];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (int page) {
              if (mounted) {
                setState(() {
                  _currentPage = page;
                });
              }
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NurseCallingSystem(),
                ),
              );
            },
            behavior: HitTestBehavior.translucent,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
