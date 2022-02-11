import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:gral_jalzas_21_22/screens/LoginAuth.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

class Joko1 extends StatefulWidget {
  const Joko1({Key? key}) : super(key: key);

  @override
  State<Joko1> createState() => _Joko1State();
}

class _Joko1State extends State<Joko1> {
  StreamController<int> selected = StreamController<int>();
  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.pink,
      Colors.yellow,
      Colors.purple,
    ];

    const colorizeTextStyle = TextStyle(
        fontSize: 50.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold);

    final screenSize = MediaQuery.of(context).size;

    double widthRoullette = screenSize.width - screenSize.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Lehen jokoa'),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
              onPressed: () {
                LoginAuth.signOut();
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_games.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: <Widget>[
          Container(
            width: widthRoullette,
            alignment: Alignment.topCenter,
            child: AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'ERRULETA',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                  speed: const Duration(milliseconds: 700),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.topCenter,
              height: widthRoullette,
              width: widthRoullette,
              child: FortuneWheel(
                animateFirst: false,
                selected: selected.stream,
                indicators: const <FortuneIndicator>[
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: TriangleIndicator(
                      color: Colors.black,
                    ),
                  ),
                ],
                physics: CircularPanPhysics(
                  duration: const Duration(seconds: 2),
                  curve: Curves.decelerate,
                ),
                // selected: controller.stream,
                items: const [
                  FortuneItem(
                    child: Text('Han Solo'),
                    style: FortuneItemStyle(
                      color: Colors.yellow,
                      borderWidth: 5,
                      borderColor: Colors.black,
                    ),
                  ),
                  FortuneItem(
                    child: Text('Yoda'),
                    style: FortuneItemStyle(
                      color: Colors.red,
                      borderWidth: 5,
                      borderColor: Colors.black,
                    ),
                  ),
                  FortuneItem(
                    child: Text('Obi-Wan Kenobi'),
                    style: FortuneItemStyle(
                      color: Colors.green,
                      borderWidth: 5,
                      borderColor: Colors.black,
                    ),
                  ),
                ],
                styleStrategy: const UniformStyleStrategy(
                  borderWidth: 100,
                  borderColor: Colors.black,
                ),
              ),
            ),
          ),
          FloatingActionButton.extended(
            label: const Text('SPIN'),
            icon: const Icon(Icons.restart_alt),
            backgroundColor: Colors.pink,
            onPressed: () {
              setState(() {
                selected.add(
                  Fortune.randomInt(0, 3),
                );
              });
            },
          )
        ]),
      ),
    );
  }
}
