import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/screens/RegisterScreen.dart';
import 'package:gral_jalzas_21_22/ui/InputDecorations.dart';

import 'Background.dart';

// ignore: use_key_in_widget_constructors, camel_case_types
class LoginBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double boxPadding = (screenSize.width * 0.05);
    return Stack(
      children: [
        const Background(),
        TopLoginBox(screenSize: screenSize),
        TopLoginIcon(screenSize: screenSize),
        LoginForm(screenSize: screenSize, boxPadding: boxPadding)
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.screenSize,
    required this.boxPadding,
  }) : super(key: key);

  final Size screenSize;
  final double boxPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenSize.height * 0.25),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: boxPadding),
            child: Container(
                padding: const EdgeInsets.all(15),
                height: 300,
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
                    const SizedBox(height: 10),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecorations.loginInputDecoration(
                                hintText: 'izena.abizena@gmail.com',
                                labelText: 'E-posta',
                                textStyleColor: Colors.purple,
                                prefixIcon: Icons.email),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecorations.loginInputDecoration(
                                hintText: '*******',
                                labelText: 'Pasahitza',
                                textStyleColor: Colors.purple,
                                prefixIcon: Icons.password),
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
                              print('pressed to login');
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
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Erregistratu'),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
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
