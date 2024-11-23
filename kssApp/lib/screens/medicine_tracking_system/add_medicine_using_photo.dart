// ignore_for_file: no_logic_in_create_state, must_be_immutable, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:project_kss/helpers/local_db_helper.dart';
import 'package:project_kss/helpers/notification_helper.dart';
import 'package:project_kss/helpers/process_image.dart';
import 'package:project_kss/helpers/warning_dialog_helper.dart';
import 'package:project_kss/models/medicine.dart';
import 'package:project_kss/validation/medicine_validator.dart';
import 'package:image_picker/image_picker.dart';
import '../../util/custom_navigation_bar.dart';

class AddMedicineUsingPhoto extends StatefulWidget {
  const AddMedicineUsingPhoto({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddMedicineUsingPhotoState();
  }
}

class AddMedicineUsingPhotoState extends State with MedicineValidationMixin {
  int _currentIndex = 2;
  var localDbHelper = LocalDbHelper();
  var txtName = TextEditingController();
  var txtFrequency = TextEditingController();
  var txtHungerSituation = TextEditingController();
  var medicineList = <Medicine>[];

  var formKey = GlobalKey<FormState>();
  AddMedicineUsingPhotoState();

  final picker = ImagePicker();
  XFile? pickedFile;
  InputImage? inputImage;
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Fotoğraf ile İlaç Giriş"),
          backgroundColor: const Color.fromARGB(255, 24, 150, 144),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[buildButtons(), const SizedBox(height: 20), buildImportedPhoto(), const SizedBox(height: 20), buildForm()],
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
            }));
  }

  Widget buildButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Kamera ile İlaç Ekle"),
              onPressed: () {
                pickPhoto("camera");
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 6, vertical: 12)),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.8);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
                      return Colors.blue.withOpacity(0.9);
                    }
                    return Colors.transparent;
                  },
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.image), // Galeri simgesi
              label: const Text("Galeriden İlaç Ekle"),
              onPressed: () {
                pickPhoto("gallery");
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 6, vertical: 12)),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.8);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
                      return Colors.blue.withOpacity(0.9);
                    }
                    return Colors.transparent;
                  },
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImportedPhoto() {
    return Center(
      child: imagePath == null ? null : Image.file(File(imagePath!)),
    );
  }

  Widget buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          buildNameField(),
          const SizedBox(height: 10),
          buildFrequencyField(),
          const SizedBox(height: 10),
          buildHungerSituationField(),
          const SizedBox(height: 10),
          buildSaveButton(),
        ],
      ),
    );
  }

  Widget buildNameField() {
    return TextFormField(
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 7, 89, 156)),
          ),
          fillColor: Color.fromARGB(255, 252, 250, 250),
          filled: true,
          labelText: "İlaç Adı: "),
      controller: txtName,
      validator: validateMedicineName,
    );
  }

  Widget buildFrequencyField() {
    return TextFormField(
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 7, 89, 156)),
          ),
          fillColor: Color.fromARGB(255, 252, 250, 250),
          filled: true,
          labelText: "Kullanım Sıklığı: ",
          hintText: "12:30, 15:50"),
      controller: txtFrequency,
      validator: validateFrequency,
    );
  }

  Widget buildHungerSituationField() {
    return TextFormField(
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 7, 89, 156)),
          ),
          fillColor: Color.fromARGB(255, 252, 250, 250),
          filled: true,
          labelText: "Açlık Durumu: ",
          hintText: "Aç karnına / Tok Karnına / Aç veya Tok karnına"),
      controller: txtHungerSituation,
      validator: validateHungerSituation,
      readOnly: true,
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState?.save();
          addMedicine();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('İlaç başarıyla eklendi'),
            ),
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 6, vertical: 6)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: const Text("Ekle", style: TextStyle(color: Colors.white)),
    );
  }

  void addMedicine() async {
    var medicineToAdd = Medicine(txtName.text, txtFrequency.text, txtHungerSituation.text);

    //*db
    var id = await localDbHelper.insertMedicine(medicineToAdd);
    medicineToAdd.id = id;

    //*list
    if (mounted) {
      setState(() {
        medicineList.add(medicineToAdd);
      });
    }

    //*notification
    var frequencyList = txtFrequency.text.split(",");
    for (String time in frequencyList) {
      DateTime scheduledTime = parseTimeString(time.trim());
      String notificationTitle = "${txtName.text} için hatırlatıcı";
      String notificationText = "Lütfen ilacı ${txtHungerSituation.text} alınız.";
      scheduleNotification(scheduledTime, notificationTitle, notificationText);
    }
    print("Medicine added with id: $id");

    Navigator.pop(context, medicineToAdd);
  }

  void pickPhoto(String source) async {
    if (source == "camera") {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      if (mounted) {
        setState(() {
          imagePath = pickedFile!.path;
        });
      }
    }
    var inputImage = InputImage.fromFile(File(pickedFile!.path));

    Map<String, String> resultMap = await detectMedicineText(inputImage);
    if (resultMap["frequencyResult"] == null || resultMap["frequencyResult"]!.isEmpty) {
      showWarningDialog(context, "Hata!",
          "İlaç kullanım etiketinde kullanım sıklığı algılanamadı! Lütfen tekrar deneyiniz veya bildirim almak istediğiniz saati '09:35, 08:50' formatında manuel olarak giriniz.");
    }
    if (mounted) {
      setState(() {
        txtFrequency.text = resultMap["frequencyResult"]!;
        txtHungerSituation.text = resultMap["hungerSituationResult"]!;
      });
    }
  }

  DateTime parseTimeString(String timeString) {
    DateFormat format = DateFormat('HH:mm');

    DateTime now = DateTime.now();
    DateTime parsedTime = format.parse(timeString);

    return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  }
}
