// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../../helpers/mysql_helper.dart';
import '../../helpers/warning_dialog_helper.dart';
import '../../util/custom_navigation_bar.dart';

class PharmacyOnDutyV3 extends StatefulWidget {
  const PharmacyOnDutyV3({super.key});

  @override
  _PharmacyOnDutyV3State createState() => _PharmacyOnDutyV3State();
}

class _PharmacyOnDutyV3State extends State<PharmacyOnDutyV3> {
  MySqlConnection? connection;
  String _responseText = '';

  String? city;
  String? district;
  var txtCity = TextEditingController();
  var txtDistrict = TextEditingController();
  List<String> cities = [];
  List<String> districts = [];

  int _currentIndex = 0;

  @override
  void initState() {
    _connectToDatabase();
    _currentIndex = 0;
    fetchCitiesFromDatabase();
    super.initState();
  }

  @override
  void dispose() {
    if (connection != null) {
      connection!.close();
    }
    super.dispose();
  }

  Future<void> fetchData() async {
    if (city == null || district == null) {
      showWarningDialog(context, "İl veya ilçe boş olamaz!", "Lütfen yukarıdaki kutulardan il ve ilçe seçiniz.");
      return;
    }

    try {
      List<Map<String, String?>>? pharmacies = await MySQLHelper.getPharmacies(connection!, city!, district!);
      String formattedText = '';

      if (pharmacies == null || pharmacies.isEmpty) {
        showWarningDialog(
            context, "Nöbetçi Eczane Tararken Hata!", "$city, $district ilçesinde ait nöbetçi eczane bulunamadı. Daha sonra tekrar deneyiniz.");
        return;
      }

      for (int i = 0; i < pharmacies.length; i++) {
        final pharmacy = pharmacies[i];
        if (pharmacy['sub_address'] != null && pharmacy['sub_address']!.isNotEmpty) {
          formattedText += 'Eczane ${i + 1}:\n'
              'İsim: ${pharmacy['name']}\n'
              'Adres: ${pharmacy['address']}\n'
              'Tarif: ${pharmacy['sub_address']}\n'
              'Telefon: ${pharmacy['phone']}\n\n';
        } else {
          formattedText += 'Eczane ${i + 1}:\n'
              'İsim: ${pharmacy['name']}\n'
              'Adres: ${pharmacy['address']}\n'
              'Telefon: ${pharmacy['phone']}\n\n';
        }
      }

      setState(() {
        _responseText = formattedText;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nöbetçi Eczaneler v3'),
        ),
        body: buildBody(),
        bottomNavigationBar: buildNavigationBar());
  }

  Widget buildBody() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          buildCityDropdown(),
          buildDistrictDropdown(),
          buildFetchButton(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _responseText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCityDropdown() {
    return DropdownButton<String>(
      value: city,
      hint: const Text("İl seçiniz"),
      onChanged: (String? newValue) {
        if (mounted) {
          setState(() {
            city = newValue!;
            fetchDistrictsFromDatabase(city!);
          });
        }
      },
      items: cities.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildDistrictDropdown() {
    return DropdownButton<String>(
      value: district,
      hint: const Text("İlçe seçiniz"),
      onChanged: (String? newValue) {
        setState(() {
          district = newValue!;
        });
      },
      items: districts.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildFetchButton() {
    return ElevatedButton(
      onPressed: fetchData,
      child: const Text('Nöbetçi eczaneleri görüntüle.'),
    );
  }

  CustomBottomNavigationBar buildNavigationBar() {
    return CustomBottomNavigationBar(
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
        });
  }

  Future<void> _connectToDatabase() async {
    connection = await MySQLHelper.getConnection();
  }

  Future<void> fetchCitiesFromDatabase() async {
    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (connection == null) {
        showWarningDialog(
            context, "Database Bağlantı Hatası!", "Database'e bağlanırken sistemsel bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.");
        return;
      }

      List<String>? fetchedCities = await MySQLHelper.getCities(connection!);

      if (fetchedCities != null) {
        if (mounted) {
          setState(() {
            cities = fetchedCities;
            city = cities.isNotEmpty ? cities[0] : null;
          });
        }
      }
    });
  }

  Future<void> fetchDistrictsFromDatabase(String city) async {
    Future.delayed(const Duration(milliseconds: 200), () async {
      if (connection == null) {
        showWarningDialog(
            context, "Database Bağlantı Hatası!", "Database'e bağlanırken sistemsel bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.");
        return;
      }

      List<String>? fetchedDistricts = await MySQLHelper.getDistricts(connection!, city);

      if (fetchedDistricts != null) {
        if (mounted) {
          setState(() {
            districts = fetchedDistricts;
            district = districts.isNotEmpty ? districts[0] : null;
          });
        }
      }
    });
  }
}
