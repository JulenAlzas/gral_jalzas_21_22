import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/firedart.dart' as firedart;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gral_jalzas_21_22/screens/joko1.dart';
import 'package:uuid/uuid.dart';
import 'package:gral_jalzas_21_22/screens/joko1.dart';

class TransactionLogic {
  static Future<String?> addTransaction(
      {required String transMota,
      required String zenbat,
      required Timestamp transDate}) async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      try {
        String userCredential =
            authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

        await _firestore
            .collection('users')
            .doc(userCredential)
            .collection('moneyTransactions')
            .doc()
            .set({
          'data': transDate,
          'trans_mota': transMota,
          'zenbat': zenbat,
        });

        return 'Trans eguneratua';
      } on authforandroid.FirebaseAuthException catch (e) {
        return 'Errorea: $e';
      }
    } else {
      try {
        firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

        String userId = auth.userId;

        var dateFormatedInDateTime = transDate.toDate();

        await firedart.Firestore.instance
            .collection('users')
            .document(userId)
            .collection('moneyTransactions')
            .document(randomId())
            .set(
          {
            'data': dateFormatedInDateTime,
            'trans_mota': transMota,
            'zenbat': zenbat,
          },
        );
        return 'Trans eguneratua';
      } on authforandroid.FirebaseAuthException catch (e) {
        return 'Errorea: $e';
      }
    }
  }
}

String randomId() {
  var uuid = const Uuid();
  var _randomId = uuid.v4();
  return _randomId;
}
