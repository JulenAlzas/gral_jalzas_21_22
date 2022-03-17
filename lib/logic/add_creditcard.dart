import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/exceptions.dart' show AuthException;
import 'package:firedart/firedart.dart' as firedart;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AddCreditCard {

  static Future<String?> addNewCard(
      {required String txartelZenbakia,
      required String iraungitzea,
      required String cvv,
      required String titularra}) async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      try {
        String userCredential =
            authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

        String docId =' ';
        await _firestore
            .collection('credcard')
            .where('userUID', isEqualTo: userCredential)
            .get()
            .then((querySnapshot) {
              docId= querySnapshot.docs.first.id;
        });

        _firestore.collection('credcard').doc(docId).set({
          'txartelZenbakia': txartelZenbakia,
          'iraungitzea': iraungitzea,
          'cvv': cvv,
          'titularra': titularra,
          'userUID': userCredential,
        });

        return 'Erab eguneratua';
      } on authforandroid.FirebaseAuthException catch (e) {
        return 'Errorea: $e';
      }
    } else {
      try {
        firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

        String userId = auth.userId;

        String cardId = firedart.Firestore.instance
            .collection('credcard')
            .where('userUID', isEqualTo: userId)
            .id;

        await firedart.Firestore.instance
            .collection('credcard')
            .document(cardId)
            .set(
          {
            'txartelZenbakia': txartelZenbakia,
            'iraungitzea': iraungitzea,
            'cvv': cvv,
            'titularra': titularra,
            'userUID': userId,
          },
        );
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
