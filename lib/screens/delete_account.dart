import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/auth/user_gateway.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/logic/delete_account_logic.dart';
import 'package:gral_jalzas_21_22/screens/edit_profile.dart';
import 'package:gral_jalzas_21_22/screens/login_home.dart';
import 'package:gral_jalzas_21_22/screens/login_screen.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:firedart/firedart.dart' as firedart;

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  GlobalKey<FormState> formEditProfKey = GlobalKey<FormState>();

  bool _mustWriteOldPassWell = false;

  String _email = '';
  String _oldpassw = '';

  int passWrongCount = -1;
  int wrongPassCount = 0;

  bool _isHidden = true;
  bool _isHiddenOld = true;
  bool _isLoading = false;

  bool updateRecentLogRequired = false;

  @override
  void initState() {
    getUserEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const Color eremuKolorea = Colors.white;

    return WillPopScope(
      onWillPop: () async {
        if (_mustWriteOldPassWell) {
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
                Text('Profila Ezabatu',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Form(
            key: formEditProfKey,
            child: Column(
              children: [
                userFieldEmail(screenSize, eremuKolorea, 'E-posta',
                    'Sartu zure e-posta', _email, 'e-posta'),
                userFieldPass(screenSize, eremuKolorea, 'Pasahitz zaharra',
                    'Sartu zure pasahitz zaharra', _oldpassw),
                const SizedBox(height: 5),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {
                      if (isValidForm()) {
                        DeleteAccountLogic.deleteProfile(
                          oldEmail: _email,
                          oldPasword: _oldpassw,
                        ).then((String? profileEditResult) {
                          if (profileEditResult == 'Erab ezabatua') {
                            setState(() {
                              wrongPassCount = 0;
                              _mustWriteOldPassWell = false;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Mezua'),
                                    content:
                                        const Text('Erabiltzailea ezabatu da.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                            LoginAuth.signOut().then((value) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
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
                                        'Firebase kautotze kuota maximora iritxi zara. Berlogeatu eta saiatu geroago.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                          LoginAuth.signOut().then((value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Homepage()),
                                            );
                                          });
                                        },
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
                    child: const Text('Ezabatu'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Center userFieldEmail(Size screenSize, Color eremuKolorea, String labeltext,
      String hintext, String initialText, String mota) {
    return Center(
      child: SizedBox(
        width: screenSize.width * 0.85,
        child: TextFormField(
            enabled: false,
            style: TextStyle(color: eremuKolorea),
            initialValue: initialText,
            onChanged: (changedValue) {
              setState(() {
                _email = changedValue;
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
              width: screenSize.width * 0.85,
              child: TextFormField(
                obscureText: _isHidden,
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
                  String pattern =
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&])[A-Za-z\d~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&]{8,}$';

                  RegExp regExp = RegExp(pattern);
                  if (value != null && regExp.hasMatch(value)) {
                    return null;
                  } else {
                    return 'Passhitz zaharrak gutxienez 8 karaktere, maiuskula bat, minuskula bat, zenbaki bat eta karaktere berezi bat';
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
              String pattern =
                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&])[A-Za-z\d~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&]{8,}$';

              RegExp regExp = RegExp(pattern);
              if (value != null && regExp.hasMatch(value)) {
                return null;
              } else {
                return 'Gutxienez 8 karaktere, maiuskula bat, minuskula bat, zenbaki bat eta karaktere berezi bat';
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
      title: const Text('Lehen jokoa'),
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
    setState(() {
      _isLoading = true;
    });
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
