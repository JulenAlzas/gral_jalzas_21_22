import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gral_jalzas_21_22/logic/EditProfile.dart';
import 'package:gral_jalzas_21_22/logic/LoginAuth.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> formEditProfKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String _fullName = '';
  String _email = '';
  String _telephNum = '';
  String _passw = '*******';

  String _oldfullName = '';
  String _oldemail = '';
  String _oldtelephNum = '';

  bool _isHidden = true;
  bool _isLoading = false;
  bool _isSwitched = true;

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

    return Scaffold(
      appBar: appBarDetails(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                const BackgroundHome(),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 15),
                      Container(
                        height: 25,
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
                                  image: AssetImage(
                                      'assets/profile-no-image.jpg'))),
                        ),
                      ),
                      Form(
                        key: formEditProfKey,
                        child: Column(
                          children: [
                            Center(
                              child: SizedBox(
                                width: screenSize.width * 0.85,
                                child: TextFormField(
                                    style: const TextStyle(color: eremuKolorea),
                                    initialValue: _fullName,
                                    onChanged: (changedValue) {
                                      setState(() {
                                        _fullName = changedValue;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: eremuKolorea,
                                                width: 2.0)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: eremuKolorea)),
                                        errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2.0)),
                                        labelStyle:
                                            TextStyle(color: eremuKolorea),
                                        errorStyle:
                                            TextStyle(color: Colors.black),
                                        labelText: 'Izena',
                                        hintText: 'Sartu zure izena',
                                        hintStyle:
                                            TextStyle(color: eremuKolorea)),
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Zure izena idatz ezazu';
                                      }
                                    }),
                              ),
                            ),
                            // userField(screenSize, eremuKolorea, 'Izena',
                            //     'Sartu zure izena', _fullName, 'izena'),
                            const SizedBox(height: 5),
                            userField(screenSize, eremuKolorea, 'E-posta',
                                'Sartu zure e-posta', _email, 'e-posta'),
                            const SizedBox(height: 5),
                            userFieldPass(screenSize, eremuKolorea, 'Pasahitza',
                                'Sartu zure pasahitza', _passw),
                            const SizedBox(height: 5),
                            userField(
                                screenSize,
                                eremuKolorea,
                                'Mugikorra',
                                'Sartu mugikor zenbakia',
                                _telephNum,
                                'mzenbakia'),
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
                                            updatePass: _isSwitched)
                                        .then((String? profileEditResult) {
                                      if (profileEditResult == 'Eremu berak') {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Error'),
                                                content: const Text(
                                                    'Ez dira eremu berak eguneratuko'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            });
                                      } else if (profileEditResult ==
                                          'Erab eguneratua') {
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
                                                        Navigator.pop(
                                                            context, 'OK'),
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
                                                title: const Text('Error'),
                                                content: Text(profileEditResult
                                                    .toString()),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            });
                                      }
                                      setState(() {
                                        _oldemail = _email;
                                        _oldfullName = _fullName;
                                        _oldtelephNum = _telephNum;
                                      });
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
                  // setState(() {
                  _fullName = changedValue;
                  // });
                } else if (mota == 'e-posta') {
                  // setState(() {
                  _email = changedValue;
                  // });
                } else if (mota == 'mzenbakia') {
                  // setState(() {
                  _telephNum = changedValue;
                  // });
                }
              });
            },
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: eremuKolorea, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: eremuKolorea)),
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0)),
                labelStyle: TextStyle(color: eremuKolorea),
                errorStyle: const TextStyle(color: Colors.black),
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
            SizedBox(width:  screenSize.width * 0.01,),
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
                      onTap: togglePasswordView,
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                    )),
                validator: (value) {
                  if(_isSwitched){
                    String pattern =
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&])[A-Za-z\d~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&]{8,}$';
            
                  RegExp regExp = RegExp(pattern);
                  if (value != null && regExp.hasMatch(value)) {
                    return null;
                  } else {
                    return 'Gutxienez 8 karaktere, maiuskula bat, minuskula bat, zenbaki bat eta karaktere berezi bat';
                  }
                  }else{
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
    User? user = FirebaseAuth.instance.currentUser;

    setState(() {
      _email = user!.email!;
    });
  }

  Future<String?> getOtherUserParams() async {
    // if (!enteredOnEditProfile) {
    setState(() {
      _isLoading = true;
    });
    String userCred = FirebaseAuth.instance.currentUser?.uid ?? 'no-id';
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
    // }

    setState(() {
      _isLoading = false;
    });
  }

  void togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
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
