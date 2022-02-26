import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:firebase_auth_desktop/firebase_auth_desktop.dart'
    as authforwindowsweb;
// import 'package:fireverse/fireverse.dart';

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
        return 'erregistratua';
      } on authforandroid.FirebaseAuthException catch (e) {
        if (e.code == 'email-exists') {
          return 'Pasahitz existitzen da';
        } else {
          return 'Errorea: $e';
        }
      } catch (e) {
        return 'Errorea: $e';
      }
    } else {
      try {
        var auth = firedart.FirebaseAuth.instance;
        User? currentUser ;
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
            'uid': userId
          },
        );
        return 'erregistratua';

        // await Fire.register(email: email, password: password);

        //  var auth = FireDartFirebaseAuth.instance;
        //   if (auth.isSignedIn) {
        //   var user = await auth.getUser();
        //   String userId = user.id;

        //   await Fire.update(
        //   collectionName: "users",
        //   docId: userId,
        //   value: {
        //     'username': name,
        //     'email': email,
        //     'telepNum': telepNum,
        //     'uid': userId
        //   },
        // );
        // return 'erregistratua';
        //   }
      } catch (e) {
        return 'Errorea: $e';
      }
    }
  }
}
