// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4s9s7rsliPII1O6Z1NrYs-i7zDOfFHEY',
    appId: '1:269568866221:android:7671ef633893591167d324',
    messagingSenderId: '269568866221',
    projectId: 'kssapp-28050',
    databaseURL: 'https://kssapp-28050-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'kssapp-28050.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCh8-sBLaO6KQJG81CI0QbESIlyQNGcwo8',
    appId: '1:269568866221:ios:57e0682cabb98a3067d324',
    messagingSenderId: '269568866221',
    projectId: 'kssapp-28050',
    databaseURL: 'https://kssapp-28050-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'kssapp-28050.appspot.com',
    iosBundleId: 'com.example.iF1ngHateFlutter',
  );

}