import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'dart:math';

import 'package:confetti/confetti.dart';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/logic/transaction_logic.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/firedart.dart' as firedart;
import 'package:lottie/lottie.dart';

class Joko2 extends StatefulWidget {
  const Joko2({Key? key}) : super(key: key);

  @override
  State<Joko2> createState() => _Joko2State();
}

class _Joko2State extends State<Joko2> {
  late ConfettiController _controllerTopCenter;
  GlobalKey<FormState> formGame2Bet = GlobalKey<FormState>();

  @override
  void initState() {
    getMoneyAmountFromDB();
    super.initState();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    selectedFirst.close();
    selectedSecond.close();
    selectedThird.close();
    super.dispose();
  }

  StreamController<int> selectedFirst = StreamController<int>();
  StreamController<int> selectedSecond = StreamController<int>();
  StreamController<int> selectedThird = StreamController<int>();
  int selectedRandomIntFirst = 0;
  int selectedRandomIntSecond = 0;
  int selectedRandomIntThird = 0;
  double widthButtonContainer = 0.0;
  double heightButtonContainer = 0.0;
  double sartutakodirua = 0.0;
  double kontudirua = 0.0;
  MaterialColor eremuKolorea = Colors.pink;

  bool firstAnimationEnded = true;
  bool secondAnimationEnded = true;
  bool thirdAnimationEnded = true;

  Color spinColor = Colors.pink;

  int appleIndex = 0;
  int bananaIndex = 1;
  int blackberryIndex = 2;
  int lemonIndex = 3;
  int orangeIndex = 4;
  int raspberryIndex = 5;
  var transactionDocList = [];
  // ignore: unused_field
  bool _isLoading = true;
  bool animationhasEnded = true;

