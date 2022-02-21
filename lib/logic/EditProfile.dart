

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileLogic {
  static Future<String?> editUserProfile({
    required String oldName,
    required String oldEmail,
    required String oldTelepNum,
    required String newName,
    required String newEmail,
    required String newPassword,
    required String newTelepNum,
  }) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      //Get current values
      String userCredential = FirebaseAuth.instance.currentUser?.uid ?? 'no-id';
    FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential)
        .get()
        .then((querySnapshot) {

        oldName = querySnapshot['username'];
        oldEmail = querySnapshot['email'];
        oldTelepNum = querySnapshot['telepNum'];;
    });
      if(oldName == newName && oldEmail == newEmail && oldTelepNum ==newTelepNum){
        return 'Eremu berak';
      }
      if(oldName != newName && oldEmail != newEmail && oldTelepNum !=newTelepNum){
        _firestore.collection('users').doc(userCredential).update({
        'username': newName,
        'email': newEmail,
        'telepNum': newTelepNum,
      });
      }else if(oldName != newName && oldEmail == newEmail && oldTelepNum ==newTelepNum){
        _firestore.collection('users').doc(userCredential).update({
        'username': newName,
      });
      }else if(oldName != newName && oldEmail != newEmail && oldTelepNum ==newTelepNum){
        _firestore.collection('users').doc(userCredential).update({
        'username': newName,
        'email': newEmail,
      });
      }else if(oldName != newName && oldEmail == newEmail && oldTelepNum !=newTelepNum){
        _firestore.collection('users').doc(userCredential).update({
        'username': newName,
        'telepNum': newTelepNum,
      });
      }
      else if(oldName == newName && oldEmail != newEmail && oldTelepNum !=newTelepNum){
        _firestore.collection('users').doc(userCredential).update({
        'email': newEmail,
        'telepNum': newTelepNum,
      });
      }else if(oldName == newName && oldEmail != newEmail && oldTelepNum ==newTelepNum){
        _firestore.collection('users').doc(userCredential).update({
        'email': newEmail,
      });
      }else if(oldName == newName && oldEmail == newEmail && oldTelepNum !=newTelepNum){
        _firestore.collection('users').doc(userCredential).update({
        'telepNum': newTelepNum,
      });
      }
      return 'Erab eguneratua';      
      
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