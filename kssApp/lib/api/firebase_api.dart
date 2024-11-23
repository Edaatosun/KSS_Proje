// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project_kss/helpers/mysql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_kss/main.dart';
import 'package:http/http.dart' as http;

//TODO: bildirime tıklayınca uygulama açılsın, oluyorsa hemşire çağrı sistemi

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static MySqlConnection? connection;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    String? fCMToken = await getTokenLocally();
    connection = await MySQLHelper.getConnection();

    if (fCMToken == null) {
      fCMToken = await _firebaseMessaging.getToken();
      await MySQLHelper.insertTokenAndTimestamp(connection!, fCMToken!, DateTime.now());
      await saveTokenLocally(fCMToken);
    } else {
      await MySQLHelper.updateTokenTimestamp(connection!, fCMToken, DateTime.now());
    }

    await FirebaseMessaging.instance.subscribeToTopic("patient");
    print('Token: $fCMToken');
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed("/notification_screen", arguments: message);
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> saveTokenLocally(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token ?? '');
  }

  Future<String?> getTokenLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  static Future<void> sendNotificationToTokens(String notificationTitle, String notificationBody, String topic) async {
    connection = await MySQLHelper.getConnection();
    List<String> tokens = await MySQLHelper.getAllTokensFromDatabase(connection!);
    final dbRef = FirebaseDatabase.instance.refFromURL("https://kssapp-28050-default-rtdb.europe-west1.firebasedatabase.app");
    final tokenSnapshot = await dbRef.child('accessToken').once();
    final accessToken = tokenSnapshot.snapshot.children.first.value;

    // for (String token in tokens) {
    //   //! artık toplu token girilmiyormuş, tüm tokenleri dönüp tek tek bildirim gönderiyor. Kullanıcı çoğaldıkça sistemi yorma miktarı uçacak
    //   var message = {
    //     'message': {
    //       // 'topic': 'patient',
    //       'token': token,
    //       'notification': {
    //         'title': notificationTitle,
    //         'body': notificationBody,
    //       },
    //       'android': {
    //         'notification': {
    //           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    //           'image':
    //               'https://www.gstatic.com/devrel-devsite/prod/v7ec1cdbf90989ab082f30bf9b9cbe627804848c18b70d722062aeb6c6d8958b5/firebase/images/lockup.svg'
    //         }
    //       },
    //       'data': {'status': 'done'}
    //     }
    //   };

    //   final response = await http.post(
    //     Uri.parse('https://fcm.googleapis.com/v1/projects/kssapp-28050/messages:send'),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json',
    //       // 'Authorization': 'Bearer $accessToken',
    //       'Authorization':
    //           'Bearer ya29.c.c0AY_VpZg0Hpdvd9yd8XnjN-1bnL7BMat5_UvslUA-nOR5gFNmE4Tr4ytYNtPli7USqfFaQ4-iFnXvSyQVDVweLpcakZ7Uko8RZ6O89PHSdsvnqRIUlb5fn12yTd8SD67t5OtRGS-t6CL-B4SXKluG__eW2XasvbVm3kEet2kxbOplSZRu01BdV1m-DD-_xR4GgToay386JlNWQAy497YHGj5jmtky3MoghekOPXtdvYtMIzyTx-YuV4GYnzNgvPvH61xNT7OPQaRuLh58IJgg4arXkG_ixi3h5Hv29QQy9c08F96F9ZLQiT6-NhwehVaq0cPRdU-ILdzY59F2mAXwlSKVapMvju5mBTmzqfhjuuhf8KuvF9rz7YwYL385C4iQMUM3lh0gmBnxz7RspIX8dv0I16fZsqjha9k9olu2vorl7ykSliWi64xY_6OJZfvZWZ6IVds0Z-XeRkqF0v8vqYa3X46nikX54xt_kyjvh83BdBwYQ1_vkjB4amQjrgtbBjfywzoJuqZk2aQtZd9BevBckB9_aa2uxyS_reppXvJfxiuxxmdbafWWRzuBlqxWFBO6rI7dBu8ZiQXdWqU19FuoBmbqXsYkutB5ag7JyMM8IFxcpZjqzq5fsZJc3wzcwi1yuhRcofvuhJZ8F4yhQygr_XmimBeUeMMdp--qmz8Vu0X11ytoo85yhrU6um1WoU4_yoyobh1u9W0hzify0rUSkO6XZ_1ZshiRIsVjauuBSzmzvcl8Y0fY-c8vtmsnemcWw7UIvxgk0wRF9cg7Oes21af00F_v39n78bxmsYRceJfuckhQQRgv23e0leBJryxwdnMjBeap4Ozr1kxkl6S1Yk1lza8dMXVm4UdUkkSq7xVZ1_JdhV3bzIFfhUZy41sxjuS3BYy1WdrVuhfvuIOaqOQSizS8yXckvp_Z02WrV2yJ8IQ8-Iv5UuSxF92rSdsn7rwhF4Zro9f-SzzoX0v6MRkX3y-QaU6W8u3bm2aqX2UkWxJOch2'
    //     },
    //     body: jsonEncode(message),
    //   );
    //   if (response.statusCode == 200) {
    //     print('Notification sent successfully');
    //   } else {
    //     print('Failed to send notification. Error: ${response.reasonPhrase}');
    //     debugPrint(response.body);
    //   }
    // }

    var message = {
      'message': {
        'topic': topic,
        'notification': {
          'title': notificationTitle,
          'body': notificationBody,
        },
        'android': {
          'notification': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'image':
                'https://www.gstatic.com/devrel-devsite/prod/v7ec1cdbf90989ab082f30bf9b9cbe627804848c18b70d722062aeb6c6d8958b5/firebase/images/lockup.svg'
          }
        },
        'data': {'status': 'done'}
      }
    };

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/kssapp-28050/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.reasonPhrase}');
      debugPrint(response.body);
    }
  }
}