  List<String> fruitImages = [
    'assets/Apple.png',
    'assets/Banana.png',
    'assets/blackberry.png',
    'assets/Lemon.png',
    'assets/orange.png',
    'assets/raspberry.png'
  ];

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.black,
      Colors.pink,
      Colors.yellow,
      Colors.purple,
    ];
    TextStyle colorizeTextStyle = const TextStyle();

    final screenSize = MediaQuery.of(context).size;

    colorizeTextStyle = TextStyle(
        fontSize: screenSize.width * 0.1,
        fontFamily: 'Horizon',
        fontWeight: FontWeight.bold);
    double widthKonbinazioak = 0.0;
    double konfigImageSize = 0.0;
    double fortunewidth = 0.0;
    double fortuneheight = 0.0;
    double konbinazioakSizeText = 0.0;
    double konbinazioakHoriz = 0.0;
    double konbinazioakVert = 0.0;
    double widthKonbinazioContainer = 0.0;
    double fortuneBarPaddLeft = 0.0;
    double fortuneBarPaddTop = 0.0;
    double fortuneBarPaddRight = 0.0;

    if (defaultTargetPlatform == TargetPlatform.android) {
      widthKonbinazioak = screenSize.width * 0.825;
      konfigImageSize = screenSize.width * 0.05;
      fortunewidth = screenSize.width * 0.5;
      fortuneheight = screenSize.width * 0.2;
      konbinazioakSizeText = screenSize.width * 0.04;
      konbinazioakHoriz = screenSize.width * 0.03;
      konbinazioakVert = screenSize.width * 0.003;
      widthKonbinazioContainer = widthKonbinazioak - (screenSize.width * 0.15);
      fortuneBarPaddLeft = screenSize.width * 0.01;
      fortuneBarPaddTop = screenSize.width * 0.09;
      fortuneBarPaddRight = screenSize.width * 0.01;
      widthButtonContainer = screenSize.width * 0.99;
      heightButtonContainer = screenSize.width * 0.25;
    } else {
      widthKonbinazioak = screenSize.width * 0.625;
      konfigImageSize = screenSize.width * 0.025;
      fortunewidth = screenSize.width * 0.15;
      fortuneheight = screenSize.width * 0.18;
      konbinazioakSizeText = screenSize.width * 0.02;
      konbinazioakHoriz = screenSize.width * 0.005;
      konbinazioakVert = screenSize.width * 0.005;
      widthKonbinazioContainer = widthKonbinazioak - (screenSize.width * 0.2);
      fortuneBarPaddLeft = screenSize.width * 0.01;
      fortuneBarPaddTop = screenSize.width * 0.035;
      fortuneBarPaddRight = screenSize.width * 0.01;
      widthButtonContainer = screenSize.width * 0.75;
      heightButtonContainer = screenSize.width * 0.1;
    }

    return Scaffold(
      appBar: appBarInfo(context),
      body: Stack(
        children: [
          const GameBackground(),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                PositionConfetti(controllerTopCenter: _controllerTopCenter),
                Container(
                  width: widthKonbinazioak,
                  decoration: BoxDecoration(
                      border: Border.all(width: 5.0),
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.transparent.withOpacity(0.2)),
                  child: Column(
                    children: [
                      testuAnimatua(colorizeTextStyle, colorizeColors),
                      KonbinazioenAtala(
                          widthKonbinazioContainer: widthKonbinazioContainer,
                          konbinazioakHoriz: konbinazioakHoriz,
                          konbinazioakVert: konbinazioakVert,
                          konfigImageSize: konfigImageSize,
                          screenSize: screenSize,
                          konbinazioakSizeText: konbinazioakSizeText),
                      slotMachineImpl(
                          fortuneBarPaddLeft,
                          fortuneBarPaddTop,
                          fortuneBarPaddRight,
                          fortunewidth,
                          fortuneheight,
                          context,
                          fruitImages,
                          screenSize),
                      SizedBox(
                        height: screenSize.height * 0.05,
                      )
                    ],
                  ),
                ),
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
                            end: const Alignment(0.8,
                                0.0), // 10% of the width, so there are ten blinds.
                            colors: <Color>[
                              Colors.pink[100]!,
                              Colors.white
                            ], // red to yellow
                            tileMode: TileMode
                                .repeated, // repeats the gradient over the canvas
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Form(
                                  key: formGame2Bet,
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
                                                    color: eremuKolorea,
                                                    width: 2.0)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: eremuKolorea)),
                                            errorStyle: const TextStyle(
                                                color: Colors.black),
                                            focusedErrorBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0)),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0)),
                                            labelStyle:
                                                TextStyle(color: eremuKolorea),
                                            labelText: 'Apostua (€):',
                                            hintStyle:
                                                TextStyle(color: eremuKolorea)),
                                        validator: (value) {
                                          if (isNumeric(value!)) {
                                            double sartutakoZenb =
                                                double.parse(value);

                                            if (kontudirua <= 0 ||
                                                kontudirua - sartutakoZenb <
                                                    0) {
                                              return 'Kontuan dirua falta zaizu';
                                            }

                                            setState(() {
                                              sartutakodirua = sartutakoZenb;
                                            });
                                            if (sartutakoZenb < 0) {
                                              return 'Zenbaki positiboa sartu behar duzu';
                                            }
                                            if (sartutakoZenb > 10000) {
                                              return 'Gehienez 10.000€ sartu ditzazkezu';
                                            }
                                            if (sartutakoZenb < 10) {
                                              return 'Gutxienez 10 sartu ditzazkezu';
                                            }

                                            return null;
                                          } else {
                                            return 'Diru konpurua sartu!';
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: FittedBox(
                          child: Text(
                            '$kontudirua €',
                            style: const TextStyle(fontSize: 100),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: widthButtonContainer * 0.2,
                        child: botoiInplementazioa(
                            fruitImages, screenSize.width * 0.15),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  RotatedBox slotMachineImpl(
      double fortuneBarPaddLeft,
      double fortuneBarPaddTop,
      double fortuneBarPaddRight,
      double fortunewidth,
      double fortuneheight,
      BuildContext context,
      List<String> fruitImages,
      Size screenSize) {
    return RotatedBox(
      quarterTurns: -1,
      child: Padding(
        padding: EdgeInsets.only(
            left: fortuneBarPaddLeft,
            top: fortuneBarPaddTop,
            right: fortuneBarPaddRight),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: fortunewidth,
              height: fortuneheight,
              child: FortuneBar(
                styleStrategy: UniformStyleStrategy(
                  color: Colors.transparent.withOpacity(0.2),
                  borderColor: Colors.black,
                  borderWidth: 10,
                ),
                height: fortuneheight,
                physics: DirectionalPanPhysics.vertical(),
                onAnimationStart: () {
                  animationhasEnded = false;
                },
                onAnimationEnd: () {
                  animationhasEnded = true;
                  if (selectedRandomIntFirst == appleIndex &&
                      selectedRandomIntSecond == appleIndex &&
                      selectedRandomIntThird == appleIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 5;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
                                    children: [
                                      const Text('x5: IRABAZI DUZU!!',
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

                    // _controllerTopCenter.play(); //Confettia bota

                  } else if (selectedRandomIntFirst == bananaIndex &&
                      selectedRandomIntSecond == bananaIndex &&
                      selectedRandomIntThird == bananaIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 5;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
                                    children: [
                                      const Text('x5: IRABAZI DUZU!!',
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
                  } else if (selectedRandomIntSecond == appleIndex &&
                      selectedRandomIntThird == appleIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 3;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
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
                  } else if (selectedRandomIntFirst == bananaIndex &&
                      selectedRandomIntSecond == bananaIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 3;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
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
                  } else if (selectedRandomIntFirst == blackberryIndex &&
                      selectedRandomIntSecond == blackberryIndex &&
                      selectedRandomIntThird == blackberryIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 4;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
                                    children: [
                                      const Text('x4: IRABAZI DUZU!!',
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
                  } else if (selectedRandomIntFirst == lemonIndex &&
                      selectedRandomIntSecond == lemonIndex &&
                      selectedRandomIntThird == lemonIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 4;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
                                    children: [
                                      const Text('x4: IRABAZI DUZU!!',
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
                  } else if (selectedRandomIntFirst == orangeIndex &&
                      selectedRandomIntSecond == orangeIndex &&
                      selectedRandomIntThird == orangeIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 5;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
                                    children: [
                                      const Text('x5: IRABAZI DUZU!!',
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
                  } else if (selectedRandomIntFirst == raspberryIndex &&
                      selectedRandomIntSecond == raspberryIndex &&
                      selectedRandomIntThird == raspberryIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 5;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
                                    children: [
                                      const Text('x5: IRABAZI DUZU!!',
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
                  } else if (selectedRandomIntFirst == orangeIndex &&
                      selectedRandomIntThird == orangeIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 2;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
                                    children: [
                                      const Text('x2: IRABAZI DUZU!!',
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
                  } else if (selectedRandomIntFirst == raspberryIndex &&
                      selectedRandomIntThird == raspberryIndex) {
                    var dateTimestamp = Timestamp.now();
                    double irabazitakoa = sartutakodirua * 2;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_irabazi',
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
                                  height: screenSize.height * 0.5,
                                  child: Column(
                                    children: [
                                      const Text('x2: IRABAZI DUZU!!',
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
                    double galdutakoa = sartutakodirua;
                    TransactionLogic.addTransaction(
                            transMota: 'joko2_galdu',
                            zenbat: '-$galdutakoa',
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
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold)),
                              );
                            });
                      });
                    });
                  }
                },
                animateFirst: false,
                selected: selectedFirst.stream,
                items: [
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[appleIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[bananaIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -5.2,
                      child: Image.asset(
                        fruitImages[blackberryIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[lemonIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -5.2,
                      child: Image.asset(
                        fruitImages[orangeIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[raspberryIndex],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenSize.width * 0.005,
            ),
            SizedBox(
              width: fortunewidth,
              height: fortuneheight,
              child: FortuneBar(
                styleStrategy: UniformStyleStrategy(
                  color: Colors.transparent.withOpacity(0.2),
                  borderColor: Colors.black,
                  borderWidth: 10,
                ),
                height: fortuneheight,
                physics: DirectionalPanPhysics.vertical(),
                animateFirst: false,
                selected: selectedSecond.stream,
                items: [
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[appleIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[bananaIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -5.2,
                      child: Image.asset(
                        fruitImages[blackberryIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[lemonIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -5.2,
                      child: Image.asset(
                        fruitImages[orangeIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[raspberryIndex],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenSize.width * 0.005,
            ),
            SizedBox(
              width: fortunewidth,
              height: fortuneheight,
              child: FortuneBar(
                styleStrategy: UniformStyleStrategy(
                  color: Colors.transparent.withOpacity(0.2),
                  borderColor: Colors.black,
                  borderWidth: 10,
                ),
                height: fortuneheight,
                physics: DirectionalPanPhysics.vertical(),
                animateFirst: false,
                selected: selectedThird.stream,
                items: [
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[appleIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[bananaIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -5.2,
                      child: Image.asset(
                        fruitImages[blackberryIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[lemonIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -5.2,
                      child: Image.asset(
                        fruitImages[orangeIndex],
                      ),
                    ),
                  ),
                  FortuneItem(
                    child: Transform.rotate(
                      angle: -11,
                      child: Image.asset(
                        fruitImages[raspberryIndex],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  FloatingActionButton botoiInplementazioa(
      List<String> fruitImages, double setSizeBut) {
    return FloatingActionButton.extended(
      label: const Text('SPIN'),
      icon: const Icon(Icons.restart_alt),
      backgroundColor: spinColor,
      onPressed: () {
        bool isFormValid = formGame2Bet.currentState?.validate() ?? false;
        if (isFormValid && animationhasEnded) {
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
        } else {}
      },
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
      actions: [
        TextButton.icon(
            onPressed: () {
              LoginAuth.signOut();
              Navigator.pop(context);
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
          //Lehenengo karakterea kendu eta zenbakia double bihurtu behar: '+50'(String) -> 50 (double)
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
          //Lehenengo karakterea kendu eta zenbakia double bihurtu behar: '+50'(String) -> 50 (double)
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

class KonbinazioenAtala extends StatelessWidget {
  const KonbinazioenAtala({
    Key? key,
    required this.widthKonbinazioContainer,
    required this.konbinazioakHoriz,
    required this.konbinazioakVert,
    required this.konfigImageSize,
    required this.screenSize,
    required this.konbinazioakSizeText,
  }) : super(key: key);

  final double widthKonbinazioContainer;
  final double konbinazioakHoriz;
  final double konbinazioakVert;
  final double konfigImageSize;
  final Size screenSize;
  final double konbinazioakSizeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthKonbinazioContainer,
      padding: EdgeInsets.symmetric(
          horizontal: konbinazioakHoriz, vertical: konbinazioakVert),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 4.0),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.transparent.withOpacity(0.9)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Apple.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Apple.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Apple.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x5',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
              SizedBox(width: screenSize.width * 0.085),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Banana.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Banana.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Banana.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x5',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/placeholderFruit.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Apple.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Apple.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x3',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
              SizedBox(width: screenSize.width * 0.085),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Banana.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Banana.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/placeholderFruit.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x3',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/blackberry.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/blackberry.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/blackberry.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x4',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
              SizedBox(width: screenSize.width * 0.085),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Lemon.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Lemon.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/Lemon.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x4',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/orange.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/orange.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/orange.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x5',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
              SizedBox(width: screenSize.width * 0.085),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/raspberry.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/raspberry.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/raspberry.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x5',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/orange.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/placeholderFruit.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/orange.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x2',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
              SizedBox(width: screenSize.width * 0.085),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/raspberry.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/placeholderFruit.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.005),
              FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: const AssetImage('assets/raspberry.png'),
                height: konfigImageSize,
                width: konfigImageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.03),
              Text(
                'x2',
                style: TextStyle(
                  fontSize: konbinazioakSizeText,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 4
                    ..color = Colors.pink,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class PositionConfetti extends StatelessWidget {
  const PositionConfetti({
    Key? key,
    required ConfettiController controllerTopCenter,
  })  : _controllerTopCenter = controllerTopCenter,
        super(key: key);

  final ConfettiController _controllerTopCenter;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controllerTopCenter,
        blastDirection: pi / 2,
        maxBlastForce: 5,
        minBlastForce: 2,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 1,
      ),
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
          image: AssetImage("assets/backgroundSlots.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
