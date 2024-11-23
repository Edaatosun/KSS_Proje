// ignore_for_file: use_function_type_syntax_for_parameters, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project_kss/api/firebase_api.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import 'package:project_kss/helpers/warning_dialog_helper.dart';
import 'package:project_kss/validation/nurse_code_validation.dart';

import '../../util/custom_navigation_bar.dart';

class NurseCallingSystem extends StatefulWidget {
  const NurseCallingSystem({super.key});

  @override
  State<StatefulWidget> createState() {
    return NurseCallingSystemState();
  }
}

class NurseCallingSystemState extends State<NurseCallingSystem> with NurseCodeValidationMixin {
  int _currentIndex = 2;
  var formKey = GlobalKey<FormState>();
  var txtNurseCode = TextEditingController();

  MySqlConnection? connection;

  @override
  void initState() {
    _connectToDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hemşire Çağrı Sistemi"),
          backgroundColor: const Color.fromARGB(255, 24, 150, 144),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                buildWarningNote(),
                const SizedBox(height: 30),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildNurseCodeField(),
                        const SizedBox(height: 20),
                        buildCallButton(),
                        const SizedBox(height: 25),
                        buildCancelButton(),
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
            }));
  }

  Widget buildWarningNote() {
    return const Center(
      child: Text(
        "Lütfen bu sistemi acil durumlar dışında kullanmayınız. Aşağıya hemşireden aldığınız kodu girip butona basarak hemşire çağırabilirsiniz.",
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }

  Widget buildNurseCodeField() {
    return TextFormField(
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 129, 215, 255))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 7, 89, 156)),
          ),
          fillColor: Color.fromARGB(255, 252, 250, 250),
          filled: true,
          labelText: "Hemşire Kodu: ",
          hintText: "Hemşirenizin size verdiği 6 karakterli kod."),
      validator: validateNurseCode,
      controller: txtNurseCode,
    );
  }

  Widget buildCallButton() {
    return ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState?.save();
            callNurse();
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 230, 8, 8)),
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 15, vertical: 30)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        child: const Text(
          'Hemşire Çağır',
          style: TextStyle(
            color: Colors.white,
          ),
        ));
  }

  Widget buildCancelButton() {
    return ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState?.save();
            cancelNurseCall();
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 230, 8, 8)),
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 15, vertical: 30)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        child: const Text(
          'Hemşire Çağrısını İptal Et',
          style: TextStyle(
            color: Colors.white,
          ),
        ));
  }

  Future<void> _connectToDatabase() async {
    connection = await MySQLHelper.getConnection();
  }

  Future<void> callNurse() async {
    if (connection == null) {
      showWarningDialog(
          context, "Database Bağlantı Hatası!", "Database'e bağlanırken sistemsel bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.");
      return;
    }

    int nurseResult = await MySQLHelper.markNurseCalled(connection!, txtNurseCode.text);
    //TODO: burada odayı scan edip macAddress'i otomatik bulmalı, statik kalmayacak
    int? roomResult = await MySQLHelper.getRoomByMacAddress(connection!, "7C:B9:4C:1D:7A:8A");

    if (nurseResult == 200 && roomResult != null) {
      //TODO: buradaki patient topic'i nurse olarak değiştirilecek, sonuçta hasta değil hemşire çağırılacak
      FirebaseApi.sendNotificationToTokens("$roomResult odasından çağrılıyorsunuz!", "$roomResult odasından bekleniyorsunuz.", "patient");
      showWarningDialog(context, "Hemşire Çağrıldı!", "Hemşireniz $roomResult numaralı odaya çağrıldı. Lütfen bekleyiniz.");
    } else if (nurseResult == 204 && roomResult != null) {
      FirebaseApi.sendNotificationToTokens("$roomResult odasından çağrılıyorsunuz!", "$roomResult odasından bekleniyorsunuz.", "patient");
      showWarningDialog(context, "Hemşire Zaten Çağrıldı!", "$roomResult numaralı odaya hemşire zaten çağrıldı. Lütfen bekleyiniz.");
    } else if (nurseResult == 404 && roomResult != null) {
      showWarningDialog(context, "Hemşire Bulunamadı!", "Girdiğiniz kod ile eşleşen bir hemşire bulunamadı.");
    } else if (roomResult == null) {
      showWarningDialog(context, "Hata!", "Oda bulunamadı!");
      return;
    } else {
      showWarningDialog(context, "Sistemsel Hata!", "Sistemsel bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.");
    }
  }

  Future<void> cancelNurseCall() async {
    if (connection == null) {
      showWarningDialog(
          context, "Database Bağlantı Hatası!", "Database'e bağlanırken sistemsel bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.");
      return;
    }

    int nurseResult = await MySQLHelper.markNurseUncalled(connection!, txtNurseCode.text);
    //TODO: burada odayı scan edip macAddress'i otomatik bulmalı, statik kalmayacak
    int? roomResult = await MySQLHelper.getRoomByMacAddress(connection!, "7C:B9:4C:1D:7A:8A");

    if (nurseResult == 200 && roomResult != null) {
      FirebaseApi.sendNotificationToTokens("$roomResult Odasına Çağrı İptali!", "$roomResult odası çağrısını iptal etti.", "patient");
      showWarningDialog(context, "Başarılı!", "Hemşire çağrısı başarıyla iptal edildi.");
    } else if (nurseResult == 204 && roomResult != null) {
      showWarningDialog(context, "Hemşire Çağrısı Bulunamadı!", "$roomResult numaralı odaya hemşire çağrısı bulunamadı.");
    } else if (nurseResult == 404 && roomResult != null) {
      showWarningDialog(context, "Hemşire Bulunamadı!", "Girdiğiniz kod ile eşleşen bir hemşire bulunamadı.");
    } else if (roomResult == null) {
      showWarningDialog(context, "Hata!", "Oda bulunamadı!");
      return;
    } else {
      showWarningDialog(context, "Sistemsel Hata!", "Sistemsel bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.");
    }
  }
}
