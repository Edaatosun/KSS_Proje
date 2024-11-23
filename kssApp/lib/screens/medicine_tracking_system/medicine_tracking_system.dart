// ignore_for_file: use_function_type_syntax_for_parameters, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:project_kss/models/medicine.dart';
import 'package:project_kss/screens/medicine_tracking_system/add_medicine_manually.dart';
import 'package:project_kss/screens/medicine_tracking_system/add_medicine_using_photo.dart';
import 'package:project_kss/helpers/local_db_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/custom_navigation_bar.dart';

class MedicineTrackingSystem extends StatefulWidget {
  const MedicineTrackingSystem({super.key});

  @override
  State<StatefulWidget> createState() {
    return MedicineTrackingSystemState();
  }
}

class MedicineTrackingSystemState extends State<MedicineTrackingSystem> {
  int _currentIndex = 2;
  var localDbHelper = LocalDbHelper();
  List<Medicine>? medicineList;
  int medicineCount = 0;

  @override
  void initState() {
    getMedicine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("İlaç Takip Sistemi"),
          backgroundColor: const Color.fromARGB(255, 24, 150, 144),
        ),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              buildWarningNote(),
              const SizedBox(height: 20),
              buildButtons(),
              const SizedBox(height: 30),
              buildExistingMedicineList(),
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
            }));
  }

  Widget buildWarningNote() {
    return Center(
      child: Text(
        "Lütfen ilacınızın reçeteli fotoğrafını sarı etiket net gözükecek şekilde yükleyin ya da istenen özellikleri aşağıdaki butona dokunarak manuel olarak girin.",
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Manuel Giriş"),
              onPressed: goToAddMedicineManually,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 6, vertical: 12)), // Metin rengi
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
              icon: const Icon(Icons.camera_alt),
              label: const Text("Fotoğraf Yükle"),
              onPressed: goToAddMedicineUsingPhoto,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 6, vertical: 12)),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.8);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.9);
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

  Widget buildExistingMedicineList() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListView.builder(
          itemCount: medicineList?.length ?? 0,
          itemBuilder: (context, index) {
            final currentMedicine = medicineList?[index];
            if (currentMedicine == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
              child: Card(
                color: const Color.fromARGB(255, 160, 225, 255),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    // Handle tap event
                  },
                  child: ListTile(
                    leading: const Icon(
                      Icons.medical_services,
                      color: Color.fromARGB(255, 33, 150, 243),
                    ),
                    title: Text(
                      "${currentMedicine.name}: ${currentMedicine.hungerSituation ?? ''}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      currentMedicine.frequency ?? '',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    trailing: buildDeleteButton(index, currentMedicine.id ?? index),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildDeleteButton(int index, int id) {
    return IconButton(
      icon: const Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),
      onPressed: () async {
        if (mounted) {
          setState(() {
            medicineList!.removeAt(index);
          });
        }
        var result = await localDbHelper.deleteMedicine(id);
        print(result);
      },
    );
  }

  void goToAddMedicineManually() async {
    var addedMedicine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicineManually(),
      ),
    );

    if (addedMedicine != null) {
      getMedicine();
    }
  }

  void goToAddMedicineUsingPhoto() async {
    var addedMedicine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicineUsingPhoto(),
      ),
    );

    if (addedMedicine != null) {
      getMedicine();
    }
  }

  void getMedicine() async {
    var medicineFuture = localDbHelper.getMedicine();
    medicineFuture.then((data) {
      if (mounted) {
        setState(() {
          medicineList = data;
          medicineCount = data.length;
        });
      }
    });
  }
}
//todo: butonlar daha az yukarlak olabilir ikon eklenebilir 
//todo: ilaç kısmı daha büyük durabilir üç nokta eklenicek ikonlar düzenlenicek
//todo: silme butonuna basınca direk silmesin