import 'package:flutter/material.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import '../../util/custom_navigation_bar.dart';

class DoctorsInfo extends StatefulWidget {
  const DoctorsInfo({Key? key}) : super(key: key);

  @override
  State<DoctorsInfo> createState() => _DoctorsInfoState();
}

class _DoctorsInfoState extends State<DoctorsInfo> {
  List<Map<String, dynamic>> doctors = [];
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final conn = await MySQLHelper.getConnection();
    var results = await conn!.query('SELECT * FROM doctors ORDER BY id DESC');

    for (var row in results) {
      doctors.add({
        'name': row[1].toString(),
        'department': row[7].toString(),
        'image_path': row[8].toString(),
      });
    }

    conn.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.arrow_back, color: Colors.blue.shade900),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 24, 150, 144),
        title: const Text(
          "Doktorlarımız",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Bold",
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 200 / 410,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: doctors.map((doctor) => doctorCard(doctor)).toList(),
            ),
          ),
        ],
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
}

Container doctorCard(Map<String, dynamic> doktor) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue[100],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              doktor['image_path'],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Icon(
              Icons.local_hospital,
              color: Colors.blue.shade900,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              doktor['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue.shade900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              doktor['department'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
