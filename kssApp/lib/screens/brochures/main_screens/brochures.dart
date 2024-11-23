import 'package:flutter/material.dart';

import '../../../util/custom_navigation_bar.dart';

class Brochures extends StatefulWidget {
  const Brochures({super.key});

  @override
  State<Brochures> createState() => _BrochuresState();
}

class _BrochuresState extends State<Brochures> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Broşürler"),
          backgroundColor: const Color.fromARGB(255, 160, 225, 255),
        ),
        body: const Center(child: Text("Broşürler Sayfası")),
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
            }));
  }
}
