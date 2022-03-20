import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_validator/validation_results.dart';
import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/firedart.dart' as firedart;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:gral_jalzas_21_22/logic/cred_card_logic.dart';
import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/logic/transaction_logic.dart';
import 'package:gral_jalzas_21_22/screens/edit_profile.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:intl/intl.dart';

class ShowCard extends StatefulWidget {
  const ShowCard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ShowCardState createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> {
  GlobalKey<FormState> formAmountMoneyKey = GlobalKey<FormState>();

  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;
  CardType txartelmota = CardType.other;
  bool _showMoneyamount = false;
  MaterialColor eremuKolorea = Colors.pink;

  double cardWidth = 0.0;
  double cardHeight = 0.0;
  double kontudirua = 0.0;
  double minWidthKontudirua = 0.0;
  double maxWidthKontudirua = 0.0;

  double kontuDiruaTextSize = 0.0;
  double kontuDiruErreala = 0.0;

  bool _isLoading = true;

  var transactionDocList;

  late FocusNode _focusNode;
  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();

  GlobalKey<FormState> formCardKey = GlobalKey<FormState>();
  final CreditCardValidator _ccValidator = CreditCardValidator();

  @override
  void initState() {
    getInfoFromDB();
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (defaultTargetPlatform == TargetPlatform.android) {
      cardWidth = screenSize.width * 0.95;
      if (screenSize.height < 450) {
        cardHeight = screenSize.height * 0.425;
      } else {
        cardHeight = screenSize.height * 0.25;
      }
      kontuDiruErreala = screenSize.width * 0.1;
      kontuDiruaTextSize = screenSize.width * 0.05;
      minWidthKontudirua = screenSize.width * 0.2;
      maxWidthKontudirua = screenSize.width * 0.5;
    } else {
      cardWidth = screenSize.width * 0.35;
      cardHeight = screenSize.height * 0.4;
      kontuDiruErreala = screenSize.width * 0.05;
      kontuDiruaTextSize = screenSize.width * 0.025;
      minWidthKontudirua = screenSize.width * 0.2;
      maxWidthKontudirua = screenSize.width * 0.8;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.pink,
        elevation: 0,
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
      body: _isLoading
          ? const KargatzeAnimazioa()
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          height: screenSize.height * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.pink[100],
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: screenSize.height * 0.015,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Kontu dirua:',
                                  style:
                                      TextStyle(fontSize: kontuDiruaTextSize),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.025,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      minWidth: minWidthKontudirua,
                                      maxWidth: maxWidthKontudirua),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.pink[400],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: Text(
                                    '$kontudirua €',
                                    style:
                                        TextStyle(fontSize: kontuDiruErreala),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(16.0),
                                    primary: Colors.black,
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showMoneyamount = true;
                                    });
                                  },
                                  child: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenSize.height * 0.015,
                            ),
                            Visibility(
                              visible: _showMoneyamount,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Form(
                                      key: formAmountMoneyKey,
                                      child: SizedBox(
                                        width: screenSize.width * 0.7,
                                        child: TextFormField(
                                            style:
                                                TextStyle(color: eremuKolorea),
                                            onChanged: (changedValue) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
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
                                                labelStyle: TextStyle(
                                                    color: eremuKolorea),
                                                labelText:
                                                    'Zenbat diru sartu nahi duzu? (€)',
                                                hintText: '10',
                                                hintStyle: TextStyle(
                                                    color: eremuKolorea)),
                                            validator: (value) {
                                              if (isNumeric(value!)) {
                                                double sartutakoZenb =
                                                    double.parse(value);
                                                if (sartutakoZenb < 0) {
                                                  return 'Zenbaki positiboa sartu behar duzu';
                                                }
                                                final now = DateTime.now();
                                                String currentDate =
                                                    DateFormat('yMd').format(
                                                        now); // DD/MM/YYYY

                                                TransactionLogic.addTransaction(
                                                    transMota: 'dirua_sartu',
                                                    zenbat: '+$sartutakoZenb',
                                                    transDate: currentDate);
                                                setState(() {
                                                  kontudirua += sartutakoZenb;
                                                });
                                                return null;
                                              } else {
                                                return 'Diru konpurua sartu behar da';
                                              }
                                            }),
                                      )),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(16.0),
                                      primary: Colors.black,
                                      textStyle: const TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {
                                      bool isFormValid = formAmountMoneyKey
                                              .currentState
                                              ?.validate() ??
                                          false;
                                      if (isFormValid) {
                                        setState(() {
                                          _showMoneyamount = false;
                                        });
                                      }
                                    },
                                    child: const Icon(Icons.save),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.005,
                            ),
                            CreditCard(
                              cardNumber: cardNumber,
                              cardExpiry: expiryDate,
                              cardHolderName: cardHolderName,
                              cvv: cvv,
                              bankName: 'Txartela',
                              showBackSide: showBack,
                              frontBackground: CardBackgrounds.black,
                              backBackground: CardBackgrounds.white,
                              showShadow: true,
                              textExpDate: 'Iraun. Data',
                              textName: 'Titularra',
                              cardType: txartelmota,
                              width: cardWidth,
                              height: cardHeight,
                              // mask: getCardTypeMask(cardType: CardType.americanExpress),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.015,
                            ),
                            Container(
                              height: screenSize.height * 0.4,
                              width: screenSize.width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.pink[400],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: transactionDocList.length,
                                  itemBuilder: (_, int index) {
                                    return Hero(
                                      tag: transactionDocList[index],
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment(0.4, 0.5),
                                                colors: <Color>[
                                                  Color.fromARGB(
                                                      235, 153, 0, 76),
                                                  Color.fromARGB(
                                                      235, 204, 0, 102)
                                                ],
                                                tileMode: TileMode.repeated,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            width: screenSize.height * 0.2,
                                            height: screenSize.height * 0.1,
                                            margin: const EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                        'Transakzio izena: '),
                                                    Text(transactionDocList[
                                                        index]['trans_mota']),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: screenSize.width * 0.2,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                        'Transakzio data: '),
                                                    Text('Data: ' +
                                                        transactionDocList[
                                                            index]['data'])
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: screenSize.width * 0.2,
                                                ),
                                                Text(
                                                  transactionDocList[index]
                                                      ['zenbat'],
                                                  style: const TextStyle(
                                                      fontSize: 40),
                                                ),
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<String?> getInfoFromDB() async {
    setState(() {
      _isLoading = true;
    });

    String userCred = '';
    double sumAllTransactions = 0.0;
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      userCred =
          authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

      String cardId = '';
      // await _firestore
      //     .collection('credcard')
      //     .where('userUID', isEqualTo: userCred)
      //     .get()
      //     .then((querySnapshot) {
      //   cardId = querySnapshot.docs.first.id;
      // });

      // await FirebaseFirestore.instance
      //     .collection('credcard')
      //     .doc(cardId)
      //     .get()
      //     .then((querySnapshot) {
      //   setState(() {
      //     cardNumber = querySnapshot['txartelZenbakia'];
      //     cardHolderName = querySnapshot['titularra'];
      //     expiryDate = querySnapshot['iraungitzea'];
      //     cvv = querySnapshot['cvv'];
      //     txartelmota = getCardCast(querySnapshot['txartelmota']);
      //   });
      // });

      await _firestore
          .collection('users')
          .doc(userCred)
          .collection('credcard')
          .get()
          .then((querySnapshot) {
        cardId = querySnapshot.docs.first.id;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred)
          .collection('credcard')
          .doc(cardId)
          .get()
          .then((querySnapshot) {
        setState(() {
          cardNumber = querySnapshot['txartelZenbakia'];
          cardHolderName = querySnapshot['titularra'];
          expiryDate = querySnapshot['iraungitzea'];
          cvv = querySnapshot['cvv'];
          txartelmota = getCardCast(querySnapshot['txartelmota']);
        });
      });

      await _firestore
          .collection('users')
          .doc(userCred)
          .collection('moneyTransactions')
          .get()
          .then((querySnapshot) {
        transactionDocList = querySnapshot.docs;
        for (var doc in querySnapshot.docs) {
          //Lehenengo karakterea kendu eta zenbakia double bihurtu behar: '+50'(String) -> 50 (double)
          String getTransString = doc['zenbat'];
          String getTransStringNoSign = getTransString.substring(1);
          double transDoubleValue = double.parse(getTransStringNoSign);
          sumAllTransactions += transDoubleValue;
        }
      });
      setState(() {
        kontudirua = sumAllTransactions;
      });
    } else {
      firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

      String userId = auth.userId;

      String cardId = '';

      //   await firedart.Firestore.instance
      //       .collection('credcard')
      //       .where('userUID', isEqualTo: userId)
      //       .get()
      //       .then((querySnapshot) {
      //     if (querySnapshot.isNotEmpty) {
      //       cardId = querySnapshot.first.id;
      //     }
      //   });

      //   await firedart.Firestore.instance
      //       .collection('credcard')
      //       .document(cardId)
      //       .get()
      //       .then((querySnapshot) {
      //     setState(() {
      //       cardNumber = querySnapshot['txartelZenbakia'];
      //       cardHolderName = querySnapshot['titularra'];
      //       expiryDate = querySnapshot['iraungitzea'];
      //       cvv = querySnapshot['cvv'];
      //       txartelmota = getCardCast(querySnapshot['txartelmota']);
      //     });
      //   });
      // }

      await firedart.Firestore.instance
          .collection('users')
          .document(userId)
          .collection('credcard')
          .get()
          .then((querySnapshot) {
        if (querySnapshot.isNotEmpty) {
          cardId = querySnapshot.first.id;
        }
      });

      await firedart.Firestore.instance
          .collection('users')
          .document(userId)
          .collection('credcard')
          .document(cardId)
          .get()
          .then((querySnapshot) {
        setState(() {
          cardNumber = querySnapshot['txartelZenbakia'];
          cardHolderName = querySnapshot['titularra'];
          expiryDate = querySnapshot['iraungitzea'];
          cvv = querySnapshot['cvv'];
          txartelmota = getCardCast(querySnapshot['txartelmota']);
        });
      });

      await firedart.Firestore.instance
          .collection('users')
          .document(userId)
          .collection('moneyTransactions')
          .get()
          .then((querySnapshot) {
        transactionDocList = querySnapshot;
        for (var doc in querySnapshot) {
          String getTransString = doc['zenbat'];
          String getTransStringNoSign = getTransString.substring(1);
          double transDoubleValue = double.parse(getTransStringNoSign);
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

  CardType getCardCast(String cardType) {
    if (cardType == 'CardType.visa') {
      txartelmota = CardType.visa;
    } else if (cardType == 'CardType.discover') {
      txartelmota = CardType.discover;
    } else if (cardType == 'CardType.masterCard') {
      txartelmota = CardType.masterCard;
    } else if (cardType == 'CardType.dinersClub') {
      txartelmota = CardType.dinersClub;
    } else if (cardType == 'CardType.jcb') {
      txartelmota = CardType.jcb;
    } else if (cardType == 'CardType.maestro') {
      txartelmota = CardType.maestro;
    } else if (cardType == 'CardType.americanExpress') {
      txartelmota = CardType.americanExpress;
    } else if (cardType == 'CardType.elo') {
      txartelmota = CardType.elo;
    } else {
      txartelmota = CardType.other;
    }
    return txartelmota;
  }

  bool isNumeric(String moneyNum) {
    return double.tryParse(moneyNum) != null;
  }
}
