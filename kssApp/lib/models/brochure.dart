class Brosur {
  late int id;
  late String brosurIsmi;
  late String url;
  late String poliklinik;
  late DateTime tarih;

  Brosur.wihtoutInfo() {}

  Brosur(int id, String brosurIsmi, String url, String poliklinik,
      DateTime tarih) {
    this.id = id;
    this.brosurIsmi = brosurIsmi;
    this.url = url;
    this.poliklinik = poliklinik;
    this.tarih = tarih;
  }
  String get getbrosurIsmi {
    return brosurIsmi;
  }

  set setName(String brosurIsmi) {
    this.brosurIsmi = brosurIsmi;
  }

  String get getUrl {
    return url;
  }

  set setUrl(String url) {
    this.url = url;
  }

  String get getPoliklinik {
    return poliklinik;
  }

  set setDepartment(String poliklinik) {
    this.poliklinik = poliklinik;
  }
}
