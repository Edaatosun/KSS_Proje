// ignore_for_file: use_build_context_synchronously, avoid_print, implementation_imports

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_kss/screens/main_page.dart';
import 'package:mysql1/src/single_connection.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import 'package:project_kss/helpers/notification_helper.dart';
import 'package:project_kss/helpers/warning_dialog_helper.dart';
import 'package:project_kss/validation/queue_number_validator.dart';

import '../../helpers/local_db_helper.dart';
import '../../util/custom_navigation_bar.dart';

class QueueTrackingSystem extends StatefulWidget {
  const QueueTrackingSystem({Key? key}) : super(key: key);

  @override
  State<QueueTrackingSystem> createState() => _QueueTrackingSystemState();
}

class _QueueTrackingSystemState extends State<QueueTrackingSystem> with QueueNumberValidationMixin {
  int _currentIndex = 2;
  String queueImageText = "0";
  var txtQueueNumber = TextEditingController();
  String? savedQueueNumber;

  var txtRoom = TextEditingController();
  List<String> roomList = <String>["Yeşil 1", "Yeşil 2", "Yeşil 3", "Çocuk Acil"];
  String? roomValue = "Yeşil 1";

  var formKey = GlobalKey<FormState>();

  final LocalDbHelper _localDbHelper = LocalDbHelper();

  MySqlConnection? connection;
  late Timer databaseCheckTimer;

