import 'package:awesome_card/awesome_card.dart';
import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/exceptions.dart' show AuthException;
import 'package:firedart/firedart.dart' as firedart;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class AddCreditCard {

  static Future<String?> addNewCard(
      {required String txartelZenbakia,
      required String iraungitzea,
      required String cvv,
      required String titularra,
      required CardType txartelmota}) async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      try {
        String userCredential =
            authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

        // String docId =' ';
        // await _firestore
        //     .collection('credcard')
        //     .where('userUID', isEqualTo: userCredential)
        //     .get()
        //     .then((querySnapshot) {
        //       docId= querySnapshot.docs.first.id;
        // });

        // _firestore.collection('credcard').doc(docId).set({
        //   'txartelZenbakia': txartelZenbakia,
        //   'iraungitzea': iraungitzea,
        //   'cvv': cvv,
        //   'titularra': titularra,
        //   'userUID': userCredential,
        // });

        await _firestore.collection('credcard').doc().set({
          'txartelZenbakia': txartelZenbakia,
          'iraungitzea': iraungitzea,
          'cvv': cvv,
          'titularra': titularra,
          'userUID': userCredential,
          'txartelmota': txartelmota.toString()
        });

        return 'Erab eguneratua';
      } on authforandroid.FirebaseAuthException catch (e) {
        return 'Errorea: $e';
      }
    } else {
      try {
        firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

        String userId = auth.userId;

        // String cardId = firedart.Firestore.instance
        //     .collection('credcard')
        //     .where('userUID', isEqualTo: userId)
        //     .id;

        // await firedart.Firestore.instance
        //     .collection('credcard')
        //     .document(cardId)
        //     .set(
        //   {
        //     'txartelZenbakia': txartelZenbakia,
        //     'iraungitzea': iraungitzea,
        //     'cvv': cvv,
        //     'titularra': titularra,
        //     'userUID': userId,
        //   },
        // );

        await firedart.Firestore.instance
            .collection('credcard')
            .document(
              randomId()
            )
            .set(
          {
            'txartelZenbakia': txartelZenbakia,
            'iraungitzea': iraungitzea,
            'cvv': cvv,
            'titularra': titularra,
            'userUID': userId,
            'txartelmota': txartelmota.toString()
          },
        );

        return 'Erab eguneratua';
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

  static Future<bool> isCardCreatedForCurrentUser()async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      try {
        String userCredential =
            authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

        String docId ='';
        await _firestore
            .collection('credcard')
            .where('userUID', isEqualTo: userCredential)
            .get()
            .then((querySnapshot) {
               if(querySnapshot.docs.isNotEmpty){
              docId= querySnapshot.docs.first.id;
               }
        });
        if(docId == ''){
          return false;
        }
        return true;
      } on authforandroid.FirebaseAuthException catch (e) {
        var aaa= e.code;
        return false;
      }
    } else {
      try {
        firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

        String userId = auth.userId;

        String docId ='';

        await firedart.Firestore.instance
            .collection('credcard')
            .where('userUID', isEqualTo: userId)
            .get().then((querySnapshot) {
              if(querySnapshot.isNotEmpty){
                docId = querySnapshot.first.id;
              }
            });

        if(docId == ''){
          return false;
        }
            
        return true;
      } on authforandroid.FirebaseAuthException catch (e) {
        return false;
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

String randomId() {
  var uuid = const Uuid();
  var _randomId = uuid.v4();
  return _randomId;
}
