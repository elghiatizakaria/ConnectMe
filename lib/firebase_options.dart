// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAryCflDgHlbWCKzmWmXdX3b_gTO_JwbKU',
    appId: '1:941593465249:web:ea0f13052cb4209c493be0',
    messagingSenderId: '941593465249',
    projectId: 'wechat-32170',
    authDomain: 'wechat-32170.firebaseapp.com',
    storageBucket: 'wechat-32170.appspot.com',
    measurementId: 'G-DSSN5WDSG5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAkBiOsb98xivk1uMmCNd_qTQ_3QiJJ0M',
    appId: '1:941593465249:android:13bce707fedaf1c4493be0',
    messagingSenderId: '941593465249',
    projectId: 'wechat-32170',
    storageBucket: 'wechat-32170.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAh3ITp9wZgX__qD-kWH0b49UE9Jq-T1HE',
    appId: '1:941593465249:ios:e9b315af3df441fa493be0',
    messagingSenderId: '941593465249',
    projectId: 'wechat-32170',
    storageBucket: 'wechat-32170.appspot.com',
    androidClientId: '941593465249-9erj7rjsov66j2bvm15p5m6509nrvnn4.apps.googleusercontent.com',
    iosClientId: '941593465249-g4gn8e52u0l28bdgd3k70akaujg54fu8.apps.googleusercontent.com',
    iosBundleId: 'com.example.weChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAh3ITp9wZgX__qD-kWH0b49UE9Jq-T1HE',
    appId: '1:941593465249:ios:3b3d6d6283656212493be0',
    messagingSenderId: '941593465249',
    projectId: 'wechat-32170',
    storageBucket: 'wechat-32170.appspot.com',
    androidClientId: '941593465249-9erj7rjsov66j2bvm15p5m6509nrvnn4.apps.googleusercontent.com',
    iosClientId: '941593465249-h97mnargpb3ldbqsqujg6l5urov7hrr5.apps.googleusercontent.com',
    iosBundleId: 'com.example.weChat.RunnerTests',
  );
}
