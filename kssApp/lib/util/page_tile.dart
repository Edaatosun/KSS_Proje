// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PageTile extends StatelessWidget {
  final String name;

  final buttonColor;
  final String imageName;
  Widget? destinationScreen;
  final double borderRadius = 12;
  //* to launch apps with the button tap
  String? appPackage;
  String? googlePlayUrl;
  String? appStoreUrl;
  String? websiteUrl;

  PageTile(
      {super.key,
      required this.name,
      required this.buttonColor,
      required this.imageName,
      required this.destinationScreen,
      this.appPackage,
      this.googlePlayUrl,
      this.appStoreUrl,
      this.websiteUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () async {
          if (appPackage != null && googlePlayUrl != null && appStoreUrl != null) {
            if (await canLaunchUrl(Uri.parse('market://launch?id=$appPackage'))) {
              await launchUrl(Uri.parse('market://launch?id=$appPackage'));
            } else if (await canLaunchUrl(Uri.parse(googlePlayUrl!))) {
              await launchUrl(Uri.parse(googlePlayUrl!));
            } else if (await canLaunchUrl(Uri.parse(appStoreUrl!))) {
              await launchUrl(Uri.parse(appStoreUrl!));
            } else {
              throw 'Could not launch $appPackage';
            }
          } else if (destinationScreen != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => destinationScreen!,
                ));
          } else if (websiteUrl != null) {
            await launchUrl(Uri.parse(websiteUrl!));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor, //[50]
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24),
                child: Image.asset(imageName),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
