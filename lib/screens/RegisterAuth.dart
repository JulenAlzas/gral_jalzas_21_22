import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required String telepNum,
  }) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      //Register new user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email,
              password: password);

      //Add user other filds
      
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username' : name,
        'email': email,
        'telepNum': telepNum,
        'uid' : userCredential.user!.uid 
        });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Pasahitza ahulegia da');
      } else if (e.code == 'email-already-in-use') {
        print('E-posta iada existizen da.');
      }
    } catch (e) {
      print('Errorea: $e');
    }
  }
}
