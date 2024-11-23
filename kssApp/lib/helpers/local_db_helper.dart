import "package:project_kss/models/medicine.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

class LocalDbHelper {
  Database? _db;

  Future<Database?> get db async {
    _db ??= await initializeDb();
    return _db;
  }

  Future<Database?> initializeDb() async {
    var dbFolder = await getDatabasesPath();
    var path = join(dbFolder, "medicine.db");
    var db = await openDatabase(path, version: 3, onCreate: createDb);
    return db;
  }

  void createDb(Database db, int version) async {
    await db.execute("CREATE TABLE medicine(id INTEGER PRIMARY KEY, name TEXT, frequency TEXT, hungerSituation TEXT)");
    await db.execute(
        "CREATE TABLE queue_number(id INTEGER PRIMARY KEY, queue_number INTEGER NOT NULL, room_name TEXT NOT NULL UNIQUE CHECK(room_name IN ('YesilAlan1','YesilAlan2','YesilAlan3','CocukAcil')))");
  }

  Future<List<Medicine>> getMedicine() async {
    Database? db = await this.db;
    if (db == null) {
      return [];
    }
    var result = await db.query("medicine");
    if (result.isEmpty) {
      return [];
    }
    return List.generate(result.length, (i) {
      return Medicine.fromObject(result[i]);
    });
  }

  Future<int> insertMedicine(Medicine medicine) async {
    Database? db = await this.db;
    if (db == null) {
      return -1;
    }
    Map<String, dynamic>? medicineMap = medicine.toMap();
    if (medicineMap == null) {
      return -1;
    }
    var result = await db.insert("medicine", medicineMap);
    return result;
  }

  Future<int> deleteMedicine(int id) async {
    Database? db = await this.db;
    if (db == null) {
      return -1;
    }
    var result = await db.rawDelete("DELETE FROM medicine WHERE id = $id");
    return result;
  }

  Future<int> updateMedicine(Medicine medicine) async {
    Database? db = await this.db;
    if (db == null) {
      return -1;
    }
    var result = await db.update("medicine", medicine.toMap()!, where: "id = ?", whereArgs: [medicine.id]);
    return result;
  }

  // *************************************************************

  Future<int> insertQueueNumber(int queueNumber, String roomName) async {
    Database? db = await this.db;
    if (db == null) {
      return -1;
    }
    var result = await db.rawInsert("INSERT INTO queue_number(queue_number, room_name) VALUES(?, ?)", [queueNumber, roomName]);
    return result;
  }

  Future<int> deleteQueueNumber(int id) async {
    Database? db = await this.db;
    if (db == null) {
      return -1;
    }
    var result = await db.rawDelete("DELETE FROM queue_number WHERE id = $id");
    return result;
  }

  Future<int> updateQueueNumber(int queueNumber, String roomName) async {
    Database? db = await this.db;
    if (db == null) {
      return -1;
    }
    var result = await db.rawUpdate("UPDATE queue_number SET queue_number = ? WHERE room_name = ?", [queueNumber, roomName]);
    return result;
  }

  Future<int> getQueueNumberByRoom(String roomName) async {
    Database? db = await this.db;
    if (db == null) {
      return -1;
    }
    var result = await db.rawQuery("SELECT queue_number FROM queue_number WHERE room_name = ?", [roomName]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<bool> doesQueueNumberExist(String roomName) async {
    Database? db = await this.db;
    if (db == null) {
      return false;
    }
    var result = await db.rawQuery("SELECT COUNT(*) FROM queue_number WHERE room_name = ?", [roomName]);
    var count = Sqflite.firstIntValue(result);
    return count != null && count > 0;
  }
}
