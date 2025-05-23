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
    apiKey: 'AIzaSyCItpSrEJuDlVTQA2PClM1EHY4d0OXq4A4',
    appId: '1:1067162591149:web:d856408785cf6bc518cb24',
    messagingSenderId: '1067162591149',
    projectId: 'global-talk-a199b',
    authDomain: 'global-talk-a199b.firebaseapp.com',
    storageBucket: 'global-talk-a199b.appspot.com',
    measurementId: 'G-1X9QWH47S1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBG8NwSKR6m-BMny7HMqIkcrlnt2clrmck',
    appId: '1:1067162591149:android:1272c34acc73c21418cb24',
    messagingSenderId: '1067162591149',
    projectId: 'global-talk-a199b',
    storageBucket: 'global-talk-a199b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsD9l6-_EX_-50mNRBxc4siACVtc4S19M',
    appId: '1:1067162591149:ios:f2adf8418cd2f8eb18cb24',
    messagingSenderId: '1067162591149',
    projectId: 'global-talk-a199b',
    storageBucket: 'global-talk-a199b.appspot.com',
    iosBundleId: 'com.example.globalTalkApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsD9l6-_EX_-50mNRBxc4siACVtc4S19M',
    appId: '1:1067162591149:ios:f2adf8418cd2f8eb18cb24',
    messagingSenderId: '1067162591149',
    projectId: 'global-talk-a199b',
    storageBucket: 'global-talk-a199b.appspot.com',
    iosBundleId: 'com.example.globalTalkApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCItpSrEJuDlVTQA2PClM1EHY4d0OXq4A4',
    appId: '1:1067162591149:web:aa32eaa5ad8b7f2e18cb24',
    messagingSenderId: '1067162591149',
    projectId: 'global-talk-a199b',
    authDomain: 'global-talk-a199b.firebaseapp.com',
    storageBucket: 'global-talk-a199b.appspot.com',
    measurementId: 'G-XYFXYEK6FP',
  );
}
