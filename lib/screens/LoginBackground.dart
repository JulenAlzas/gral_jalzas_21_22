import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firebase_auth_desktop/firebase_auth_desktop.dart'
    as authforwindowsweb;
import 'package:firedart/firedart.dart' as firedart;
// import 'package:fireverse/fireverse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/Provider/LoginProvider.dart';
import 'package:gral_jalzas_21_22/logic/LoginAuth.dart';
import 'package:gral_jalzas_21_22/screens/LoginHome.dart';
import 'package:gral_jalzas_21_22/screens/RegisterScreen.dart';
import 'package:gral_jalzas_21_22/ui/InputDecorations.dart';
import 'package:provider/provider.dart';

import 'Background.dart';

class LoginBackground extends StatefulWidget {
  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginProvider>(context);

    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      authforandroid.FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginHome()),
          );
        }
      });
    }
    // if (defaultTargetPlatform == TargetPlatform.windows ||
    //     defaultTargetPlatform == TargetPlatform.linux) {
    //   var auth = firedart.FirebaseAuth.instance.;
    //   if (auth.isSignedIn) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const LoginHome()),
    //     );
    //   }
    // }
    Future.microtask(() {
      if (firedart.FirebaseAuth.instance.isSignedIn) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginHome()));
      }
    });
    // }
    // else if (defaultTargetPlatform == TargetPlatform.windows ||
    //     defaultTargetPlatform == TargetPlatform.linux) {
    //   authforwindowsweb.FirebaseAuthDesktop.instance
    //       .authStateChanges()
    //       .listen((user) {
    //     if (user != null) {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => const LoginHome()),
    //       );
    //     }
    //   });
    // }

    final screenSize = MediaQuery.of(context).size;
    final double boxPadding = (screenSize.width * 0.05);

    return Stack(
      children: [
        const Background(),
        TopLoginBox(screenSize: screenSize),
        TopLoginIcon(screenSize: screenSize),
        loginFormTreatment(screenSize, boxPadding, loginFormProvider, context),
      ],
    );
  }

  SingleChildScrollView loginFormTreatment(Size screenSize, double boxPadding,
      LoginProvider loginFormProvider, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenSize.height * 0.25),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: boxPadding),
            child: Container(
                padding: const EdgeInsets.all(15),
                height: loginFormProvider.formHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 199, 237, 1),
                    borderRadius: BorderRadius.circular(25),
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black45,
                        blurRadius: 50.0,
                      )
                    ]),
                child: Column(
                  children: [
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 5),
                    Form(
                      key: loginFormProvider.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) =>
                                loginFormProvider.email = value,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecorations.loginInputDecoration(
                                hintText: 'izena.abizena@gmail.com',
                                labelText: 'Sartu zure e-posta',
                                textStyleColor: Colors.purple,
                                prefixIcon: Icons.email),
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
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            onChanged: (value) =>
                                loginFormProvider.pass = value,
                            obscureText: _isHidden,
                            autocorrect: false,
                            decoration: passDecoration('Sartu zure pasahitza'),
                            validator: (value) {
                              String pattern =
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&])[A-Za-z\d~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&]{8,}$';

                              RegExp regExp = RegExp(pattern);

                              if (value != null && regExp.hasMatch(value)) {
                                return null;
                              } else {
                                return 'Pasahitz desegokia';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                              primary: Colors.white,
                              textStyle: const TextStyle(fontSize: 20),
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () {
                              if (loginFormProvider.isValidForm()) {
                                LoginAuth.loginUsingEmailPassword(
                                        email: loginFormProvider.email,
                                        password: loginFormProvider.pass)
                                    .then((String loginResult) {
                                  if (loginResult == "Ondo Logeatu zara") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginHome()),
                                    );
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: Text(loginResult),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                });
                              }
                            },
                            child: const Text('Sartu'),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
          const SizedBox(height: 40),
          const NoAccountSituation(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  InputDecoration passDecoration(String labelText) {
    return InputDecoration(
        errorMaxLines: 2,
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2.0)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purple)),
        hintText: '********',
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.purple),
        suffix: InkWell(
          onTap: _togglePasswordView,
          child: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        prefixIcon: const Icon(
          Icons.password,
          color: Colors.purple,
        ));
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}

class NoAccountSituation extends StatelessWidget {
  const NoAccountSituation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Ez duzu kontua?',
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          },
          child: const Text('Erregistratu'),
        ),
      ],
    );
  }
}

class TopLoginIcon extends StatelessWidget {
  const TopLoginIcon({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        child: Icon(
          Icons.person_pin_circle,
          size: screenSize.width * 0.225,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TopLoginBox extends StatelessWidget {
  const TopLoginBox({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromRGBO(191, 0, 239, 1),
            Color.fromARGB(255, 204, 0, 102)
          ])),
    );
  }
}
