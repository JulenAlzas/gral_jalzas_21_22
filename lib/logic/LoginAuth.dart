import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firebase_auth_desktop/firebase_auth_desktop.dart'
    as authforwindowsweb;
import 'package:flutter/foundation.dart';

class LoginAuth {
  static Future<String> loginUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      try {
        await authforandroid.FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return "Ondo Logeatu zara";
      } on authforandroid.FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // AlertDialog('No user found for that email.');
          return "Ez da e-posta hori duen erabiltzilerik aurkitu";
        } else if (e.code == 'wrong-password') {
          // print('Wrong password provided for that user.');
          return "Pasahitz okerra erabiltzaile horrentzat";
        }
        return "$e.code";
      }
    } else {
      try {
        await authforwindowsweb.FirebaseAuthDesktop.instance
            .signInWithEmailAndPassword(email, password);
        return "Ondo Logeatu zara";
      } on authforandroid.FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // AlertDialog('No user found for that email.');
          return "Ez da e-posta hori duen erabiltzilerik aurkitu";
        } else if (e.code == 'wrong-password') {
          // print('Wrong password provided for that user.');
          return "Pasahitz okerra erabiltzaile horrentzat";
        }
        return "$e.code";
      }
    }
  }

  static Future<void> signOut() async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      await authforandroid.FirebaseAuth.instance.signOut();
    } else {
      await authforandroid.FirebaseAuth.instance.signOut();
      // await authforwindowsweb.FirebaseAuthDesktop.instance.signOut();
    }
  }
}
