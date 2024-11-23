// ignore_for_file: avoid_print, unused_import

import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> showNotification(String notificationTitle, String notificationText) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '99', 'Kanuni Sultan Süleyman Eğitim ve Araştırma Hastanesi',
      channelDescription: 'Kanuni Sultan Süleyman Eğitim ve Araştırma Hastanesi',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false);
  const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
    sound: 'default.wav',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

  var randomNumberForId = Random().nextInt(900000) + 100000;

  await flutterLocalNotificationsPlugin
      .show(randomNumberForId, notificationTitle, notificationText, platformChannelSpecifics, payload: 'item x');
}

Future<void> scheduleNotification(DateTime scheduledTime, String notificationTitle, String notificationText) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '00', 'Kanuni Sultan Süleyman Eğitim ve Araştırma Hastanesi',
      channelDescription: 'Kanuni Sultan Süleyman Eğitim ve Araştırma Hastanesi',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false);
  const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
    sound: 'default.wav',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

  var randomNumberForId = Random().nextInt(900000) + 100000;

  tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

  if (scheduledDateTime.isBefore(DateTime.now())) {
    scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
  }

  await flutterLocalNotificationsPlugin.zonedSchedule(
    randomNumberForId,
    notificationTitle,
    notificationText,
    scheduledDateTime,
    platformChannelSpecifics,
    payload: "item x",
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );

  print(scheduledDateTime);
}
