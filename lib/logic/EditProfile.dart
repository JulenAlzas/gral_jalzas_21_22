import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileLogic {
  static Future<String?> editUserProfile(
      {required String oldName,
      required String oldEmail,
      required String oldTelepNum,
      required String newName,
      required String newEmail,
      required String newPassword,
      required String newTelepNum,
      required bool updatePass,
      required String oldPasword}) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      //Get current values
      String userCredential = FirebaseAuth.instance.currentUser?.uid ?? 'no-id';
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (oldName == newName &&
          oldEmail == newEmail &&
          oldTelepNum == newTelepNum &&
          !updatePass) {
        return 'Eremu berak';
      }
      if (oldName != newName &&
          oldEmail != newEmail &&
          oldTelepNum != newTelepNum) {
        _firestore.collection('users').doc(userCredential).update({
          'username': newName,
          'email': newEmail,
          'telepNum': newTelepNum,
        });
        await currentUser!.updateEmail(newEmail);
        currentUser!.updateEmail(newEmail);
      } else if (oldName != newName &&
          oldEmail == newEmail &&
          oldTelepNum == newTelepNum) {
        _firestore.collection('users').doc(userCredential).update({
          'username': newName,
        });
      } else if (oldName != newName &&
          oldEmail != newEmail &&
          oldTelepNum == newTelepNum) {
        _firestore.collection('users').doc(userCredential).update({
          'username': newName,
          'email': newEmail,
        });
        currentUser!.updateEmail(newEmail);
      } else if (oldName != newName &&
          oldEmail == newEmail &&
          oldTelepNum != newTelepNum) {
        _firestore.collection('users').doc(userCredential).update({
          'username': newName,
          'telepNum': newTelepNum,
        });
      } else if (oldName == newName &&
          oldEmail != newEmail &&
          oldTelepNum != newTelepNum) {
        _firestore.collection('users').doc(userCredential).update({
          'email': newEmail,
          'telepNum': newTelepNum,
        });
        await currentUser!.updateEmail(newEmail);
      } else if (oldName == newName &&
          oldEmail != newEmail &&
          oldTelepNum == newTelepNum) {
        _firestore.collection('users').doc(userCredential).update({
          'email': newEmail,
        });
        await currentUser!.updateEmail(newEmail);
        currentUser!.updateEmail(newEmail);
      } else if (oldName == newName &&
          oldEmail == newEmail &&
          oldTelepNum != newTelepNum) {
        _firestore.collection('users').doc(userCredential).update({
          'telepNum': newTelepNum,
        });
      }
      if (updatePass) {
        try {
          if (oldPasword != '') {
            await updateCredentials(oldEmail, oldPasword);
            currentUser = FirebaseAuth.instance.currentUser;
          }
          await currentUser!.updatePassword(newPassword);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            print(
                'The user must reauthenticate before this operation can be executed.');
            return 'requires-recent-login';
          }
        }
      }
      return 'Erab eguneratua';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Pasahitza ahulegia da');
      } else if (e.code == 'email-already-in-use') {
        print('E-posta iada existizen da.');
      } else if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
        return 'requires-recent-login';
      }
    } catch (e) {
      return 'Errorea: $e';
      print('Errorea: $e');
    }
  }

  static Future<void> updateCredentials(String oldEmail, String oldPasword) async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: oldEmail, password: oldPasword);
    
    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);
  }
}
