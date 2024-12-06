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
    apiKey: 'AIzaSyANPetdvc2cTDT8EGcDcJJ73VpNXKTBLs4',
    appId: '1:256703153439:android:7227c1c78e25265746dc2a',
    messagingSenderId: '256703153439',
    projectId: 'little-brazil',
    storageBucket: 'little-brazil.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbsut8pNVJvFXzv3z8LXJFcrKim7uZDdo',
    appId: '1:256703153439:ios:0ea29c1f969459df46dc2a',
    messagingSenderId: '256703153439',
    projectId: 'little-brazil',
    storageBucket: 'little-brazil.appspot.com',
    androidClientId: '256703153439-1ta7p84aa715k49vflerm8e5dkaae6nv.apps.googleusercontent.com',
    iosClientId: '256703153439-kqr9cetqlm01o0a60um6aor8rsk646e7.apps.googleusercontent.com',
    iosBundleId: 'kz.khan.littlebrazil',
  );
}