  @override
  void initState() {
    super.initState();
    _initializeData(); // to connect to the db, and setting the queue number to YesilAlan1's queue number

    databaseCheckTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (savedQueueNumber != null) {
        checkQueue(savedQueueNumber!);
      } else {
        changeQueueNumberAccordingToRoom();
      }
    });
  }

  @override
  void dispose() {
    databaseCheckTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Acil Sıra Takip Sistemi'),
            backgroundColor: const Color.fromARGB(255, 24, 150, 144),
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  buildWarningNote(),
                  const SizedBox(height: 20),
                  buildRoomMenu(),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          buildQueueNumberField(),
                          buildQueueNumberText(),
                          buildSaveButton(),
                        ],
                      )),
                ],
              ),
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
              })),
    );
  }

  Widget buildWarningNote() {
    return const Center(
      child: Text(
        "Lütfen sıra numaranızı aşağıdaki boşluğa girip kaydedin. Sıranız geldiğinde bildirim alacaksınız.",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  Widget buildQueueNumberText() {
    return Center(
      child: Text(
        queueImageText,
        style: const TextStyle(color: Colors.black, fontSize: 155),
      ),
    );
  }

  Widget buildRoomMenu() {
    txtRoom.text = roomValue!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 12),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255)),
          ),
        ),
        value: roomValue,
        elevation: 16,
        onChanged: (String? value) {
          if (mounted) {
            setState(() {
              txtRoom.text = roomValue = value!;
              changeQueueNumberAccordingToRoom();
            });
          }
        },
        items: roomList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget buildQueueNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 7, 89, 156)),
            ),
            fillColor: Color.fromARGB(255, 252, 250, 250),
            filled: true,
            labelText: "Sıra Numarası: ",
            hintText: "Sadece sayı giriniz."),
        validator: validateQueueNumber,
        controller: txtQueueNumber,
      ),
    );
  }

  Widget buildSaveButton() {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState?.save();
          checkQueue(txtQueueNumber.text);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 125),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 33, 185, 255),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "KAYDET",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveQueueNumber() async {
    int queueNumber = int.parse(txtQueueNumber.text.trim());
    String roomName = txtRoom.text;
    String normalizedRoomName = normalizeRoomName(roomName);

    bool queueNumberExists = await _localDbHelper.doesQueueNumberExist(normalizedRoomName);

    if (queueNumberExists) {
      await _localDbHelper.updateQueueNumber(queueNumber, normalizedRoomName);
      print("$roomName is successfully updated as $queueNumber");
    } else {
      await _localDbHelper.insertQueueNumber(queueNumber, normalizedRoomName);
      print("$roomName is successfully inserted as $queueNumber");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sıra numarası başarıyla kaydedildi.'),
      ),
    );
  }

  void changeQueueNumberAccordingToRoom() async {
    if (connection == null) {
      showWarningDialog(
          context, "Database Bağlantı Hatası!", "Database'e bağlanırken sistemsel bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.");
      return;
    }

    int queueNumber = await MySQLHelper.getQueueNumber(connection!, 'YesilAlan1');

    if (txtRoom.text == "Yeşil 1") {
      queueNumber = await MySQLHelper.getQueueNumber(connection!, 'YesilAlan1');
    } else if (txtRoom.text == "Yeşil 2") {
      queueNumber = await MySQLHelper.getQueueNumber(connection!, 'YesilAlan2');
    } else if (txtRoom.text == "Yeşil 3") {
      queueNumber = await MySQLHelper.getQueueNumber(connection!, 'YesilAlan3');
    } else if (txtRoom.text == "Çocuk Acil") {
      queueNumber = await MySQLHelper.getQueueNumber(connection!, 'CocukAcil');
    }

    if (mounted) {
      setState(() {
        queueImageText = "$queueNumber";
      });
    }
  }

  void checkQueue(String inputNumber) async {
    int queueNumberResult = 0;

    if (connection == null) {
      showWarningDialog(
          context, "Database Bağlantı Hatası!", "Database'e bağlanırken sistemsel bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.");
      return;
    }

    if (txtRoom.text == "Yeşil 1") {
      queueNumberResult = await MySQLHelper.getQueueNumber(connection!, "YesilAlan1");
    } else if (txtRoom.text == "Yeşil 2") {
      queueNumberResult = await MySQLHelper.getQueueNumber(connection!, "YesilAlan2");
    } else if (txtRoom.text == "Yeşil 3") {
      queueNumberResult = await MySQLHelper.getQueueNumber(connection!, "YesilAlan3");
    } else if (txtRoom.text == "Çocuk Acil") {
      queueNumberResult = await MySQLHelper.getQueueNumber(connection!, "CocukAcil");
    }

    if (mounted) {
      setState(() {
        queueImageText = "$queueNumberResult";
      });
    }

    int difference = int.parse(inputNumber) - queueNumberResult;
    if (queueNumberResult == -1 || queueNumberResult == 0) {
      showWarningDialog(
          context,
          "Hata!", // 500 internal server error
          "Acil sırasını algılarken sistemsel bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.");
    } else {
      savedQueueNumber = txtQueueNumber.text;
      if (difference < 0) {
        showWarningDialog(
            context,
            "Hata!", //400 bad request
            "Sıranız odadaki kişinin sırasından küçük olamaz! Lütfen acil oda tipini ve sıranızı kontrol edip tekrar deneyiniz.");
      } else if (difference == 0) {
        String notificationTitle = "Sıranız geldi.";
        String notificationText = "Lütfen acil servise geliniz.";
        showNotification(notificationTitle, notificationText);
      } else if (difference <= 5) {
        _saveQueueNumber();
        String notificationTitle = "Sıranıza yaklaştı.";
        String notificationText = "Sıranıza $difference kişi kaldı. Lütfen acil servise geliniz.";
        showNotification(notificationTitle, notificationText);
      } else {
        _saveQueueNumber();
        showWarningDialog(context, "Sıranıza $difference kişi var.",
            "Lütfen uygulamayı KAPATMAYINIZ, acil sıra takip sistemi açık olacak şekilde arka planda tutunuz.\n\nSıranın size gelmesine 5 kişi kaldığında bildirim alacaksınız.");
      }
    }
  }

  Future<void> _initializeData() async {
    txtQueueNumber.text = (await _localDbHelper.getQueueNumberByRoom("YesilAlan1")).toString();
    await _connectToDatabase();
    await _setQueueImageText();
  }

  Future<void> _connectToDatabase() async {
    connection = await MySQLHelper.getConnection();
  }

  Future<void> _setQueueImageText() async {
    if (mounted) {
      if (connection == null) {
        showWarningDialog(
            context, "Database Bağlantı Hatası!", "Database'e bağlanırken sistemsel bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.");
        return;
      }

      int queueNumber = await MySQLHelper.getQueueNumber(connection!, 'YesilAlan1');

      setState(() {
        queueImageText = "$queueNumber";
      });
    }
  }

  String normalizeRoomName(String roomName) {
    switch (roomName) {
      case 'Yeşil 1':
        return 'YesilAlan1';
      case 'Yeşil 2':
        return 'YesilAlan2';
      case 'Yeşil 3':
        return 'YesilAlan3';
      case 'Çocuk Acil':
        return 'CocukAcil';
      default:
        return roomName;
    }
  }
}
