class IconObject {
  late String imagePath;
  late String title;
  late int number;

  IconObject(this.imagePath, this.title, this.number) {}

  String get getImagePath {
    return imagePath;
  }

  set setImagePath(String imagePath) {
    this.imagePath = imagePath;
  }

  String get getTitle {
    return title;
  }

  set setTitle(String title) {
    this.title = title;
  }

  int get getNumber {
    return number;
  }

  set setNumber(int number) {
    this.number = number;
  }
}
