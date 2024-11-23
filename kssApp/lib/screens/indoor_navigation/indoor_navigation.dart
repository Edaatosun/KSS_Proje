// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mysql1/mysql1.dart';
import '../../helpers/mysql_helper.dart';
import '../../helpers/warning_dialog_helper.dart';
import '../../util/custom_navigation_bar.dart';

class IndoorNavigation extends StatefulWidget {
  const IndoorNavigation({super.key});

  @override
  _IndoorNavigationState createState() => _IndoorNavigationState();
}

class _IndoorNavigationState extends State<IndoorNavigation> {
  List<ScanResult> devices = [];
  String? previousHighestRSSIDevice;
  int? roomHavingHighestRSSIDevice = 0;
  MySqlConnection? connection;
  int _currentIndex = 2;
  late Timer timer;
  bool _isScanning = false;

  @override
  void initState() {
    _connectToDatabase();
    super.initState();
    startScan();
    timer = Timer.periodic(const Duration(seconds: 5),
        (Timer t) => scanAndShowTheRoomHavingHighestRSSI());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> startScan() async {
    if (_isScanning) return;
    _isScanning = true;
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      FlutterBluePlus.scanResults.listen((results) {
        if (mounted) {
          setState(() {
            devices = results
                .where((result) =>
                    result.device.remoteId.toString().startsWith('7C:B9'))
                .toList();
          });
        }
      });
    } catch (e) {
      print("Error starting scan: $e");
    } finally {
      _isScanning = false;
    }
  }

  String getHighestRSSIDevice() {
    if (devices.isNotEmpty) {
      devices.sort((a, b) => b.rssi.compareTo(a.rssi));
      return devices.first.device.remoteId.toString();
    } else {
      return 'Cihaz bulunamadı';
    }
  }

  scanAndShowTheRoomHavingHighestRSSI() async {
    if (connection == null) {
      showWarningDialog(context, "Database Bağlantı Hatası!",
          "Database'e bağlanırken sistemsel bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.");
      return;
    }

    startScan();
    //String currentHighestRSSIDevice = getHighestRSSIDevice(); //! ble'lerle gerçek zamanlı test için gereken kod
    String currentHighestRSSIDevice =
        "7C:B9:4C:8A:08:D0"; //! test amaçlı kullanmak için statik data

    if (currentHighestRSSIDevice == previousHighestRSSIDevice) {
      return; //* no change = no db request or pop-up dialog
    }

    previousHighestRSSIDevice = currentHighestRSSIDevice;

    roomHavingHighestRSSIDevice = await MySQLHelper.getRoomByMacAddress(
        connection!, currentHighestRSSIDevice);
    print(currentHighestRSSIDevice);
    print(roomHavingHighestRSSIDevice);
    if (roomHavingHighestRSSIDevice == null) {
      showWarningDialog(context, "Oda Bulunamadı",
          "$currentHighestRSSIDevice adresli cihazın bağlı olduğu bir oda bulunamadı.");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastane İçi Navigasyon Sistemi'),
        backgroundColor: const Color.fromARGB(255, 24, 150, 144),
      ),
      body: Center(
        child:
            Text("Bulunduğunuz oda: ${roomHavingHighestRSSIDevice.toString()}"),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (mounted) {
            setState(() {
              _currentIndex = index;
            });
          }
          if (index == 3) {
            CustomBottomNavigationBar.launchAppOrStore(context);
          } else {
            Future.delayed(const Duration(milliseconds: 650), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CustomBottomNavigationBar.pages[_currentIndex],
                ),
              );
            });
          }
        },
      ),
    );
  }

  Future<void> _connectToDatabase() async {
    connection = await MySQLHelper.getConnection();
  }
}
