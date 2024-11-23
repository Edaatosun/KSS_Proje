// ignore_for_file: must_be_immutable, avoid_print, no_logic_in_create_state, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_kss/helpers/local_db_helper.dart';
import 'package:project_kss/helpers/notification_helper.dart';
import 'package:project_kss/models/medicine.dart';
import 'package:project_kss/validation/medicine_validator.dart';

import '../../util/custom_navigation_bar.dart';

class AddMedicineManually extends StatefulWidget {
  const AddMedicineManually({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddMedicineManuallyState();
  }
}

class AddMedicineManuallyState extends State with MedicineValidationMixin {
  int _currentIndex = 2;
  var localDbHelper = LocalDbHelper();
  var txtName = TextEditingController();
  var txtFrequency = TextEditingController();
  var txtHungerSituation = TextEditingController();

  var formKey = GlobalKey<FormState>();
  AddMedicineManuallyState();

  List<String> hungerList = <String>[
    'Aç veya tok karnına',
    'Aç karnına',
    'Tok karnına',
  ];
  String? hungerValue = 'Aç veya tok karnına';
  var medicineList = <Medicine>[];

  int selectedPickCount = 1;
  List<int> pickCountOptions = [1, 2, 3]; // max 3 bildirim seçebilir
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    for (int i = 0; i < selectedPickCount; i++) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (picked != null && picked != selectedTime) {
        if (mounted) {
          setState(() {
            selectedTime = picked;
            final formattedTime = '${picked.hour}:${picked.minute}';
            txtFrequency.text = txtFrequency.text.isEmpty ? formattedTime : '${txtFrequency.text}, $formattedTime';
          });
        }
      } else {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Manuel İlaç Giriş"),
          backgroundColor: const Color.fromARGB(255, 24, 150, 144),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  buildWarningNote(),
                  const SizedBox(height: 20),
                  buildNameField(),
                  const SizedBox(height: 10),
                  buildFrequencyField(),
                  const SizedBox(height: 10),
                  buildHungerSituationMenu(),
                  const SizedBox(height: 10),
                  buildSaveButton(),
                ],
              ),
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
            }));
  }

  Widget buildWarningNote() {
    return Center(
        child: Text(
      "Kullanım sıklığı kısmında bildirim almak istediğiniz saatleri açılan seçiciden seçebilir ya da 'İptal'e basarak manuel olarak girebilirsiniz. \n\nEn fazla 3 adet olmak üzere; virgülle ayırarak '08:55, 21:30, 15:22' formatında giriniz.",
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    ));
  }

  Widget buildNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: TextFormField(
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 7, 89, 156)),
            ),
            fillColor: Color.fromARGB(255, 252, 250, 250),
            filled: true,
            labelText: "İlaç Adı: "),
        validator: validateMedicineName,
        controller: txtName,
      ),
    );
  }

  Widget buildFrequencyField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 7, 89, 156)),
              ),
              fillColor: Color.fromARGB(255, 252, 250, 250),
              filled: true,
            ),
            value: selectedPickCount,
            items: pickCountOptions.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Günde $value kere'),
              );
            }).toList(),
            onChanged: (int? value) {
              if (mounted) {
                setState(() {
                  selectedPickCount = value!;
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          child: TextFormField(
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 89, 156)),
                ),
                fillColor: Color.fromARGB(255, 252, 250, 250),
                filled: true,
                labelText: "Kullanım Sıklığı: "),
            controller: txtFrequency,
            validator: validateFrequency,
            onTap: () => _selectTime(context),
          ),
        ),
      ],
    );
  }

  Widget buildHungerSituationMenu() {
    txtHungerSituation.text = hungerValue!;
    return SizedBox(
      height: 50,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 129, 215, 255)), // Set the border color to blue
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: hungerValue,
            elevation: 16,
            onChanged: (String? value) {
              if (mounted) {
                setState(() {
                  txtHungerSituation.text = hungerValue = value!;
                });
              }
            },
            items: hungerList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
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
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 6, vertical: 12)),
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

  DateTime parseTimeString(String timeString) {
    DateFormat format = DateFormat('HH:mm');

    DateTime now = DateTime.now();
    DateTime parsedTime = format.parse(timeString);

    return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  }
}
