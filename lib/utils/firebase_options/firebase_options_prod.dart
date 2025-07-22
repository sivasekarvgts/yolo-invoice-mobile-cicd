import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptionsProd {
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
    apiKey: 'AIzaSyDf1gxFoSpTLdZdHQ6vY4QJaMHgYtdQPFo',
    appId: '1:102875497382:android:93b531cc14f1e77dd38567',
    messagingSenderId: '102875497382',
    projectId: 'invoice-a14da',
    storageBucket: 'invoice-a14da.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
      apiKey: 'AIzaSyCY0ESQATPTRfx13B4zTr4Ubjc4olf2aaw',
      appId: '1:102875497382:ios:c5778efc867ef793d38567',
      messagingSenderId: '102875497382',
      projectId: 'invoice-a14da',
      storageBucket: 'invoice-a14da.appspot.com',
      iosBundleId: 'com.yoloworks.invoice');
}
