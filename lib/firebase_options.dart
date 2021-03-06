import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCcy_xzW16tX9LoUVXiP4CXZUhfvbh6SLA',
    appId: '1:312983830076:web:dee094b1ff0e3803a10d39',
    messagingSenderId: '312983830076',
    projectId: 'gral-jalzas',
    authDomain: 'gral-jalzas.firebaseapp.com',
    storageBucket: 'gral-jalzas.appspot.com',
    measurementId: 'G-5D6PWQE0L1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0Q3imKsNfBe7iFOIzgqAVB8Gcl2fHt-c',
    appId: '1:312983830076:android:6a32a5ef7c13b253a10d39',
    messagingSenderId: '312983830076',
    projectId: 'gral-jalzas',
    storageBucket: 'gral-jalzas.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMv9i8b1HQqBcTqrdZyQySh3uKhlEcF08',
    appId: '1:312983830076:ios:ea024c419a7cc7a4a10d39',
    messagingSenderId: '312983830076',
    projectId: 'gral-jalzas',
    storageBucket: 'gral-jalzas.appspot.com',
    iosClientId:
        '312983830076-e51av6mr7quv1kktgdsb5eb6630oh3r4.apps.googleusercontent.com',
    iosBundleId: 'com.example.gralJalzas2122',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMv9i8b1HQqBcTqrdZyQySh3uKhlEcF08',
    appId: '1:312983830076:ios:ea024c419a7cc7a4a10d39',
    messagingSenderId: '312983830076',
    projectId: 'gral-jalzas',
    storageBucket: 'gral-jalzas.appspot.com',
    iosClientId:
        '312983830076-e51av6mr7quv1kktgdsb5eb6630oh3r4.apps.googleusercontent.com',
    iosBundleId: 'com.example.gralJalzas2122',
  );
}
