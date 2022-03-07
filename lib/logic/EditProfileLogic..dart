import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/exceptions.dart';
// import 'package:firebase_auth_desktop/firebase_auth_desktop.dart'
//     as authforwindowsweb;
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fireverse/fireverse.dart';
import 'package:flutter/foundation.dart';

class EditProfileLogic {
  static bool updateForDBEmailNeeded = true;
  static bool verifyOldPass = false;

  static Future<String?> editUserProfile({
    required String oldName,
    required String oldEmail,
    required String oldTelepNum,
    required String newName,
    required String newEmail,
    required String newPassword,
    required String newTelepNum,
    required bool updatePass,
    required String oldPasword,
    required bool updateRecentLogRequired,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      try {
        //Get current values
        String userCredential =
            authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

        authforandroid.User? currentUser =
            authforandroid.FirebaseAuth.instance.currentUser;

        if (oldName == newName &&
            oldEmail == newEmail &&
            oldTelepNum == newTelepNum &&
            !updatePass) {
          return 'Eremu berak';
        }
        if (oldName != newName &&
            oldEmail != newEmail &&
            oldTelepNum != newTelepNum) {
          if (updateRecentLogRequired) {
            await updateCredentials(oldEmail, oldPasword);

            currentUser = authforandroid.FirebaseAuth.instance.currentUser;
          }

          await currentUser!.updateEmail(newEmail);

          _firestore.collection('users').doc(userCredential).update({
            'username': newName,
            'email': newEmail,
            'telepNum': newTelepNum,
          });
        } else if (oldName != newName &&
            oldEmail == newEmail &&
            oldTelepNum == newTelepNum) {
          _firestore.collection('users').doc(userCredential).update({
            'username': newName,
          });
        } else if (oldName != newName &&
            oldEmail != newEmail &&
            oldTelepNum == newTelepNum) {
          if (updateRecentLogRequired) {
            await updateCredentials(oldEmail, oldPasword);
            currentUser = authforandroid.FirebaseAuth.instance.currentUser;
          }

          await currentUser!.updateEmail(newEmail);
          _firestore.collection('users').doc(userCredential).update({
            'username': newName,
            'email': newEmail,
          });
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
          if (updateRecentLogRequired) {
            await updateCredentials(oldEmail, oldPasword);

            currentUser = authforandroid.FirebaseAuth.instance.currentUser;
          }
          await currentUser!.updateEmail(newEmail);
          _firestore.collection('users').doc(userCredential).update({
            'email': newEmail,
            'telepNum': newTelepNum,
          });
        } else if (oldName == newName &&
            oldEmail != newEmail &&
            oldTelepNum == newTelepNum) {
          if (updateRecentLogRequired) {
            await updateCredentials(oldEmail, oldPasword);
            currentUser = authforandroid.FirebaseAuth.instance.currentUser;
          }
          await currentUser!.updateEmail(newEmail);
          _firestore.collection('users').doc(userCredential).update({
            'email': newEmail,
          });
        } else if (oldName == newName &&
            oldEmail == newEmail &&
            oldTelepNum != newTelepNum) {
          _firestore.collection('users').doc(userCredential).update({
            'telepNum': newTelepNum,
          });
        }
        if (updatePass) {
          try {
            if (updateRecentLogRequired && oldEmail == newEmail) {
              //e-posta desberdina bada iada kredentzialak eguneratu dira goian
              await updateCredentials(oldEmail, oldPasword);

              currentUser = authforandroid.FirebaseAuth.instance.currentUser;
            }
            await currentUser!.updatePassword(newPassword);
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
    } else {
      try {
        firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;
        // String token = '';
        // await auth.tokenProvider.refreshIDToken.then((value)  {
        //   token = value;
        //   print('object');
        // });

        // await auth.tokenProvider.idToken.then((value) {
        //   token = value;
        //   print('object');
        // });
        // User? currentUser;
        // await auth.getUser().then((user) {
        //   currentUser = user;
        // });
        // String userId = currentUser!.id.toString();

        String userId = '';
        if (auth.isSignedIn) {
          userId = auth.userId;
        }

        if (oldName == newName &&
            oldEmail == newEmail &&
            oldTelepNum == newTelepNum &&
            !updatePass) {
          return 'Eremu berak';
        }
        if (oldName != newName &&
            oldEmail != newEmail &&
            oldTelepNum != newTelepNum) {
          if (updateForDBEmailNeeded) {
            updateForDBEmailNeeded = false;
            return 'requires-oldpass-updateDB';
          } else {
            try {
              if (!verifyOldPass) {
                auth.signOut();
                await auth.signIn(oldEmail, oldPasword);
                verifyOldPass = true;
              } else {
                Map<String, dynamic> resultmap =
                    await auth.changeEmail(newEmail);
                auth.tokenProvider.setidToken(resultmap['idToken']);
                auth.signOut();
                await auth.signIn(newEmail, oldPasword);
                verifyOldPass = false;
              }
            } on AuthException catch (e) {
              if (e.errorCode == 'INVALID_PASSWORD') {
                return 'wrong-password';
              } else {
                return e.errorCode;
              }
            }

            userId = auth.userId;
            updateForDBEmailNeeded = true;
          }

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'username': newName,
            'email': newEmail,
            'telepNum': newTelepNum,
          });
        } else if (oldName != newName &&
            oldEmail == newEmail &&
            oldTelepNum == newTelepNum) {
          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'username': newName,
          });
        } else if (oldName != newName &&
            oldEmail != newEmail &&
            oldTelepNum == newTelepNum) {
          if (updateForDBEmailNeeded) {
            updateForDBEmailNeeded = false;
            return 'requires-oldpass-updateDB';
          } else {
            try {
              auth.signOut();
              await auth.signIn(oldEmail, oldPasword);
              Map<String, dynamic> resultmap = await auth.changeEmail(newEmail);
              auth.tokenProvider.setidToken(resultmap['idToken']);
              auth.signOut();
              await auth.signIn(newEmail, oldPasword);
            } on AuthException catch (e) {
              if (e.errorCode == 'INVALID_PASSWORD') {
                return 'wrong-password';
              } else {
                return e.errorCode;
              }
            }
            userId = auth.userId;
            updateForDBEmailNeeded = true;
          }

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'username': newName,
            'email': newEmail,
          });
        } else if (oldName != newName &&
            oldEmail == newEmail &&
            oldTelepNum != newTelepNum) {
          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'username': newName,
            'telepNum': newTelepNum,
          });
        } else if (oldName == newName &&
            oldEmail != newEmail &&
            oldTelepNum != newTelepNum) {
          if (updateForDBEmailNeeded) {
            updateForDBEmailNeeded = false;
            return 'requires-oldpass-updateDB';
          } else {
            try {
              auth.signOut();
              await auth.signIn(oldEmail, oldPasword);
              Map<String, dynamic> resultmap = await auth.changeEmail(newEmail);
              auth.tokenProvider.setidToken(resultmap['idToken']);
              auth.signOut();
              await auth.signIn(newEmail, oldPasword);
            } on AuthException catch (e) {
              if (e.errorCode == 'INVALID_PASSWORD') {
                return 'wrong-password';
              } else {
                return e.errorCode;
              }
            }
            userId = auth.userId;
            updateForDBEmailNeeded = true;
          }

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'email': newEmail,
            'telepNum': newTelepNum,
          });
        } else if (oldName == newName &&
            oldEmail != newEmail &&
            oldTelepNum == newTelepNum) {
          if (updateForDBEmailNeeded) {
            updateForDBEmailNeeded = false;
            return 'requires-oldpass-updateDB';
          } else {
            try {
              auth.signOut();
              await auth.signIn(oldEmail, oldPasword);
              Map<String, dynamic> resultmap = await auth.changeEmail(newEmail);
              auth.tokenProvider.setidToken(resultmap['idToken']);
              auth.signOut();
              await auth.signIn(newEmail, oldPasword);
            } on AuthException catch (e) {
              if (e.errorCode == 'INVALID_PASSWORD') {
                return 'wrong-password';
              } else {
                return e.errorCode;
              }
            }
            userId = auth.userId;
            updateForDBEmailNeeded = true;
          }

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'email': newEmail,
          });
        } else if (oldName == newName &&
            oldEmail == newEmail &&
            oldTelepNum != newTelepNum) {
          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'telepNum': newTelepNum,
          });
        }
        if (updatePass) {
          try {
            Map<String, dynamic> resultmap =
                await auth.changePassword(newPassword);
            auth.tokenProvider.setidToken(resultmap['idToken']);

            auth.signOut();
            try {
              await auth.signIn(newEmail, newPassword);
            } on AuthException catch (e) {
              if (e.errorCode == 'INVALID_PASSWORD') {
                return 'wrong-password';
              } else {
                return e.errorCode;
              }
            }
          } on AuthException catch (e) {
            if (e.errorCode == 'INVALID_PASSWORD') {
              return 'wrong-password';
            } else {
              return e.errorCode;
            }
          }
        }
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

  static Future<firedart.FirebaseAuth> deleteAccCreateNew(
      firedart.FirebaseAuth auth, String newEmail, String newPassword) async {
    await auth.deleteAccount();
    await auth.signUp(newEmail, newPassword);
    await auth.signIn(newEmail, newPassword);
    return auth;
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
