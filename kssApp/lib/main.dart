// ignore_for_file: avoid_print, unused_import

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project_kss/api/firebase_api.dart';
import 'package:project_kss/firebase_options.dart';
import 'package:project_kss/screens/loading_screen.dart';
import 'package:project_kss/screens/main_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_kss/screens/nurse_calling_system/nurse_calling_system.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> initNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  try {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } catch (e) {
    print('Error initializing notifications: $e');
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'kssapp-28050',
  );
  await FirebaseApi().initNotifications();
  tz.initializeTimeZones();
  await initNotifications();
  createNotificationChannel();

  runApp(const MainApp());
}

void createNotificationChannel() async {
  if (Platform.isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_to_solve_firebase_notification_problem',
      'Firebase Notification Channel',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'channel_to_solve_firebase_notification_problem',
                'Firebase Notification Channel',
                channelDescription: 'This channel is used for important notifications.',
                importance: Importance.high,
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState?.pushNamed('/nurseCallingSystem');
    });

    return MaterialApp(
      home: const LoadingScreen(),
      navigatorKey: navigatorKey,
      routes: {
        '/nurseCallingSystem': (context) => const NurseCallingSystem(),
      },
    );
  }
}
