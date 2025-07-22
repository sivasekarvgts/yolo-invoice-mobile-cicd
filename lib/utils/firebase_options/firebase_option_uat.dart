import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptionsUAT {
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
    apiKey: 'AIzaSyBNs9JtHuI4Ir3WppYpPD2sPmjEhwClXsI',
    appId: '1:373064065522:android:0eb5f644ad35673e7b0b6b',
    messagingSenderId: '373064065522',
    projectId: 'invoice-dev-e2234',
    storageBucket: 'invoice-dev-e2234.appspot.com',
    
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYvL3-zkuaI6CIWrJxpnfpmGXBchw3Ecc',
    appId: '1:373064065522:ios:867b887e852abf6b7b0b6b',
    messagingSenderId: '373064065522',
    projectId: 'invoice-dev-e2234',
    storageBucket: 'invoice-dev-e2234.appspot.com',
    iosBundleId: 'com.yoloworks.invoice.uat',
  );
}
