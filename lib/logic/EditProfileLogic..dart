import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firebase_auth_desktop/firebase_auth_desktop.dart'
    as authforwindowsweb;
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fireverse/fireverse.dart';
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
        User? currentUser;
        await auth.getUser().then((user) {
          currentUser = user;
        });
        String userId = currentUser!.id.toString();

        // var auth = FireDartFirebaseAuth.instance;
        // var currentUser = Fire.currentUser;
        //   String userId = user.id;
        // String userId = currentUser!.uid;

        if (oldName == newName &&
            oldEmail == newEmail &&
            oldTelepNum == newTelepNum &&
            !updatePass) {
          return 'Eremu berak';
        }
        if (oldName != newName &&
            oldEmail != newEmail &&
            oldTelepNum != newTelepNum) {
          // if (updateRecentLogRequired) {

          //   // currentUser = Fire.currentUser;
          //   await auth.getUser().then((user) {
          //     currentUser = user;
          //    });
          // }

          // removeAddEmail(auth, newEmail, oldPasword);

          String email = '';
          String fullName = '';
          String telephNum = '';

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .get()
              .then((querySnapshot) {
            fullName = querySnapshot['username'];
            telephNum = querySnapshot['telepNum'];
            email = querySnapshot['email'];
          });

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .delete();

          auth = await deleteAccCreateNew(auth, newEmail, newPassword);

          await auth.getUser().then((user) {
            currentUser = user;
          });
          String newuserId = currentUser!.id.toString();

          await firedart.Firestore.instance
              .collection('users')
              .document(newuserId)
              .set(
            {
              'username': newName,
              'email': newEmail,
              'telepNum': newTelepNum,
              'uid': newuserId
            },
          );

          // firedart.Firestore.instance
          //     .collection('users')
          //     .document(userId)
          //     .update({
          //   'username': newName,
          //   'email': newEmail,
          //   'telepNum': newTelepNum,
          // });

          // Fire.update(collectionName: 'users', docId: userId, value: {
          //   'username': newName,
          //   'email': newEmail,
          //   'telepNum': newTelepNum,
          // });

        } else if (oldName != newName &&
            oldEmail == newEmail &&
            oldTelepNum == newTelepNum) {
          firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'username': newName,
          });
          // Fire.update(collectionName: 'users', docId: userId, value: {
          //   'username': newName,
          // });
        } else if (oldName != newName &&
            oldEmail != newEmail &&
            oldTelepNum == newTelepNum) {
          // if (updateRecentLogRequired) {
          //   await auth.getUser().then((user) {
          //     currentUser = user;
          //   });

          //   // currentUser = Fire.currentUser;
          // }

          String email = '';
          String fullName = '';
          String telephNum = '';

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .get()
              .then((querySnapshot) {
            fullName = querySnapshot['username'];
            telephNum = querySnapshot['telepNum'];
            email = querySnapshot['email'];
          });

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .delete();

          auth = await deleteAccCreateNew(auth, newEmail, newPassword);
          await auth.getUser().then((user) {
            currentUser = user;
          });

          String newuserId = currentUser!.id.toString();

          await firedart.Firestore.instance
              .collection('users')
              .document(newuserId)
              .set(
            {
              'username': newName,
              'email': newEmail,
              'telepNum': telephNum,
              'uid': newuserId
            },
          );

          // firedart.Firestore.instance
          //     .collection('users')
          //     .document(userId)
          //     .update({
          //   'username': newName,
          //   'email': newEmail,
          // });

          // Fire.update(collectionName: 'users', docId: userId, value: {
          //   'username': newName,
          //   'email': newEmail,
          // });
        } else if (oldName != newName &&
            oldEmail == newEmail &&
            oldTelepNum != newTelepNum) {
          firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'username': newName,
            'telepNum': newTelepNum,
          });
          // Fire.update(collectionName: 'users', docId: userId, value: {
          //   'username': newName,
          //   'telepNum': newTelepNum,
          // });
        } else if (oldName == newName &&
            oldEmail != newEmail &&
            oldTelepNum != newTelepNum) {
          // if (updateRecentLogRequired) {
          //   await auth.getUser().then((user) {
          //     currentUser = user;
          //   });

          //   // currentUser = Fire.currentUser;
          // }
          String email = '';
          String fullName = '';
          String telephNum = '';

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .get()
              .then((querySnapshot) {
            fullName = querySnapshot['username'];
            telephNum = querySnapshot['telepNum'];
            email = querySnapshot['email'];
          });

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .delete();

          auth = await deleteAccCreateNew(auth, newEmail, newPassword);

          await auth.getUser().then((user) {
            currentUser = user;
          });

          String newuserId = currentUser!.id.toString();

          await firedart.Firestore.instance
              .collection('users')
              .document(newuserId)
              .set(
            {
              'username': fullName,
              'email': newEmail,
              'telepNum': newTelepNum,
              'uid': newuserId
            },
          );

          // firedart.Firestore.instance
          //     .collection('users')
          //     .document(userId)
          //     .update({
          //   'username': newName,
          //   'email': newEmail,
          //   'telepNum': newTelepNum,
          // });

          // Fire.update(collectionName: 'users', docId: userId, value: {
          //   'email': newEmail,
          //   'telepNum': newTelepNum,
          // });
        } else if (oldName == newName &&
            oldEmail != newEmail &&
            oldTelepNum == newTelepNum) {
          // if (updateRecentLogRequired) {
          //   await auth.getUser().then((user) {
          //     currentUser = user;
          //   });

          //   // currentUser = Fire.currentUser;
          // }

          String email = '';
          String fullName = '';
          String telephNum = '';

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .get()
              .then((querySnapshot) {
            fullName = querySnapshot['username'];
            telephNum = querySnapshot['telepNum'];
            email = querySnapshot['email'];
          });

          await firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .delete();

          auth = await deleteAccCreateNew(auth, newEmail, newPassword);

          await auth.getUser().then((user) {
            currentUser = user;
          });
          String newuserId = currentUser!.id.toString();

          await firedart.Firestore.instance
              .collection('users')
              .document(newuserId)
              .set(
            {
              'username': fullName,
              'email': newEmail,
              'telepNum': telephNum,
              'uid': newuserId
            },
          );

          // firedart.Firestore.instance
          //     .collection('users')
          //     .document(userId)
          //     .update({
          //   'username': newName,
          //   'email': newEmail,
          //   'telepNum': newTelepNum,
          // });

          // Fire.update(collectionName: 'users', docId: userId, value: {
          //   'email': newEmail,
          // });
        } else if (oldName == newName &&
            oldEmail == newEmail &&
            oldTelepNum != newTelepNum) {
          firedart.Firestore.instance
              .collection('users')
              .document(userId)
              .update({
            'telepNum': newTelepNum,
          });
        }
        if (updatePass) {
          try {
            // if (updateRecentLogRequired && oldEmail == newEmail) {
            //   //e-posta desberdina bada iada kredentzialak eguneratu dira goian
            //   await auth.getUser().then((user) {
            //     currentUser = user;
            //   });
            //   // currentUser = Fire.currentUser;
            // }
            await auth.changePassword(newPassword);
            auth.signOut();
            auth.signIn(newEmail, newPassword);

            //  await auth.changePassword(newPassword);
          } catch (e) {
            return 'Errorea: $e';
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
