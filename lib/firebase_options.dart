import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return ios;
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
    apiKey: 'AIzaSyCG2T3c6_7H4xoQZINfJr4Euozxp4XpwNc',
    appId: '1:480047306856:web:6b812d3696127295c343dd',
    messagingSenderId: '480047306856',
    projectId: 'blinklean-app',
    authDomain: 'blinklean-app.firebaseapp.com',
    storageBucket: 'blinklean-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCG2T3c6_7H4xoQZINfJr4Euozxp4XpwNc',
    appId: '1:480047306856:android:6b812d3696127295c343dd',
    messagingSenderId: '480047306856',
    projectId: 'blinklean-app',
    storageBucket: 'blinklean-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCG2T3c6_7H4xoQZINfJr4Euozxp4XpwNc',
    appId: '1:480047306856:ios:6b812d3696127295c343dd',
    messagingSenderId: '480047306856',
    projectId: 'blinklean-app',
    storageBucket: 'blinklean-app.firebasestorage.app',
    iosBundleId: 'company.Blinklean',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCG2T3c6_7H4xoQZINfJr4Euozxp4XpwNc',
    appId: '1:480047306856:web:6b812d3696127295c343dd',
    messagingSenderId: '480047306856',
    projectId: 'blinklean-app',
    authDomain: 'blinklean-app.firebaseapp.com',
    storageBucket: 'blinklean-app.firebasestorage.app',
  );
}
