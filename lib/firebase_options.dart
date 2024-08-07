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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB03A-6e7QhUqHj1fu1P1WDggUNVXqKQm0',
    appId: '1:1092084812416:web:d7e6aa0acf4b6ce1933465',
    messagingSenderId: '1092084812416',
    projectId: 'awesome-to-do-5170a',
    authDomain: 'awesome-to-do-5170a.firebaseapp.com',
    storageBucket: 'awesome-to-do-5170a.appspot.com',
    measurementId: 'G-30XDRSFJVG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_x1pOhYFGqb50G75oPxRlXcIGxm-sd7g',
    appId: '1:1092084812416:android:325364c0dcae2b7f933465',
    messagingSenderId: '1092084812416',
    projectId: 'awesome-to-do-5170a',
    storageBucket: 'awesome-to-do-5170a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCFnTC6jKLLQQFSijnaxUnftf24WanA6E',
    appId: '1:1092084812416:ios:d9b53c574b3c5bf0933465',
    messagingSenderId: '1092084812416',
    projectId: 'awesome-to-do-5170a',
    storageBucket: 'awesome-to-do-5170a.appspot.com',
    iosBundleId: 'com.example.awesomeToDo',
  );

}