import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:gral_jalzas_21_22/logic/LoginAuth.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

class Joko1 extends StatefulWidget {
  const Joko1({Key? key}) : super(key: key);

  @override
  State<Joko1> createState() => _Joko1State();
}

class _Joko1State extends State<Joko1> {
  StreamController<int> selected = StreamController<int>();
  int selectedInt = 0;
  int selectedIndex = -1;
  Color spinColor = Colors.grey;
  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> fruitImages = [
      'assets/Apple.png',
      'assets/Banana.png',
      'assets/blackberry.png',
      'assets/Lemon.png',
      'assets/orange.png',
      'assets/raspberry.png'
    ];

    const colorizeColors = [
      Colors.white,
      Colors.pink,
      Colors.yellow,
      Colors.purple,
    ];

    const colorizeTextStyle = TextStyle(
        fontSize: 50.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold);

    final screenSize = MediaQuery.of(context).size;
    double widthRoullette = 0.0;
    double heightRoullette = 0.0;
    double heightBuilder = 0.0;
    double widthBuilder = 0.0;

    if (defaultTargetPlatform == TargetPlatform.android) {
      widthRoullette = screenSize.width - screenSize.width * 0.05;
      heightRoullette = widthRoullette;
      widthBuilder = screenSize.width * 0.85;
      heightBuilder = screenSize.height * 0.15;
    } else {
      widthRoullette = screenSize.height * 0.6;
      heightRoullette = widthRoullette;
      widthBuilder = screenSize.width * 0.38;
      heightBuilder = screenSize.height * 0.15;
    }

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
      body: SingleChildScrollView(
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: widthBuilder,
                height: heightBuilder,
                color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Hautatu fruitu bat',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fruitImages.length,
                        itemBuilder: (_, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                spinColor = Colors.pink;
                              });
                            },
                            child: Hero(
                              tag: fruitImages[index],
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: selectedIndex == index
                                      ? Colors.blue.withOpacity(0.5)
                                      : Colors.transparent,
                                  width: screenSize.height * 0.1,
                                  height: screenSize.height * 0.1,
                                  margin: const EdgeInsets.all(10),
                                  child: FadeInImage(
                                    placeholder:
                                        const AssetImage('assets/no-image.jpg'),
                                    image: AssetImage(fruitImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.topCenter,
                height: heightRoullette,
                width: widthRoullette,
                child: FortuneWheel(
                  onAnimationEnd: () {
                    if (selectedInt == selectedIndex) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('IRABAZI DUZU!!',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold)),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('GALDU DUZU!!',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold)),
                            );
                          });
                    }
                  },
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
                  items: [
                    FortuneItem(
                      child: Transform.rotate(
                        angle: -11,
                        child: Image.asset(
                          fruitImages[0],
                          height: screenSize.height * 0.1,
                          width: screenSize.height * 0.1,
                        ),
                      ),
                      style: const FortuneItemStyle(
                        color: Colors.yellow,
                        borderWidth: 5,
                        borderColor: Colors.black,
                      ),
                    ),
                    FortuneItem(
                      child: Transform.rotate(
                        angle: -11,
                        child: Image.asset(
                          fruitImages[1],
                          height: screenSize.height * 0.1,
                          width: screenSize.height * 0.1,
                        ),
                      ),
                      style: const FortuneItemStyle(
                        color: Colors.red,
                        borderWidth: 5,
                        borderColor: Colors.black,
                      ),
                    ),
                    FortuneItem(
                      child: Transform.rotate(
                        angle: -5.2,
                        child: Image.asset(
                          fruitImages[2],
                          height: screenSize.height * 0.1,
                          width: screenSize.height * 0.1,
                        ),
                      ),
                      style: const FortuneItemStyle(
                        color: Colors.green,
                        borderWidth: 5,
                        borderColor: Colors.black,
                      ),
                    ),
                    FortuneItem(
                      child: Transform.rotate(
                        angle: -11,
                        child: Image.asset(
                          fruitImages[3],
                          height: screenSize.height * 0.1,
                          width: screenSize.height * 0.1,
                        ),
                      ),
                      style: const FortuneItemStyle(
                        color: Colors.orange,
                        borderWidth: 5,
                        borderColor: Colors.black,
                      ),
                    ),
                    FortuneItem(
                      child: Transform.rotate(
                        angle: -5.2,
                        child: Image.asset(
                          fruitImages[4],
                          height: screenSize.height * 0.1,
                          width: screenSize.height * 0.1,
                        ),
                      ),
                      style: const FortuneItemStyle(
                        color: Colors.blue,
                        borderWidth: 5,
                        borderColor: Colors.black,
                      ),
                    ),
                    FortuneItem(
                      child: Transform.rotate(
                        angle: -11,
                        child: Image.asset(
                          fruitImages[5],
                          height: screenSize.height * 0.1,
                          width: screenSize.height * 0.1,
                        ),
                      ),
                      style: const FortuneItemStyle(
                        color: Colors.yellow,
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
              backgroundColor: spinColor,
              onPressed: () {
                if (selectedIndex != -1) {
                  setState(() {
                    spinColor = Colors.pink;
                    selected.add(
                      selectedInt = Fortune.randomInt(0, fruitImages.length),
                    );
                  });
                } else {
                  // setState(() {
                  //   spinColor=Colors.grey;
                  // });
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
