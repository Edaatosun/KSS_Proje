// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql1/mysql1.dart';

class MySQLHelper {
  static String host = dotenv.env['DB_HOST']!;
  static int port = int.parse(dotenv.env['DB_PORT']!);
  static String user = dotenv.env['DB_USER']!;
  static String password = dotenv.env['DB_PASSWORD']!;
  static String db = dotenv.env['DB_NAME']!;

  static Future<MySqlConnection?> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );

    try {
      return await MySqlConnection.connect(settings);
    } catch (e) {
      print('Failed to connect to the database: $e');
      return null;
    }
  }

  //queue_tracking_system
  static Future<int> getQueueNumber(MySqlConnection connection, String name) async {
    var result = await connection.query('SELECT queue_number FROM queue_images WHERE name = ?', [name]);
    if (result.isNotEmpty) {
      return result.first.fields['queue_number'];
    }
    return -1;
  }

  //nurse_calling_system
  static Future<int> markNurseCalled(MySqlConnection connection, String inputNurseCode) async {
    try {
      var nurseExists = await connection.query(
        'SELECT * FROM nurses WHERE nurse_code = ?',
        [inputNurseCode],
      );

      var result = await connection.query(
        'UPDATE nurses SET is_called = true WHERE nurse_code = ? AND is_called = false',
        [inputNurseCode],
      );

      if (result.affectedRows == 0 && nurseExists.isEmpty) {
        print('$inputNurseCode koduyla hemşire bulunamadı.');
        return 404;
      } else if (result.affectedRows == 0 && nurseExists.isNotEmpty) {
        print('$inputNurseCode kodlu hemşire zaten çağırıldı.');
        return 204;
      } else {
        print('$inputNurseCode kodlu hemşire çağırıldı.');
        return 200;
      }
    } catch (e) {
      print('Hemşire çağırırken hata: $e');
      return 500;
    }
  }

  //nurse_calling_system
  static Future<int> markNurseUncalled(MySqlConnection connection, String inputNurseCode) async {
    try {
      var nurseExists = await connection.query(
        'SELECT * FROM nurses WHERE nurse_code = ?',
        [inputNurseCode],
      );

      var result = await connection.query(
        'UPDATE nurses SET is_called = false WHERE nurse_code = ? AND is_called = true',
        [inputNurseCode],
      );

      if (result.affectedRows == 0 && nurseExists.isEmpty) {
        print('$inputNurseCode koduyla hemşire bulunamadı.');
        return 404;
      } else if (result.affectedRows == 0 && nurseExists.isNotEmpty) {
        print('$inputNurseCode kodlu hemşire çağrısı bulunamadı.');
        return 204;
      } else {
        print('$inputNurseCode kodlu hemşirenin çağrısı iptal edildi.');
        return 200;
      }
    } catch (e) {
      print('Hemşire çağırırken hata: $e');
      return 500;
    }
  }

  //nurse calling system
  static Future<int?> getRoomByMacAddress(MySqlConnection connection, String macAddress) async {
    try {
      var result = await connection.query(
        'SELECT room FROM bt_devices WHERE mac_address = ?',
        [macAddress],
      );

      if (result.isNotEmpty) {
        return int.parse(result.first.fields['room']);
      } else {
        print('Mac adresiyle bağlantılı oda bulunamadı: $macAddress');
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  //pharmacy v2, v3
  static Future<List<String>?> getCities(MySqlConnection connection) async {
    try {
      var result = await connection.query('SELECT name FROM cities');

      if (result.isNotEmpty) {
        List<String> cities = [];
        for (var row in result) {
          cities.add(row['name'] as String);
        }
        return cities;
      } else {
        print("Database'de şehir bulunamadı!");
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  //pharmacy v2, v3
  static Future<List<String>?> getDistricts(MySqlConnection connection, String city) async {
    try {
      var result = await connection.query('SELECT district FROM districts WHERE city = ? ORDER BY district', [city]);

      if (result.isNotEmpty) {
        List<String> districts = [];
        for (var row in result) {
          districts.add(row['district'] as String);
        }
        return districts;
      } else {
        print("Bu şehire ait ilçe bulunamadı!");
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  //pharmacy v3
  static Future<List<Map<String, String?>>?> getPharmacies(MySqlConnection connection, String city, String district) async {
    try {
      var result = await connection.query(
          'SELECT name, address, phone, sub_address, location_x, location_y FROM pharmacies WHERE city = ? AND district = ? ORDER BY name',
          [city, district]);

      if (result.isNotEmpty) {
        List<Map<String, String?>> pharmacies = [];
        for (var row in result) {
          pharmacies.add({
            'name': row['name'] as String,
            'address': row['address'] as String,
            'phone': row['phone'] as String,
            'sub_address': row['sub_address'] != null ? row['sub_address'] as String : null,
            'location_x': row['location_x'] != null ? row['location_x'] as String : null,
            'location_y': row['location_y'] != null ? row['location_y'] as String : null,
          });
        }
        return pharmacies;
      } else {
        print("Bu şehir ve ilçeye ait eczane bulunamadı!");
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  //firebase fcm tokens
  static Future<void> insertTokenAndTimestamp(MySqlConnection connection, String token, DateTime timestamp) async {
    try {
      var result = await connection.query(
        'INSERT INTO fcm_tokens (token, last_activity_timestamp) VALUES (?, ?)',
        [token, timestamp.toUtc()],
      );

      if (result.affectedRows != 1) {
        print('Failed to insert token: $token');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //firebase fcm tokens
  static Future<void> updateTokenTimestamp(MySqlConnection connection, String token, DateTime timestamp) async {
    try {
      await connection.query(
        'UPDATE fcm_tokens SET last_activity_timestamp = ? WHERE token = ?',
        [timestamp.toUtc(), token],
      );
    } catch (e) {
      print('Error updating token timestamp: $e');
    }
  }

  //firebase fcm tokens
  static Future<List<String>> getAllTokensFromDatabase(MySqlConnection connection) async {
    try {
      Results results = await connection.query('SELECT token FROM fcm_tokens');

      List<String> tokens = [];
      for (var row in results) {
        tokens.add(row[0] as String);
      }

      return tokens;
    } catch (e) {
      print('Error getting all tokens from db: $e');
      return [];
    }
  }
}
