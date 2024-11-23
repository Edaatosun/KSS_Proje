class Policlinic {
  late String name;
  late String imagePath;
  late int id;

  Policlinic(int id, String name, String imagePath) {
    this.id = id;
    this.name = name;
    this.imagePath = imagePath;
  }
  Policlinic.withoutId(String name, String imagePath) {
    this.name = name;
    this.imagePath = imagePath;
  }
}
