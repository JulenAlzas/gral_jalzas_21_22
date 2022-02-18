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
  int selectedRandomInt = 0;
  int selectedIndexOfFruits = -1;
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
      appBar: appBarInfo(context),
      body: Stack(
        children: [
        const GameBackground(),
        gameContent(widthRoullette, colorizeTextStyle, colorizeColors, widthBuilder, heightBuilder, fruitImages, screenSize, heightRoullette, context)
        ],
      ),
    );
  }

  SingleChildScrollView gameContent(double widthRoullette, TextStyle colorizeTextStyle, List<Color> colorizeColors, double widthBuilder, double heightBuilder, List<String> fruitImages, Size screenSize, double heightRoullette, BuildContext context) {
    return SingleChildScrollView(
          child: Column(
          children: <Widget>[
            testuAnimatuaContainer(widthRoullette, colorizeTextStyle, colorizeColors),
            fruituAukeraketa(widthBuilder, heightBuilder, fruitImages, screenSize),
            erruletaInplementazioa(heightRoullette, widthRoullette, context, fruitImages, screenSize),
            botoiInplementazioa(fruitImages),
          ],
                ),
        );
  }

  Container testuAnimatuaContainer(double widthRoullette, TextStyle colorizeTextStyle, List<Color> colorizeColors) {
    return Container(
            width: widthRoullette,
            alignment: Alignment.topCenter,
            child: testuAnimatua(colorizeTextStyle, colorizeColors),
          );
  }

  FloatingActionButton botoiInplementazioa(List<String> fruitImages) {
    return FloatingActionButton.extended(
            label: const Text('SPIN'),
            icon: const Icon(Icons.restart_alt),
            backgroundColor: spinColor,
            onPressed: () {
              if (selectedIndexOfFruits != -1) {
                setState(() {
                  spinColor = Colors.pink;
                  selected.add(
                    selectedRandomInt =
                        Fortune.randomInt(0, fruitImages.length),
                  );
                });
              } else {
                // setState(() {
                //   spinColor=Colors.grey;
                // });
              }
            },
          );
  }

  Align erruletaInplementazioa(double heightRoullette, double widthRoullette, BuildContext context, List<String> fruitImages, Size screenSize) {
    return Align(
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.topCenter,
              height: heightRoullette,
              width: widthRoullette,
              child: FortuneWheel(
                onAnimationEnd: () {
                  if (selectedRandomInt == selectedIndexOfFruits) {
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
          );
  }

  ClipRRect fruituAukeraketa(double widthBuilder, double heightBuilder, List<String> fruitImages, Size screenSize) {
    return ClipRRect(
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
                              selectedIndexOfFruits = index;
                              spinColor = Colors.pink;
                            });
                          },
                          child: Hero(
                            tag: fruitImages[index],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: selectedIndexOfFruits == index
                                    ? Colors.blue.withOpacity(0.5)
                                    : Colors.transparent,
                                width: screenSize.height * 0.1,
                                height: screenSize.height * 0.1,
                                margin: const EdgeInsets.all(10),
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      'assets/no-image.jpg'),
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
          );
  }

  AnimatedTextKit testuAnimatua(TextStyle colorizeTextStyle, List<Color> colorizeColors) {
    return AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'ERRULETA',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                  speed: const Duration(milliseconds: 700),
                ),
              ],
              totalRepeatCount: 1,
            );
  }

  AppBar appBarInfo(BuildContext context) {
    return AppBar(
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
    );
  }
}

class GameBackground extends StatelessWidget {
  const GameBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background_games.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
