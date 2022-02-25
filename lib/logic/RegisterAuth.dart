import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firebase_auth_desktop/firebase_auth_desktop.dart'
    as authforwindowsweb;
import 'package:flutter/foundation.dart';

class RegisterAuth {
  static Future<authforandroid.User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required String telepNum,
  }) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      try {
        //Register new user
        authforandroid.UserCredential userCredential = await authforandroid
            .FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': name,
          'email': email,
          'telepNum': telepNum,
          'uid': userCredential.user!.uid
        });
      } on authforandroid.FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('Pasahitza ahulegia da');
        } else if (e.code == 'email-already-in-use') {
          print('E-posta iada existizen da.');
        }
      } catch (e) {
        print('Errorea: $e');
      }
    // } else {
    //   try {
        
    //     var userCredential = await authforwindowsweb.FirebaseAuthDesktop.instance
    //       .createUserWithEmailAndPassword(email, password);

    //     _firestore.collection('users').doc(userCredential.user!.uid).set({
    //       'username': name,
    //       'email': email,
    //       'telepNum': telepNum,
    //       'uid': userCredential.user!.uid
    //     });
    //   } on authforandroid.FirebaseAuthException catch (e) {
    //     if (e.code == 'weak-password') {
    //       print('Pasahitza ahulegia da');
    //     } else if (e.code == 'email-already-in-use') {
    //       print('E-posta iada existizen da.');
    //     }
    //   } catch (e) {
    //     print('Errorea: $e');
    //   }
    // }
  }
}
