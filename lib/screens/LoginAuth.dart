import 'package:firebase_auth/firebase_auth.dart';

class LoginAuth {
  static Future<String> loginUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email,
              password: password);
      return "Ondo Logeatu zara";
          
    } on FirebaseAuthException catch (e) {
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

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
