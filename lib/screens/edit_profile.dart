import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/logic/edit_profile_logic.dart';
import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/screens/login_home.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart' as firedart;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> formEditProfKey = GlobalKey<FormState>();

  bool _mustWriteOldPassWell = false;

  String _fullName = '';
  String _email = '';
  String _telephNum = '';
  String _passw = '*******';
  String _oldpassw = '';

  String _oldfullName = '';
  String _oldemail = '';
  String _oldtelephNum = '';

  int passWrongCount = -1;
  int wrongPassCount = 0;

  bool _isHidden = true;
  bool _isHiddenOld = true;
  bool _isLoading = false;
  bool _isSwitched = true;
  bool _oldPassisVisible = false;
  bool updateRecentLogRequired = false;

  @override
  void initState() {
    getUserEmail();
    getOtherUserParams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const Color eremuKolorea = Colors.white;

    return WillPopScope(
      onWillPop: () async {
        if (_mustWriteOldPassWell && (Platform.isLinux || Platform.isWindows)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Pasahitz zaharra ondo jar ezazu edo berlogeatu.')));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginHome()));
        }
        return false;
      },
      child: Scaffold(
        appBar: appBarDetails(context),
        body: _isLoading
            ? const KargatzeAnimazioa()
            : orrialdeKargatuaErakutsi(screenSize, eremuKolorea, context),
      ),
    );
  }

  Stack orrialdeKargatuaErakutsi(
      Size screenSize, Color eremuKolorea, BuildContext context) {
    return Stack(
      children: [
        const BackgroundHome(),
        showScrollViewPage(screenSize, eremuKolorea, context)
      ],
    );
  }

  SingleChildScrollView showScrollViewPage(
      Size screenSize, Color eremuKolorea, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 15),
          Container(
            height: screenSize.height * 0.1,
            padding: const EdgeInsets.only(left: 30),
            child: ListView(
              children: const [
                Text('Profila Aldatu',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1))
                  ],
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/profile-no-image.jpg'))),
            ),
          ),
          Form(
            key: formEditProfKey,
            child: Column(
              children: [
                userField(screenSize, eremuKolorea, 'Izena', 'Sartu zure izena',
                    _fullName, 'izena'),
                const SizedBox(height: 5),
                userField(screenSize, eremuKolorea, 'E-posta',
                    'Sartu zure e-posta', _email, 'e-posta'),
                const SizedBox(height: 5),
                userFieldPass(screenSize, eremuKolorea, 'Pasahitz berria',
                    'Sartu zure pasahitz berria', _passw),
                const SizedBox(height: 5),
                Visibility(
                  visible: _oldPassisVisible,
                  child: userOldFieldPass(
                      screenSize,
                      eremuKolorea,
                      'Pasahitz zaharra',
                      'Sartu zure pasahitz zaharra',
                      _oldpassw),
                ),
                const SizedBox(height: 5),
                userField(screenSize, eremuKolorea, 'Mugikorra',
                    'Sartu mugikor zenbakia', _telephNum, 'mzenbakia'),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {
                      if (isValidForm()) {
                        EditProfileLogic.editUserProfile(
                          oldName: _oldfullName,
                          oldEmail: _oldemail,
                          oldTelepNum: _oldtelephNum,
                          newName: _fullName,
                          newEmail: _email,
                          newPassword: _passw,
                          newTelepNum: _telephNum,
                          updatePass: _isSwitched,
                          oldPasword: _oldpassw,
                          updateRecentLogRequired: updateRecentLogRequired,
                        ).then((String? profileEditResult) {
                          if (profileEditResult == 'Eremu berak') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Errorea:'),
                                    content: const Text(
                                        'Ez dira eremu berak eguneratuko'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (profileEditResult == 'Erab eguneratua') {
                            setState(() {
                              _oldPassisVisible = false;
                              updateRecentLogRequired = false;
                              _oldpassw = '';
                              wrongPassCount = 0;
                              _mustWriteOldPassWell = false;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Mezua'),
                                    content: const Text(
                                        'Erabiltzailearen informazioa eguneratu da.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                            setState(() {
                              _oldemail = _email;
                              _oldfullName = _fullName;
                              _oldtelephNum = _telephNum;
                            });
                          } else if (profileEditResult ==
                              'requires-recent-login') {
                            setState(() {
                              _oldPassisVisible = true;
                              updateRecentLogRequired = true;
                            });

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Errorea:'),
                                    content: const Text(
                                        'Pasahitz/Eposta aldatzeak orain dela gutxiko logeatzea behar du. Sartu pasahitz zaharra.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (profileEditResult ==
                              'requires-oldpass-updateDB') {
                            setState(() {
                              _oldPassisVisible = true;
                              _mustWriteOldPassWell = true;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Errorea:'),
                                    content: const Text(
                                        'Eposta aldatzeko pasahitz zaharraren beharra dago'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (profileEditResult == 'wrong-password') {
                            setState(() {
                              wrongPassCount++;
                              _mustWriteOldPassWell = true;
                            });

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Errorea:'),
                                    content: Text(
                                        'Pasahitz zaharraren erroreak: $wrongPassCount'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (profileEditResult == 'too-many-requests' ||
                              profileEditResult ==
                                  'TOO_MANY_ATTEMPTS_TRY_LATER') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Errorea:'),
                                    content: const Text(
                                        'Firebase kautotze kuota maximora iritxi zara. Berlogeatu eta saiatu geroago'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                          LoginAuth.signOut();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Homepage()),
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (profileEditResult ==
                              'email-already-in-use') {
                            setState(() {
                              wrongPassCount++;
                              _mustWriteOldPassWell = true;
                            });

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Errorea:'),
                                    content: const Text(
                                        'Eposta hori iada existizen da'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Errorea:'),
                                    content: Text(profileEditResult.toString()),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      }
                    },
                    child: const Text('Aldatu'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Center userField(Size screenSize, Color eremuKolorea, String labeltext,
      String hintext, String initialText, String mota) {
    return Center(
      child: SizedBox(
        width: screenSize.width * 0.85,
        child: TextFormField(
            style: TextStyle(color: eremuKolorea),
            initialValue: initialText,
            onChanged: (changedValue) {
              setState(() {
                if (mota == 'izena') {
                  _fullName = changedValue;
                } else if (mota == 'e-posta') {
                  _email = changedValue;
                } else if (mota == 'mzenbakia') {
                  _telephNum = changedValue;
                }
              });
            },
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: eremuKolorea, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: eremuKolorea)),
                errorStyle: const TextStyle(color: Colors.black),
                focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0)),
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0)),
                labelStyle: TextStyle(color: eremuKolorea),
                labelText: labeltext,
                hintText: hintext,
                hintStyle: TextStyle(color: eremuKolorea)),
            validator: (value) {
              if (mota == 'izena') {
                if (value != null && value.isNotEmpty) {
                  return null;
                } else {
                  return 'Zure izena idatz ezazu';
                }
              } else if (mota == 'e-posta') {
                String pattern =
                    r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';

                RegExp regExp = RegExp(pattern);
                if (value != null &&
                    regExp.hasMatch(value) &&
                    value.length <= 254) {
                  return null;
                } else {
                  return 'E-posta ez da zuzena';
                }
              } else if (mota == 'mzenbakia') {
                String pattern = r'^(6\d{2}|7[1-9]\d{1})\d{6}$';

                RegExp regExp = RegExp(pattern);
                if (value != null && regExp.hasMatch(value)) {
                  return null;
                } else {
                  return 'Mugikor zenbakia espainiarra izan behar du';
                }
              }
            }),
      ),
    );
  }

  Center userFieldPass(Size screenSize, Color eremuKolorea, String labeltext,
      String hintext, String initialText) {
    return Center(
      child: SizedBox(
        width: screenSize.width * 0.85,
        child: Row(
          children: [
            SizedBox(
              width: screenSize.width * 0.09,
              child: Switch(
                value: _isSwitched,
                onChanged: (value) {
                  setState(() {
                    _isSwitched = !_isSwitched;
                  });
                },
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.01,
            ),
            SizedBox(
              width: screenSize.width * 0.75,
              child: TextFormField(
                enabled: _isSwitched,
                obscureText: _isHidden,
                style: TextStyle(color: eremuKolorea),
                initialValue: initialText,
                onChanged: (changedValue) {
                  setState(() {
                    _passw = changedValue;
                  });
                },
                decoration: InputDecoration(
                    errorMaxLines: 2,
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: eremuKolorea, width: 2.0)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: eremuKolorea)),
                    labelStyle: TextStyle(color: eremuKolorea),
                    errorStyle: const TextStyle(color: Colors.black),
                    focusedErrorBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0)),
                    errorBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0)),
                    labelText: labeltext,
                    hintText: hintext,
                    hintStyle: TextStyle(color: eremuKolorea),
                    suffix: InkWell(
                      onTap: togglePasswordView,
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                    )),
                validator: (value) {
                  if (_isSwitched) {
                    String pattern =
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&])[A-Za-z\d~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&]{8,}$';

                    RegExp regExp = RegExp(pattern);
                    if (value != null && regExp.hasMatch(value)) {
                      return null;
                    } else {
                      return 'Gutxienez 8 karaktere, maiuskula bat, minuskula bat, zenbaki bat eta karaktere berezi bat';
                    }
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center userOldFieldPass(Size screenSize, Color eremuKolorea, String labeltext,
      String hintext, String initialText) {
    return Center(
      child: SizedBox(
        width: screenSize.width * 0.85,
        child: SizedBox(
          width: screenSize.width * 0.75,
          child: TextFormField(
            obscureText: _isHiddenOld,
            style: TextStyle(color: eremuKolorea),
            initialValue: initialText,
            onChanged: (changedValue) {
              setState(() {
                _oldpassw = changedValue;
              });
            },
            decoration: InputDecoration(
                errorMaxLines: 2,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: eremuKolorea, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: eremuKolorea)),
                labelStyle: TextStyle(color: eremuKolorea),
                errorStyle: const TextStyle(color: Colors.black),
                focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0)),
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0)),
                labelText: labeltext,
                hintText: hintext,
                hintStyle: TextStyle(color: eremuKolorea),
                suffix: InkWell(
                  onTap: toggleOldPasswordView,
                  child: Icon(
                    _isHiddenOld ? Icons.visibility : Icons.visibility_off,
                  ),
                )),
            validator: (value) {
              if (_oldPassisVisible) {
                String pattern =
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&])[A-Za-z\d~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&]{8,}$';

                RegExp regExp = RegExp(pattern);
                if (value != null && regExp.hasMatch(value)) {
                  return null;
                } else {
                  return 'Gutxienez 8 karaktere, maiuskula bat, minuskula bat, zenbaki bat eta karaktere berezi bat';
                }
              } else {
                return null;
              }
            },
          ),
        ),
      ),
    );
  }

  AppBar appBarDetails(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink,
      title: const Text('Profila aldatu'),
      elevation: 0,
      actions: [
        TextButton.icon(
            onPressed: () {
              LoginAuth.signOut();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Homepage()),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: const Text(
              'Atera',
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  void getUserEmail() async {
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      authforandroid.User? user =
          authforandroid.FirebaseAuth.instance.currentUser;
      setState(() {
        _email = user!.email!;
      });
    } else {
      var auth = firedart.FirebaseAuth.instance;
      User? currentUser;

      await auth.getUser().then((user) {
        currentUser = user;
      });

      setState(() {
        _email = currentUser!.email!;
      });
    }
  }

  Future<String?> getOtherUserParams() async {
    setState(() {
      _isLoading = true;
    });
    String userCred = '';
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      userCred =
          authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred)
          .get()
          .then((querySnapshot) {
        setState(() {
          _fullName = querySnapshot['username'];
          _telephNum = querySnapshot['telepNum'];
        });
        setState(() {
          _oldemail = _email;
          _oldfullName = _fullName;
          _oldtelephNum = _telephNum;
        });
      });
    } else {
      await firedart.FirebaseAuth.instance.getUser().then((user) {
        userCred = user.id;
      });
      await Firestore.instance
          .collection('users')
          .document(userCred)
          .get()
          .then((querySnapshot) {
        setState(() {
          _fullName = querySnapshot['username'];
          _telephNum = querySnapshot['telepNum'];
        });
        setState(() {
          _oldemail = _email;
          _oldfullName = _fullName;
          _oldtelephNum = _telephNum;
        });
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void toggleOldPasswordView() {
    setState(() {
      _isHiddenOld = !_isHiddenOld;
    });
  }

  bool isValidForm() {
    return formEditProfKey.currentState?.validate() ?? false;
  }
}

class KargatzeAnimazioa extends StatelessWidget {
  const KargatzeAnimazioa({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class BackgroundHome extends StatelessWidget {
  const BackgroundHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment(0.4, 0.5),
          colors: <Color>[
            Color.fromARGB(235, 153, 0, 76),
            Color.fromARGB(235, 204, 0, 102)
          ],
          tileMode: TileMode.repeated,
        ),
      ),
    );
  }
}
