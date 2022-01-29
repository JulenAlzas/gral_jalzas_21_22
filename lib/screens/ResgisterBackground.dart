import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/Provider/RegisterProvider.dart';
import 'package:gral_jalzas_21_22/screens/LoginBackground.dart';
import 'package:gral_jalzas_21_22/screens/LoginScreen.dart';
import 'package:gral_jalzas_21_22/ui/InputDecorations.dart';
import 'package:provider/provider.dart';

import 'Background.dart';

// ignore: use_key_in_widget_constructors, camel_case_types
class RegisterBackground extends StatelessWidget {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<RegisterProvider>(context);

    final screenSize = MediaQuery.of(context).size;
    final double boxPadding = (screenSize.width * 0.05);
    return Stack(
      children: [
        const Background(),
        TopRegisterBox(screenSize: screenSize),
        TopRegisterIcon(screenSize: screenSize),
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: boxPadding),
                child: Container(
                    padding: const EdgeInsets.all(15),
                    height: 560,
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
                          key: loginForm.formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              TextFormField(
                                autocorrect: false,
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
                                onChanged: (value) => loginFormProvider.email = value,
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
                                onChanged: (value) => loginFormProvider.pass = value;,
                                obscureText: true,
                                autocorrect: false,
                                decoration:
                                    InputDecorations.loginInputDecoration(
                                        hintText: '********',
                                        labelText: 'Sartu zure pasahitza',
                                        textStyleColor: Colors.purple,
                                        prefixIcon: Icons.password),
                                validator: (value) {
                                  String pattern =
                                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#@$!%*?&])[A-Za-z\d#@$!%*?&]{8,}$';

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
                                    controller: loginFormProvider.getConfirmPass,
                                    obscureText: true,
                                    autocorrect: false,
                                    decoration:
                                        InputDecorations.loginInputDecoration(
                                            hintText: '********',
                                            labelText: 'Pasahitza berretsi',
                                            textStyleColor: Colors.purple,
                                            prefixIcon:
                                                Icons.password_outlined),
                                    validator: (value) {
                                      String pattern =
                                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~`^\(\)\-\_+={}\[\]:;“‘<>\\\/@$!%*?&])[A-Za-z\d~`^\(\)\-\_+={}\[\]:;“‘<>\\\/@$!%*?&]{8,}$S';

                                      RegExp regExp = RegExp(pattern);
                                      final zerda= _confirmPass.value == _pass.value;
                                      print('Pasahitza:  $_confirmPass.value');
                                      print('Pass2 $_pass.value');
                                      print('ZER DA: $zerda');
                                      if (value != null &&
                                          regExp.hasMatch(value) &&
                                          _confirmPass.value == _pass.value) {
                                        return null;
                                      } else {
                                        return 'Gutxienez 8 karaktere, maiuskula bat, minuskula bat, zenbaki bat eta karaktere berezi bat';
                                      }
                                    },
                                  ),
                                  // const TextButton(
                                  //     onPressed: null,
                                  //     child: Text(
                                  //         /*_obscureText ? "Show" : "Hide"*/ 'hi'))
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
                                  loginFormProvider.isValidForm;
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
        )
      ],
    );
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
