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
    apiKey: 'AIzaSyCkRWWsjFkUozKVQ2JcFJl6Hwj5T6Fcw9s',
    appId: '1:822499329892:web:bf84768f38a974f7379c71',
    messagingSenderId: '822499329892',
    projectId: 'instafood-1',
    authDomain: 'instafood-1.firebaseapp.com',
    storageBucket: 'instafood-1.firebasestorage.app',
    measurementId: 'G-M8Q1YN5KPZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBb3AccE6npvbeEggcyZKMDilFErYphVLI',
    appId: '1:822499329892:android:1cb1b724d79fb397379c71',
    messagingSenderId: '822499329892',
    projectId: 'instafood-1',
    storageBucket: 'instafood-1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyApyTXMby0JdFMdC0eLKPSaG6FhsP7pg1k',
    appId: '1:822499329892:ios:3b3697a6dea12090379c71',
    messagingSenderId: '822499329892',
    projectId: 'instafood-1',
    storageBucket: 'instafood-1.firebasestorage.app',
    iosBundleId: 'com.example.instaFood',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyApyTXMby0JdFMdC0eLKPSaG6FhsP7pg1k',
    appId: '1:822499329892:ios:3b3697a6dea12090379c71',
    messagingSenderId: '822499329892',
    projectId: 'instafood-1',
    storageBucket: 'instafood-1.firebasestorage.app',
    iosBundleId: 'com.example.instaFood',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCkRWWsjFkUozKVQ2JcFJl6Hwj5T6Fcw9s',
    appId: '1:822499329892:web:9dcf6a4c9490fa75379c71',
    messagingSenderId: '822499329892',
    projectId: 'instafood-1',
    authDomain: 'instafood-1.firebaseapp.com',
    storageBucket: 'instafood-1.firebasestorage.app',
    measurementId: 'G-6QL1TMQE7W',
  );
}
