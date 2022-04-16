import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/firedart.dart' as firedart;
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
          return "Ez da e-posta hori duen erabiltzilerik aurkitu";
        } else if (e.code == 'wrong-password') {
          return "Pasahitz okerra erabiltzaile horrentzat";
        } else if (e.code == 'too-many-requests') {
          return e.code.toString();
        }
        return "$e.code";
      }
    } else {
      try {
        // await Fire.signIn(email: email, password: password);
        var auth = firedart.FirebaseAuth.instance;
        await auth.signIn(email, password);

        return "Ondo Logeatu zara";
      } on AuthException catch (e) {
        if (e.errorCode == 'INVALID_PASSWORD') {
          return 'wrong-password';
        } else if (e.errorCode == 'EMAIL_NOT_FOUND') {
          return 'wrong-email';
        } else {
          return e.errorCode;
        }
      }
    }
  }

  static Future<void> signOut() async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      await authforandroid.FirebaseAuth.instance.signOut();
    } else {
      firedart.FirebaseAuth.instance.signOut();
    }
  }

  static Future<void> deleteProfile() async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      await authforandroid.FirebaseAuth.instance.signOut();
    } else {
      firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;
      firedart.FirebaseAuth.instance.deleteAccount();
      String userId = auth.userId;
      await firedart.Firestore.instance
          .collection('users')
          .document(userId)
          .delete();
    }
  }
}
