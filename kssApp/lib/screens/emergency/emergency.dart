import 'package:flutter/material.dart';
import 'package:project_kss/screens/main_page.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {

  

  void _callEmergency() async {
    final Uri emergencyUri = Uri(scheme: 'tel', path: '112');
    if (await canLaunchUrl(emergencyUri)) {
      await launchUrl(emergencyUri);
    } else {
      debugPrint('Could not launch this url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acil Durum'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: const Color.fromARGB(255, 24, 150, 144),
      
      ),
      backgroundColor: Color.fromRGBO(229, 28, 35, 1), // Arkaplan rengi
      body: Center(
        child: Stack(
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: _callEmergency,
              child: Padding(
                padding: EdgeInsets.all(30), // Görsel etrafındaki padding
                child: Image.asset(
                  'assets/images/buton.png', // Kullanılacak görsel
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            Positioned(
              top: 130, // Yükseklik (görselin üst kısmından)
              left: 133, // Sol taraftan uzaklık (görselin sol kısmından)
              child: GestureDetector(
                onTap: _callEmergency, // Tıklanabilir özellik için
                child: Container(
                  padding: EdgeInsets.all(8), // İçerik etrafındaki padding
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Yarı saydamlık siyah rengi
                    borderRadius: BorderRadius.circular(5), // Köşe yuvarlama
                  ),
                  child: const Text(
                    '112', // Metin gösterimi
                    style: TextStyle(
                      color: Colors.white, // Metin rengi
                      fontSize: 50, // Metin boyutu
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
