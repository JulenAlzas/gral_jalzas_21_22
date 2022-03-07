import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/exceptions.dart';
// import 'package:firebase_auth_desktop/firebase_auth_desktop.dart'
//     as authforwindowsweb;
import 'package:firedart/firedart.dart' as firedart;
// import 'package:fireverse/fireverse.dart';
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
    // else {
    //   try {
    //     await authforwindowsweb.FirebaseAuthDesktop.instance
    //         .signInWithEmailAndPassword(email, password);
    //     return "Ondo Logeatu zara";
    //   } on authforandroid.FirebaseAuthException catch (e) {
    //     if (e.code == 'user-not-found') {
    //       // AlertDialog('No user found for that email.');
    //       return "Ez da e-posta hori duen erabiltzilerik aurkitu";
    //     } else if (e.code == 'wrong-password') {
    //       // print('Wrong password provided for that user.');
    //       return "Pasahitz okerra erabiltzaile horrentzat";
    //     }
    //     return "$e.code";
    //   }
    // }
  }

  static Future<void> signOut() async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      await authforandroid.FirebaseAuth.instance.signOut();
    } else {
      firedart.FirebaseAuth.instance.signOut();
      // Fire.signOut();
      // await authforwindowsweb.FirebaseAuthDesktop.instance.signOut();
      // await authforwindowsweb.FirebaseAuthDesktop.instance.signOut();
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
