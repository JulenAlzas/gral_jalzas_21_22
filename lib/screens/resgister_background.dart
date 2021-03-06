import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/Provider/register_provider.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:gral_jalzas_21_22/screens/login_screen.dart';
import 'package:gral_jalzas_21_22/ui/input_decorations.dart';
import 'package:provider/provider.dart';

import 'package:gral_jalzas_21_22/screens/background.dart';
import '../logic/register_auth.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerFormProvider = Provider.of<RegisterProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final double boxPadding = (screenSize.width * 0.05);

    return Stack(
      children: [
        const Background(),
        TopRegisterBox(screenSize: screenSize),
        TopRegisterIcon(screenSize: screenSize),
        registeFormTreatment(
            screenSize, boxPadding, registerFormProvider, context)
      ],
    );
  }

  SingleChildScrollView registeFormTreatment(Size screenSize, double boxPadding,
      RegisterProvider registerFormProvider, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenSize.height * 0.19),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: boxPadding),
            child: Container(
                padding: const EdgeInsets.all(15),
                height: registerFormProvider.formHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 199, 237, 1),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 50.0,
                      )
                    ]),
                child: Column(
                  children: [
                    Text('Erregistratu',
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 5),
                    Form(
                      key: registerFormProvider.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            autocorrect: false,
                            onChanged: (value) =>
                                registerFormProvider.name = value,
                            keyboardType: TextInputType.name,
                            decoration: InputDecorations.loginInputDecoration(
                                hintText: 'Izena',
                                labelText: 'Zure izena',
                                textStyleColor: Colors.purple,
                                prefixIcon: Icons.pending_actions),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              } else {
                                return 'Zure izena idatz ezazu';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            onChanged: (value) =>
                                registerFormProvider.email = value,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
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
                            autocorrect: false,
                            onChanged: (value) =>
                                registerFormProvider.telepNum = value,
                            keyboardType: TextInputType.number,
                            decoration: InputDecorations.loginInputDecoration(
                                hintText: '612345678',
                                labelText: 'Sartu zure mugikor zenbakia',
                                textStyleColor: Colors.purple,
                                prefixIcon: Icons.phone),
                            validator: (value) {
                              String pattern = r'^(6\d{2}|7[1-9]\d{1})\d{6}$';

                              RegExp regExp = RegExp(pattern);
                              if (value != null && regExp.hasMatch(value)) {
                                return null;
                              } else {
                                return 'Mugikor zenbakia espainiarra izan behar du';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            onChanged: (value) =>
                                registerFormProvider.pass = value,
                            obscureText: registerFormProvider.isHidden,
                            autocorrect: false,
                            decoration: passDecoration(
                                'Sartu zure pasahitza', registerFormProvider),
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
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              TextFormField(
                                onChanged: (value) =>
                                    registerFormProvider.confirmPass = value,
                                obscureText: registerFormProvider.isHidden,
                                autocorrect: false,
                                decoration: passDecoration(
                                    'Pasahitza berretsi', registerFormProvider),
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
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                              primary: Colors.white,
                              textStyle: const TextStyle(fontSize: 20),
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () {
                              if (registerFormProvider.isValidForm()) {
                                if (registerFormProvider.pass ==
                                    registerFormProvider.confirmPass) {
                                  RegisterAuth.registerUsingEmailPassword(
                                          name: registerFormProvider.name,
                                          email: registerFormProvider.email,
                                          password: registerFormProvider.pass,
                                          telepNum:
                                              registerFormProvider.telepNum)
                                      .then((value) {
                                    if (value == 'erregistratua') {
                                      registerFormProvider.pass = '';
                                      registerFormProvider.confirmPass = '';
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                      );
                                    } else if (value == 'too-many-requests' ||
                                        value ==
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
                                                    Navigator.pop(
                                                        context, 'OK');
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
                                    } else if (value ==
                                        'requires-recent-login') {
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
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          });
                                    } else if (value ==
                                            'email-already-in-use' ||
                                        value == 'EMAIL_EXISTS') {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Errorea:'),
                                              content: const Text(
                                                  'Eposta hori jada existizen da'),
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
                                      String error = value.toString();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Errorea:'),
                                              content: Text(error),
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
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Errorea:'),
                                          content: const Text(
                                              'Pasahitzak desberdinak dira'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Jada kontua duzu?',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(' Logeatu'),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  InputDecoration passDecoration(
      String labelText, RegisterProvider registerFormProvider) {
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
          onTap: registerFormProvider.togglePasswordView,
          child: Icon(
            registerFormProvider.isHidden
                ? Icons.visibility
                : Icons.visibility_off,
          ),
        ),
        prefixIcon: const Icon(
          Icons.password,
          color: Colors.purple,
        ));
  }
}

class TopRegisterIcon extends StatelessWidget {
  const TopRegisterIcon({
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
          Icons.app_registration_rounded,
          size: screenSize.width * 0.225,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TopRegisterBox extends StatelessWidget {
  const TopRegisterBox({
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
