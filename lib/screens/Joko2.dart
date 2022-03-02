import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:gral_jalzas_21_22/logic/LoginAuth.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

class Joko2 extends StatefulWidget {
  const Joko2({Key? key}) : super(key: key);

  @override
  State<Joko2> createState() => _Joko2State();
}

class _Joko2State extends State<Joko2> {
  StreamController<int> selectedFirst = StreamController<int>();
  StreamController<int> selectedSecond = StreamController<int>();
  StreamController<int> selectedThird = StreamController<int>();
  int selectedRandomIntFirst = 0;
  int selectedRandomIntSecond = 0;
  int selectedRandomIntThird = 0;
  int selectedIndexOfFruits = -1;
  Color spinColor = Colors.grey;
  @override
  void dispose() {
    selectedFirst.close();
    selectedSecond.close();
    selectedThird.close();
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
          gameContent(
              widthRoullette,
              colorizeTextStyle,
              colorizeColors,
              widthBuilder,
              heightBuilder,
              fruitImages,
              screenSize,
              heightRoullette,
              context)
        ],
      ),
    );
  }

  SingleChildScrollView gameContent(
      double widthRoullette,
      TextStyle colorizeTextStyle,
      List<Color> colorizeColors,
      double widthBuilder,
      double heightBuilder,
      List<String> fruitImages,
      Size screenSize,
      double heightRoullette,
      BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          testuAnimatuaContainer(
              widthRoullette, colorizeTextStyle, colorizeColors),
          fruituAukeraketa(
              widthBuilder, heightBuilder, fruitImages, screenSize),
          Align(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              width: screenSize.width * 0.9,
              height: screenSize.height * 0.4,
              child: Padding(
                padding: EdgeInsets.only(left: screenSize.width *0.15 , right: screenSize.width *0.15),
                child: Transform.rotate(
                  angle: 11,
                  child: Container(
                    color: Colors.yellow,
                    height: screenSize.width *0.99/*screenSize.width - (screenSize.width *0.15 + screenSize.width * 0.1+ screenSize.width *0.15) -10*/,
                    width: screenSize.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top:15, right: 15),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: screenSize.width * 0.25,
                            height: screenSize.width * 0.23,
                            color: Colors.green,
                            child: FortuneBar(
                              height: screenSize.width * 0.23,
                              visibleItemCount: 1,
                              physics: DirectionalPanPhysics.vertical(),
                              onAnimationEnd: () {
                                if (selectedRandomIntFirst == selectedIndexOfFruits) {
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
                              selected: selectedFirst.stream,
                              // selected: controller.stream,
                              items: [
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[0],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[1],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -5.2,
                                    child: Image.asset(
                                      fruitImages[2],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[3],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -5.2,
                                    child: Image.asset(
                                      fruitImages[4],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[5],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: screenSize.width * 0.25,
                            height: screenSize.width * 0.23,
                            color: Colors.green,
                            child: FortuneBar(
                              height: screenSize.width * 0.23,
                              visibleItemCount: 1,
                              physics: DirectionalPanPhysics.vertical(),
                              onAnimationEnd: () {
                                if (selectedRandomIntSecond ==
                                    selectedIndexOfFruits) {
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
                              selected: selectedSecond.stream,
                              // selected: controller.stream,
                              items: [
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[0],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[1],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -5.2,
                                    child: Image.asset(
                                      fruitImages[2],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[3],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -5.2,
                                    child: Image.asset(
                                      fruitImages[4],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[5],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: screenSize.width * 0.25,
                            height: screenSize.width * 0.23,
                            color: Colors.green,
                            child: FortuneBar(
                              height: screenSize.width * 0.23,
                              visibleItemCount: 1,
                              physics: DirectionalPanPhysics.vertical(),
                              onAnimationEnd: () {
                                if (selectedRandomIntThird == selectedIndexOfFruits) {
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
                              selected: selectedThird.stream,
                              // selected: controller.stream,
                              items: [
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[0],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[1],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -5.2,
                                    child: Image.asset(
                                      fruitImages[2],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[3],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -5.2,
                                    child: Image.asset(
                                      fruitImages[4],
                                    ),
                                  ),
                                ),
                                FortuneItem(
                                  child: Transform.rotate(
                                    angle: -11,
                                    child: Image.asset(
                                      fruitImages[5],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          botoiInplementazioa(fruitImages),
        ],
      ),
    );
  }

  Container testuAnimatuaContainer(double widthRoullette,
      TextStyle colorizeTextStyle, List<Color> colorizeColors) {
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
            selectedFirst.add(
              selectedRandomIntFirst = Fortune.randomInt(0, fruitImages.length),
            );
            selectedSecond.add(
              selectedRandomIntSecond =
                  Fortune.randomInt(0, fruitImages.length),
            );
            selectedThird.add(
              selectedRandomIntThird = Fortune.randomInt(0, fruitImages.length),
            );
          });
        } else {
          setState(() {
            spinColor = Colors.grey;
          });
        }
      },
    );
  }

  Align erruletaInplementazioa(double heightRoullette, double widthRoullette,
      BuildContext context, List<String> fruitImages, Size screenSize) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        alignment: Alignment.topCenter,
        height: heightRoullette,
        width: widthRoullette,
        child: Transform.rotate(
          angle: 11,
          child: FortuneBar(
            physics: DirectionalPanPhysics.vertical(
              duration: const Duration(seconds: 1),
              curve: Curves.decelerate,
            ),
            onAnimationEnd: () {
              if (selectedRandomIntFirst == selectedIndexOfFruits) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('IRABAZI DUZU!!',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)),
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
                                fontSize: 40, fontWeight: FontWeight.bold)),
                      );
                    });
              }
            },
            animateFirst: false,
            selected: selectedSecond.stream,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  ClipRRect fruituAukeraketa(double widthBuilder, double heightBuilder,
      List<String> fruitImages, Size screenSize) {
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
    );
  }

  AnimatedTextKit testuAnimatua(
      TextStyle colorizeTextStyle, List<Color> colorizeColors) {
    return AnimatedTextKit(
      animatedTexts: [
        ColorizeAnimatedText(
          'SLOT JOKOA',
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
