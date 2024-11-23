import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../util/custom_navigation_bar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _currentIndex = 4;

  late GoogleMapController? mapController;
  final LatLng _center = const LatLng(41.054639065941714, 28.759679367509786);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    _currentIndex = 4;
    super.initState();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İletişim ve Konum'),
        backgroundColor: const Color.fromARGB(255, 24, 150, 144),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Adres:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 5.0),
            const Text(
              'Atakent Mh, Turgut Özal Bulvari No:46/1, 34303 Küçükçekmece/İstanbul',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Telefon Numarası:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 5.0),
            const Text(
              '0212 404 1500',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: _markers,
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _markers.add(
        Marker(
          markerId: const MarkerId('kss-location'),
          position: _center,
          infoWindow: const InfoWindow(
            title: 'Kanuni Sultan Süleyman Eğitim ve Araştırma Hastanesi',
            snippet: 'Atakent Mh, Turgut Özal Bulvari No:46/1, 34303 Küçükçekmece/İstanbul',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }
}
