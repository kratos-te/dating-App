import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return FirebaseOptions(
          apiKey: "AIzaSyACE_hQHftM9bpxlU_XH49SGYOqalDm9UY",
          authDomain: "datingapp-30b0b.firebaseapp.com",
          projectId: "datingapp-30b0b",
          storageBucket: "datingapp-30b0b.appspot.com",
          messagingSenderId: "612547873524",
          appId: "1:612547873524:web:210909020871b1f013eca1",
          measurementId: "G-7C6YLKF58Z");
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:612547873524:ios:7836ab491f9388ed13eca1',
        apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
        projectId: 'react-native-firebase-testing',
        messagingSenderId: '448618578101',
        iosBundleId: 'io.flutter.plugins.firebase.firestore.example',
        iosClientId:
            '448618578101-ja1be10uicsa2dvss16gh4hkqks0vq61.apps.googleusercontent.com',
        androidClientId:
            '448618578101-2baveavh8bvs2famsa5r8t77fe1nrcn6.apps.googleusercontent.com',
        storageBucket: 'react-native-firebase-testing.appspot.com',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:448618578101:android:3ad281c0067ccf97ac3efc',
        apiKey: 'AIzaSyByhi7SM_wtdRgE-rpqLUQtQ3YM60uxwE0',
        projectId: 'react-native-firebase-testing',
        messagingSenderId: '448618578101',
      );
    }
  }
}
