import 'dart:async';
import 'package:awesome_card/awesome_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/logic/transaction_logic.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/firedart.dart' as firedart;
import 'package:lottie/lottie.dart';

class Joko1 extends StatefulWidget {
  const Joko1({Key? key}) : super(key: key);

  @override
  State<Joko1> createState() => _Joko1State();
}

class _Joko1State extends State<Joko1> {
  GlobalKey<FormState> formGame1Bet = GlobalKey<FormState>();
  StreamController<int> selected = StreamController<int>();
  int selectedRandomInt = 0;
  int selectedIndexOfFruits = -1;
  Color spinColor = Colors.grey;
  MaterialColor eremuKolorea = Colors.pink;

  double widthRoullette = 0.0;
  double heightRoullette = 0.0;
  double heightBuilder = 0.0;
  double widthBuilder = 0.0;
  double widthButtonContainer = 0.0;
  double heightButtonContainer = 0.0;
  double sartutakodirua = 0.0;

  // ignore: unused_field
  bool _isLoading = true;
  var transactionDocList = [];
  double kontudirua = 0.0;
  CardType txartelmota = CardType.other;
  bool animationhasEnded = true;

  @override
  void initState() {
    getMoneyAmountFromDB();
    super.initState();
  }

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

    if (defaultTargetPlatform == TargetPlatform.android) {
      widthRoullette = screenSize.width - screenSize.width * 0.05;
      heightRoullette = widthRoullette;
      widthBuilder = screenSize.width * 0.85;
      heightBuilder = screenSize.height * 0.15;
      widthButtonContainer = screenSize.width * 0.99;
      heightButtonContainer = screenSize.width * 0.25;
    } else {
      widthRoullette = screenSize.height * 0.6;
      heightRoullette = widthRoullette;
      widthBuilder = screenSize.width * 0.38;
      heightBuilder = screenSize.height * 0.15;
      widthButtonContainer = screenSize.width * 0.75;
      heightButtonContainer = screenSize.width * 0.1;
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
          erruletaInplementazioa(heightRoullette, widthRoullette, context,
              fruitImages, screenSize),
          Container(
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
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            height: heightButtonContainer,
            width: widthButtonContainer,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: widthButtonContainer * 0.4,
                  height: heightButtonContainer,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: const Alignment(0.8, 0.0),
                      colors: <Color>[Colors.pink[100]!, Colors.white],
                      tileMode: TileMode.repeated,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                            key: formGame1Bet,
                            child: SizedBox(
                              width: widthButtonContainer * 0.35,
                              child: TextFormField(
                                  style: TextStyle(color: eremuKolorea),
                                  onChanged: (changedValue) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: eremuKolorea, width: 2.0)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: eremuKolorea)),
                                      errorStyle:
                                          const TextStyle(color: Colors.black),
                                      focusedErrorBorder:
                                          const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0)),
                                      errorBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0)),
                                      labelStyle:
                                          TextStyle(color: eremuKolorea),
                                      labelText: 'Apostua (???):',
                                      hintStyle:
                                          TextStyle(color: eremuKolorea)),
                                  validator: (value) {
                                    if ((spinColor == Colors.pink)) {
                                      if (isNumeric(value!)) {
                                        double sartutakoZenb =
                                            double.parse(value);
                                        if (kontudirua <= 0 ||
                                            kontudirua - sartutakoZenb < 0) {
                                          return 'Kontuan dirua falta zaizu';
                                        }

                                        setState(() {
                                          sartutakodirua = sartutakoZenb;
                                        });
                                        if (sartutakoZenb < 0) {
                                          return 'Zenbaki positiboa sartu behar duzu';
                                        }
                                        if (sartutakoZenb > 10000) {
                                          return 'Gehienez 10.000??? sartu ditzazkezu';
                                        }
                                        if (sartutakoZenb < 10) {
                                          return 'Gutxienez 10 sartu ditzazkezu';
                                        }

                                        return null;
                                      } else {
                                        return 'Diru konpurua sartu!';
                                      }
                                    } else {
                                      return null;
                                    }
                                  }),
                            )),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: widthButtonContainer * 0.3,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.pink[400],
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: FittedBox(
                    child: Text(
                      '$kontudirua ???',
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                ),
                SizedBox(
                    width: widthButtonContainer * 0.2,
                    child: botoiInplementazioa(fruitImages))
              ],
            ),
          )
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
        bool isFormValid = formGame1Bet.currentState?.validate() ?? false;
        if (selectedIndexOfFruits != -1 && isFormValid && animationhasEnded) {
          setState(() {
            spinColor = Colors.pink;
            selected.add(
              selectedRandomInt = Fortune.randomInt(0, fruitImages.length),
            );
          });
        } else {}
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
        child: FortuneWheel(
          onAnimationStart: () {
            animationhasEnded = false;
          },
          onAnimationEnd: () {
            animationhasEnded = true;
            if (selectedRandomInt == selectedIndexOfFruits) {
              var dateTimestamp = Timestamp.now();
              double irabazitakoa = sartutakodirua * 3;

              TransactionLogic.addTransaction(
                      transMota: 'joko1_irabazi',
                      zenbat: '+$irabazitakoa',
                      transDate: dateTimestamp)
                  .then((value) {
                updateTransactions().then((value) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            height: screenSize.height * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('x3: IRABAZI DUZU!!',
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold)),
                                Stack(
                                  children: [
                                    Lottie.network(
                                      'https://assets6.lottiefiles.com/private_files/lf30_kvdn44jg.json',
                                      height: screenSize.height * 0.4,
                                      width: screenSize.height * 0.3,
                                    ),
                                    Lottie.network(
                                      'https://assets6.lottiefiles.com/datafiles/VtCIGqDsiVwFPNM/data.json',
                                      height: screenSize.height * 0.4,
                                      width: screenSize.height * 0.3,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                });
              });
            } else {
              var dateTimestamp = Timestamp.now();

              TransactionLogic.addTransaction(
                      transMota: 'joko1_galdu',
                      zenbat: '-$sartutakodirua',
                      transDate: dateTimestamp)
                  .then((value) {
                updateTransactions().then((value) {
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
                });
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

  Container fruituAukeraketa(double widthBuilder, double heightBuilder,
      List<String> fruitImages, Size screenSize) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.transparent),
      width: widthBuilder,
      height: heightBuilder,
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
                    if (animationhasEnded) {
                      setState(() {
                        selectedIndexOfFruits = index;
                        spinColor = Colors.pink;
                      });
                    }
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
                          placeholder: const AssetImage('assets/no-image.jpg'),
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
    );
  }

  AnimatedTextKit testuAnimatua(
      TextStyle colorizeTextStyle, List<Color> colorizeColors) {
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
      actions: [
        TextButton.icon(
            onPressed: () {
              LoginAuth.signOut().then((value) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                );
              });
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

  bool isNumeric(String moneyNum) {
    return double.tryParse(moneyNum) != null;
  }

  Future<String?> getMoneyAmountFromDB() async {
    setState(() {
      _isLoading = true;
    });

    String userCred = '';
    double sumAllTransactions = 0.0;
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      userCred =
          authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

      await _firestore
          .collection('users')
          .doc(userCred)
          .collection('moneyTransactions')
          .orderBy('data', descending: false)
          .get()
          .then((querySnapshot) {
        transactionDocList = querySnapshot.docs;
        for (var doc in querySnapshot.docs) {
          String getTransString = doc['zenbat'];
          double transDoubleValue = double.parse(getTransString);
          sumAllTransactions += transDoubleValue;
        }
      });
      setState(() {
        kontudirua = sumAllTransactions;
      });
    } else {
      firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

      String userId = auth.userId;

      await firedart.Firestore.instance
          .collection('users')
          .document(userId)
          .collection('moneyTransactions')
          .orderBy('data', descending: false)
          .get()
          .then((querySnapshot) {
        transactionDocList = querySnapshot;
        for (var doc in querySnapshot) {
          String getTransString = doc['zenbat'];
          double transDoubleValue = double.parse(getTransString);
          sumAllTransactions += transDoubleValue;
        }
      });

      setState(() {
        kontudirua = sumAllTransactions;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String?> updateTransactions() async {
    String userCred = '';
    double sumAllTransactions = 0.0;
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      userCred =
          authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

      await _firestore
          .collection('users')
          .doc(userCred)
          .collection('moneyTransactions')
          .orderBy('data', descending: false)
          .get()
          .then((querySnapshot) {
        setState(() {
          transactionDocList = querySnapshot.docs;
        });
        for (var doc in querySnapshot.docs) {
          String getTransString = doc['zenbat'];
          double transDoubleValue = double.parse(getTransString);
          sumAllTransactions += transDoubleValue;
        }
      });
      setState(() {
        kontudirua = sumAllTransactions;
      });
    } else {
      firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

      String userId = auth.userId;

      await firedart.Firestore.instance
          .collection('users')
          .document(userId)
          .collection('moneyTransactions')
          .orderBy('data', descending: false)
          .get()
          .then((querySnapshot) {
        setState(() {
          transactionDocList = querySnapshot;
        });

        for (var doc in querySnapshot) {
          String getTransString = doc['zenbat'];
          double transDoubleValue = double.parse(getTransString);
          sumAllTransactions += transDoubleValue;
        }
      });

      setState(() {
        kontudirua = sumAllTransactions;
      });
    }
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
          image: AssetImage("assets/backgroundSlots.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
