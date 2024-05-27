// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members, unreachable_switch_case
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
      case TargetPlatform.windows:
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

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCebbYF6Rh09p2X71aZAAta2yku81HZyco',
    appId: '1:188375719694:web:625c62e62e35be0282815f',
    messagingSenderId: '188375719694',
    projectId: 'app-house-d0ac1',
    authDomain: 'app-house-d0ac1.firebaseapp.com',
    storageBucket: 'app-house-d0ac1.appspot.com',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCebbYF6Rh09p2X71aZAAta2yku81HZyco',
    appId: '1:188375719694:web:625c62e62e35be0282815f',
    messagingSenderId: '188375719694',
    projectId: 'app-house-d0ac1',
    authDomain: 'app-house-d0ac1.firebaseapp.com',
    storageBucket: 'app-house-d0ac1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAJmbHAGNhx_UoGP9qe5C9l8ZtH4qe0pBc',
    appId: '1:188375719694:android:0a9b81ed47c44ea182815f',
    messagingSenderId: '188375719694',
    projectId: 'app-house-d0ac1',
    storageBucket: 'app-house-d0ac1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPfjsPEfBHUDm3tfaopLwQc4mEcnBieAM',
    appId: '1:188375719694:ios:7b378c4cd5fbabbc82815f',
    messagingSenderId: '188375719694',
    projectId: 'app-house-d0ac1',
    storageBucket: 'app-house-d0ac1.appspot.com',
    iosBundleId: 'com.example.flutterApplication',
  );
}
