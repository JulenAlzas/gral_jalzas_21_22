import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart' as firedart;

import 'package:flutter/foundation.dart';

class RegisterAuth {
  static Future<String?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required String telepNum,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      try {
        FirebaseFirestore _firestore = FirebaseFirestore.instance;

        authforandroid.UserCredential userCredential = await authforandroid
            .FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        userCredential = await authforandroid.FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': name,
          'email': email,
          'telepNum': telepNum,
        });
        return 'erregistratua';
      } on authforandroid.FirebaseAuthException catch (e) {
        if (e.code == 'email-exists') {
          return 'Eposta existitzen da';
        } else if (e.code == 'email-already-in-use') {
          return e.code.toString();
        } else {
          return 'Errorea: $e';
        }
      }
    } else {
      try {
        var auth = firedart.FirebaseAuth.instance;
        User? currentUser;
        await auth.signUp(email, password).then((user) {
          currentUser = user;
        });
        await auth.signIn(email, password);
        String userId = currentUser!.id.toString();

        await firedart.Firestore.instance
            .collection('users')
            .document(userId)
            .set(
          {
            'username': name,
            'email': email,
            'telepNum': telepNum,
          },
        );
        return 'erregistratua';
      } on AuthException catch (e) {
        if (e.errorCode == 'EMAIL_EXISTS') {
          return e.errorCode.toString();
        }
        return 'Errorea: $e';
      }
    }
  }
}
