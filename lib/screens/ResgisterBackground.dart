import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/Provider/RegisterProvider.dart';
import 'package:gral_jalzas_21_22/screens/LoginScreen.dart';
import 'package:gral_jalzas_21_22/ui/InputDecorations.dart';
import 'package:provider/provider.dart';

import 'Background.dart';
import '../logic/RegisterAuth.dart';

// ignore: use_key_in_widget_constructors, camel_case_types
class RegisterBackground extends StatelessWidget {
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
        registeFormTreatment(screenSize, boxPadding, registerFormProvider, context)
      ],
    );
  }

  SingleChildScrollView registeFormTreatment(Size screenSize, double boxPadding, RegisterProvider registerFormProvider, BuildContext context) {
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
                      // ignore: prefer_const_literals_to_create_immutables
                      boxShadow: [
                        const BoxShadow(
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
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextFormField(
                              autocorrect: false,
                              onChanged: (value) =>
                                  registerFormProvider.name = value,
                              keyboardType: TextInputType.name,
                              decoration:
                                  InputDecorations.loginInputDecoration(
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
                              decoration:
                                  InputDecorations.loginInputDecoration(
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
                              decoration:
                                  InputDecorations.loginInputDecoration(
                                      hintText: '612345678',
                                      labelText:
                                          'Sartu zure mugikor zenbakia',
                                      textStyleColor: Colors.purple,
                                      prefixIcon: Icons.phone),
                              validator: (value) {
                                String pattern =
                                    r'^(6\d{2}|7[1-9]\d{1})\d{6}$';

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
                                  'Sartu zure pasahitza',
                                  registerFormProvider),
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
                                  onChanged: (value) => registerFormProvider
                                      .confirmPass = value,
                                  obscureText: registerFormProvider.isHidden,
                                  autocorrect: false,
                                  decoration: passDecoration(
                                      'Pasahitza berretsi',
                                      registerFormProvider),
                                  validator: (value) {
                                    String pattern =
                                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&])[A-Za-z\d~`!^*\(\)\-\_+=\{\}\[\]\\\/"<>|#@$!%*?&]{8,}$';

                                    RegExp regExp = RegExp(pattern);
                                    String pasahitz1 =
                                        registerFormProvider.pass;
                                    String pasahitz2 =
                                        registerFormProvider.confirmPass;
                                    print(
                                        'Pasahitzak: -> $pasahitz1 -------- $pasahitz2');
                                    if (value != null &&
                                        regExp.hasMatch(value) &&
                                        pasahitz1 == pasahitz2) {
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
                                  RegisterAuth.registerUsingEmailPassword(
                                      name: registerFormProvider.name,
                                      email: registerFormProvider.email,
                                      password: registerFormProvider.pass,
                                      telepNum:
                                          registerFormProvider.telepNum);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
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
                  'Iada kontua duzu?',
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
