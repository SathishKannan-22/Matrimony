// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA2sxgxn8WPO7tKK_7BLE9k0ECVzKqM0eI',
    appId: '1:3720579327:web:ae5d565730622c26c524ca',
    messagingSenderId: '3720579327',
    projectId: 'matrimony-96278',
    authDomain: 'matrimony-96278.firebaseapp.com',
    storageBucket: 'matrimony-96278.appspot.com',
    measurementId: 'G-EKQM4L6CBR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKBmDLlezTcawOBX8P7VCg4KZJAGu6mIA',
    appId: '1:3720579327:android:13c42e53ff447e0ac524ca',
    messagingSenderId: '3720579327',
    projectId: 'matrimony-96278',
    storageBucket: 'matrimony-96278.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgtyuJg4W0HM0iaw0Q-mWWqjn4uWPut8M',
    appId: '1:3720579327:ios:3209a042e41597e1c524ca',
    messagingSenderId: '3720579327',
    projectId: 'matrimony-96278',
    storageBucket: 'matrimony-96278.appspot.com',
    iosBundleId: 'com.example.matrimony',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCgtyuJg4W0HM0iaw0Q-mWWqjn4uWPut8M',
    appId: '1:3720579327:ios:3209a042e41597e1c524ca',
    messagingSenderId: '3720579327',
    projectId: 'matrimony-96278',
    storageBucket: 'matrimony-96278.appspot.com',
    iosBundleId: 'com.example.matrimony',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA2sxgxn8WPO7tKK_7BLE9k0ECVzKqM0eI',
    appId: '1:3720579327:web:0a6fb703fe72d476c524ca',
    messagingSenderId: '3720579327',
    projectId: 'matrimony-96278',
    authDomain: 'matrimony-96278.firebaseapp.com',
    storageBucket: 'matrimony-96278.appspot.com',
    measurementId: 'G-FPKMNRLKQ7',
  );

}