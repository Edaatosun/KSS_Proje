import 'package:flutter/material.dart';
import 'package:project_kss/screens/main_page.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import 'package:project_kss/util/custom_navigation_bar.dart';

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  int currentPage = 0;
  int _currentIndex = 2;
  PageController sayfaKontrol = PageController(initialPage: 0);
  List<Map<String, dynamic>> duyuruListesi = [];
  bool isLoading = true;
  

  @override
  void initState() {
    super.initState();
    _fetchDuyurular();
  }

  void _fetchDuyurular() async {
    final conn = await MySQLHelper.getConnection();

    var results = await conn!.query('SELECT * FROM announcements where class = "0" OR class = "1" ORDER BY id DESC');

    for (var row in results) {
      duyuruListesi.add({
        'title': row[1].toString(),
        'date': row[2].toString(),
        'description': row[3].toString(),
      });
    }

    conn.close();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "DUYURULAR",
        ),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : duyuruListesi.isEmpty
              ? Center(
                  child: AlertDialog(
                    backgroundColor: Colors.red.shade700,
                    title: const Text(
                      "Uyarı",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      "Henüz bir duyuru bulunamadı.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: deviceHeight / 1.3,
                        decoration: BoxDecoration(color: Colors.white70, border: Border.all(color: Colors.blue, width: 2)),
                        child: PageView.builder(
                          controller: sayfaKontrol,
                          onPageChanged: (int page) {
                            setState(() {
                              currentPage = page;
                            });
                          },
                          itemCount: (duyuruListesi.length / 8).ceil(),
                          itemBuilder: (BuildContext context, int index) {
                            return ListView.builder(
                              itemCount: index == (duyuruListesi.length / 8).ceil() - 1 ? duyuruListesi.length % 8 : 8,
                              itemBuilder: (BuildContext context, int innerIndex) {
                                int cardIndex = index * 8 + innerIndex;
                                if (cardIndex < duyuruListesi.length) {
                                  return duyuruCard(duyuruListesi[cardIndex]);
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(7),
                        height: deviceHeight / 22,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: (duyuruListesi.length / 8).ceil(),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                sayfaKontrol.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                              },
                              child: Container(
                                width: deviceWidth/5,
                                color: currentPage == index ? Colors.blue : Colors.grey,
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
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

  Widget duyuruCard(Map<String, dynamic> duyuru) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.blue.shade300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.redAccent,
              ),
              child: SizedBox(
                width: deviceWidth/4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          duyuru['date'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          title: Text(
            duyuru['title'],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        children: <Widget>[
          ListTile(
            subtitle: Text(
              duyuru['description'],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
