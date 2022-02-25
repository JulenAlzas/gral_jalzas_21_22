import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firebase_auth_desktop/firebase_auth_desktop.dart'
    as authforwindowsweb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_platform_interface/src/platform_interface/platform_interface_user.dart';
import 'package:flutter/foundation.dart';

class EditProfileLogic {
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
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
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
    // } else {
    //   try {
    //     //Get current values
    //     String userCredential =
    //         authforwindowsweb.FirebaseAuthDesktop.instance.currentUser?.uid ??
    //             'no-id';

    //     UserPlatform? currentUser =
    //         authforwindowsweb.FirebaseAuthDesktop.instance.currentUser;

    //     if (oldName == newName &&
    //         oldEmail == newEmail &&
    //         oldTelepNum == newTelepNum &&
    //         !updatePass) {
    //       return 'Eremu berak';
    //     }
    //     if (oldName != newName &&
    //         oldEmail != newEmail &&
    //         oldTelepNum != newTelepNum) {
    //       if (updateRecentLogRequired) {
    //         await updateCredentials(oldEmail, oldPasword);

    //         currentUser =
    //             authforwindowsweb.FirebaseAuthDesktop.instance.currentUser;
    //       }

    //       await currentUser!.updateEmail(newEmail);

    //       _firestore.collection('users').doc(userCredential).update({
    //         'username': newName,
    //         'email': newEmail,
    //         'telepNum': newTelepNum,
    //       });
    //     } else if (oldName != newName &&
    //         oldEmail == newEmail &&
    //         oldTelepNum == newTelepNum) {
    //       _firestore.collection('users').doc(userCredential).update({
    //         'username': newName,
    //       });
    //     } else if (oldName != newName &&
    //         oldEmail != newEmail &&
    //         oldTelepNum == newTelepNum) {
    //       if (updateRecentLogRequired) {
    //         await updateCredentials(oldEmail, oldPasword);
    //         currentUser =
    //             authforwindowsweb.FirebaseAuthDesktop.instance.currentUser;
    //       }

    //       await currentUser!.updateEmail(newEmail);
    //       _firestore.collection('users').doc(userCredential).update({
    //         'username': newName,
    //         'email': newEmail,
    //       });
    //     } else if (oldName != newName &&
    //         oldEmail == newEmail &&
    //         oldTelepNum != newTelepNum) {
    //       _firestore.collection('users').doc(userCredential).update({
    //         'username': newName,
    //         'telepNum': newTelepNum,
    //       });
    //     } else if (oldName == newName &&
    //         oldEmail != newEmail &&
    //         oldTelepNum != newTelepNum) {
    //       if (updateRecentLogRequired) {
    //         await updateCredentials(oldEmail, oldPasword);

    //         currentUser =
    //             authforwindowsweb.FirebaseAuthDesktop.instance.currentUser;
    //       }
    //       await currentUser!.updateEmail(newEmail);
    //       _firestore.collection('users').doc(userCredential).update({
    //         'email': newEmail,
    //         'telepNum': newTelepNum,
    //       });
    //     } else if (oldName == newName &&
    //         oldEmail != newEmail &&
    //         oldTelepNum == newTelepNum) {
    //       if (updateRecentLogRequired) {
    //         await updateCredentials(oldEmail, oldPasword);

    //         currentUser =
    //             authforwindowsweb.FirebaseAuthDesktop.instance.currentUser;
    //       }
    //       await currentUser!.updateEmail(newEmail);
    //       _firestore.collection('users').doc(userCredential).update({
    //         'email': newEmail,
    //       });
    //     } else if (oldName == newName &&
    //         oldEmail == newEmail &&
    //         oldTelepNum != newTelepNum) {
    //       _firestore.collection('users').doc(userCredential).update({
    //         'telepNum': newTelepNum,
    //       });
    //     }
    //     if (updatePass) {
    //       try {
    //         if (updateRecentLogRequired && oldEmail == newEmail) {
    //           //e-posta desberdina bada iada kredentzialak eguneratu dira goian
    //           await updateCredentials(oldEmail, oldPasword);

    //           currentUser =
    //               authforwindowsweb.FirebaseAuthDesktop.instance.currentUser;
    //         }
    //         await currentUser!.updatePassword(newPassword);
    //       } on authforandroid.FirebaseAuthException catch (e) {
    //         if (e.code == 'requires-recent-login') {
    //           return 'requires-recent-login';
    //         } else if (e.code == 'wrong-password') {
    //           return 'wrong-password';
    //         } else if (e.code == 'too-many-requests') {
    //           return 'too-many-requests';
    //         } else {
    //           return 'Errorea: $e';
    //         }
    //       }
    //     }
    //     return 'Erab eguneratua';
    //   } on authforandroid.FirebaseAuthException catch (e) {
    //     if (e.code == 'requires-recent-login') {
    //       return 'requires-recent-login';
    //     } else if (e.code == 'wrong-password') {
    //       return 'wrong-password';
    //     } else if (e.code == 'too-many-requests') {
    //       return 'too-many-requests';
    //     } else {
    //       return 'Errorea: $e';
    //     }
    //   }
    // }
  }

  static Future<void> updateCredentials(
      String oldEmail, String oldPasword) async {
    // if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      authforandroid.AuthCredential credential =
          authforandroid.EmailAuthProvider.credential(
              email: oldEmail, password: oldPasword);

      await authforandroid.FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
    // } 
    // else {
    //   authforandroid.AuthCredential credential =
    //       authforandroid.EmailAuthProvider.credential(
    //           email: oldEmail, password: oldPasword);

    //   await authforwindowsweb.FirebaseAuthDesktop.instance.currentUser!
    //       .reauthenticateWithCredential(credential);
    // }
  }
}
