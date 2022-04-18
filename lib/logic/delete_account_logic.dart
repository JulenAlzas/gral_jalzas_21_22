import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DeleteAccountLogic {
  static bool updateForDBEmailNeeded = true;

  static Future<String?> deleteProfile({
    required String oldEmail,
    required String oldPasword,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      String userCredential =
          authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';
      try {
        await updateCredentials(oldEmail, oldPasword);

        _firestore.collection('users').doc(userCredential).delete();

        await authforandroid.FirebaseAuth.instance.currentUser!.delete();

        return 'Erab ezabatua';
      } on authforandroid.FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          return 'requires-recent-login';
        } else if (e.code == 'wrong-password') {
          return 'wrong-password';
        } else if (e.code == 'too-many-requests') {
          return 'too-many-requests';
        } else {
          return 'Errorea: $e';
        }
      }
    } else {
      try {
        firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

        String userId = '';
        if (auth.isSignedIn) {
          userId = auth.userId;
        }

        try {
          auth.signOut();
          await auth.signIn(oldEmail, oldPasword);
          userId = auth.userId;

          await deleteCredCard(userId);
          await deleteAllTransactions(userId);

          await erabEzabatu(userId, auth);
        } on AuthException catch (e) {
          if (e.errorCode == 'INVALID_PASSWORD') {
            return 'wrong-password';
          } else {
            return e.errorCode;
          }
        }

        return 'Erab ezabatua';
      } on authforandroid.FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          return 'requires-recent-login';
        } else if (e.code == 'wrong-password') {
          return 'wrong-password';
        } else if (e.code == 'too-many-requests') {
          return 'too-many-requests';
        } else {
          return 'Errorea: $e';
        }
      }
    }
  }

  static Future<void> erabEzabatu(String userId, firedart.FirebaseAuth auth) async {
    await firedart.Firestore.instance
        .collection('users')
        .document(userId)
        .delete();
    auth.deleteAccount();
  }

  static Future<void> deleteAllTransactions(String userId) async {
    // ignore: unused_local_variable
    String moneyTransID = '';
    await firedart.Firestore.instance
        .collection('users')
        .document(userId)
        .collection('moneyTransactions')
        .get()
        .then((querySnapshot) {
      if (querySnapshot.isNotEmpty) {
        for (var doc in querySnapshot) {
          firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .collection('moneyTransactions')
              .document(doc.id)
              .delete();
        }
        moneyTransID = querySnapshot.first.id;
      }
    });
  }

  static Future<void> deleteCredCard(String userId) async {
    
    await firedart.Firestore.instance
        .collection('users')
        .document(userId)
        .collection('credcard')
        .get()
        .then((querySnapshot) {
      if (querySnapshot.isNotEmpty) {
        firedart.Firestore.instance
          .collection('users')
          .document(userId)
          .collection('credcard')
          .document(querySnapshot.first.id)
          .delete();
      }
    });
  }

  static Future<void> updateCredentials(
      String oldEmail, String oldPasword) async {
    // if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
    authforandroid.AuthCredential credential =
        authforandroid.EmailAuthProvider.credential(
            email: oldEmail, password: oldPasword);

    await authforandroid.FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);
  }
}
