// ignore_for_file: use_build_context_synchronously

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project_kss/screens/hospital_information_and_visiting_rules/hospital_information.dart';
import 'package:project_kss/screens/pharmacy_on_duty/pharmacy_on_duty_v3.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/contact/contact_page.dart';
import '../screens/main_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  static List<Widget> pages = const [
    PharmacyOnDutyV3(),
    HospitalInformation(),
    MainPage(),
    MainPage(),
    ContactPage(),
  ];

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      height: 50,
      backgroundColor: const Color.fromARGB(255, 218, 239, 247), //const Color.fromARGB(255, 160, 225, 255),
      color: const Color.fromARGB(255, 24, 150, 144), //const Color.fromARGB(255, 160, 225, 255),
      onTap: onTap,
      items: const [
        Icon(
          Icons.local_pharmacy,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        Icon(
          Icons.info,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        Icon(
          Icons.home,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        Icon(
          Icons.favorite,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        Icon(
          Icons.location_on,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ],
    );
  }

  static void launchAppOrStore(BuildContext context) async {
    const String appPackage = 'tr.gov.saglik.enabiz';
    const String googlePlayUrl = 'https://play.google.com/store/apps/details?id=$appPackage';
    const String appStoreUrl = 'https://apps.apple.com/us/app/e-nab%C4%B1z/id980446169';

    bool launchSuccess = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("E-NABIZ"),
          content: const Text("E-NABIZ'a gidilecek, onaylıyor musunuz?"),
          actions: <Widget>[
            TextButton(
              child: const Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Tamam"),
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse('market://launch?id=$appPackage'))) {
                  await launchUrl(Uri.parse('market://launch?id=$appPackage'));
                  launchSuccess = true;
                } else {
                  if (await canLaunchUrl(Uri.parse(googlePlayUrl))) {
                    await launchUrl(Uri.parse(googlePlayUrl));
                    launchSuccess = true;
                  } else {
                    if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
                      await launchUrl(Uri.parse(appStoreUrl));
                      launchSuccess = true;
                    } else {
                      throw 'Could not launch $appStoreUrl';
                    }
                  }
                }
                if (launchSuccess) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
