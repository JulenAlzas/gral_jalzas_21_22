import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:gral_jalzas_21_22/logic/cred_card_logic.dart';
import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/screens/create_card.dart';
import 'package:gral_jalzas_21_22/screens/edit_profile.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:gral_jalzas_21_22/screens/login_home.dart';
import 'package:gral_jalzas_21_22/screens/show_card.dart';
import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/firedart.dart' as firedart;

class EditCard extends StatefulWidget {
  const EditCard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  String cardNumber = '';
  String oldcardNumber = '';
  String cardHolderName = '';
  String oldcardHolderName = '';
  String expiryDate = '';
  String oldexpiryDate = '';
  String cvv = '';
  String oldcvv = '';
  bool showBack = false;
  CardType txartelmota = CardType.visa;
  bool _isLoading = true;

  double cardWidth = 0.0;
  double cardHeight = 0.0;

  FocusNode _focusNode = FocusNode();
  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();

  GlobalKey<FormState> formCardKey = GlobalKey<FormState>();
  final CreditCardValidator _ccValidator = CreditCardValidator();

  @override
  void initState() {
    getCardInfo();
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
      if (screenSize.height < 500) {
        cardHeight = screenSize.height * 0.4;
      } else {
        cardHeight = screenSize.height * 0.25;
      }
    } else {
      cardWidth = screenSize.width * 0.35;
      cardHeight = screenSize.height * 0.4;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.pink,
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
      ),
      body: _isLoading
          ? const KargatzeAnimazioa()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
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
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: formCardKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              controller: cardNumberCtrl,
                              decoration: const InputDecoration(
                                  hintText: 'Txartel zenbakia'),
                              maxLength: 16,
                              onChanged: (value) {
                                final newCardNumber = value.trim();
                                var newStr = '';
                                int step = 4;

                                for (var i = 0;
                                    i < newCardNumber.length;
                                    i += step) {
                                  newStr += newCardNumber.substring(i,
                                      math.min(i + step, newCardNumber.length));
                                  if (i + step < newCardNumber.length) {
                                    newStr += ' ';
                                  }
                                }

                                setState(() {
                                  cardNumber = newStr;
                                });

                                var ccNumResults =
                                    _ccValidator.validateCCNum(cardNumber);

                                if (ccNumResults.isValid) {
                                  setState(() {
                                    if (ccNumResults.ccType ==
                                        CreditCardType.visa) {
                                      txartelmota = CardType.visa;
                                    } else if (ccNumResults.ccType ==
                                        CreditCardType.discover) {
                                      txartelmota = CardType.discover;
                                    } else if (ccNumResults.ccType ==
                                        CreditCardType.mastercard) {
                                      txartelmota = CardType.masterCard;
                                    } else if (ccNumResults.ccType ==
                                        CreditCardType.dinersclub) {
                                      txartelmota = CardType.dinersClub;
                                    } else if (ccNumResults.ccType ==
                                        CreditCardType.jcb) {
                                      txartelmota = CardType.jcb;
                                    } else if (ccNumResults.ccType ==
                                        CreditCardType.maestro) {
                                      txartelmota = CardType.maestro;
                                    } else if (ccNumResults.ccType ==
                                        CreditCardType.elo) {
                                      txartelmota = CardType.elo;
                                    } else if (ccNumResults.ccType ==
                                        CreditCardType.amex) {
                                      txartelmota = CardType.americanExpress;
                                    } else if (ccNumResults.ccType ==
                                            CreditCardType.hiper ||
                                        ccNumResults.ccType ==
                                            CreditCardType.hipercard ||
                                        ccNumResults.ccType ==
                                            CreditCardType.unionpay ||
                                        ccNumResults.ccType ==
                                            CreditCardType.mir ||
                                        ccNumResults.ccType ==
                                            CreditCardType.unknown) {
                                      txartelmota = CardType.other;
                                    }
                                  });
                                }
                              },
                              validator: (_) {
                                var ccNumResults =
                                    _ccValidator.validateCCNum(cardNumber);
                                if (ccNumResults.isValid) {
                                  return null;
                                } else if (ccNumResults.message ==
                                    'No input or contains non-numerical characters') {
                                  return 'Sarrera hutsa edo karaktere ez zenbakizkoak';
                                } else {
                                  return 'Sarrera okerra: ' +
                                      ccNumResults.message;
                                }
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              controller: expiryFieldCtrl,
                              decoration: const InputDecoration(
                                  hintText: 'Iraungitze-data'),
                              maxLength: 5,
                              onChanged: (value) {
                                var newDateValue = value.trim();
                                final isPressingBackspace =
                                    expiryDate.length > newDateValue.length;
                                final containsSlash =
                                    newDateValue.contains('/');

                                if (newDateValue.length >= 2 &&
                                    !containsSlash &&
                                    !isPressingBackspace) {
                                  newDateValue = newDateValue.substring(0, 2) +
                                      '/' +
                                      newDateValue.substring(2);
                                }
                                setState(() {
                                  expiryFieldCtrl.text = newDateValue;
                                  expiryFieldCtrl.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: newDateValue.length));
                                  expiryDate = newDateValue;
                                });
                              },
                              validator: (_) {
                                var expDateResults =
                                    _ccValidator.validateExpDate(expiryDate);
                                if (expDateResults.isValid) {
                                  return null;
                                } else {
                                  return 'Iraungitze-data okerra';
                                }
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                              initialValue: cardHolderName,
                              decoration: const InputDecoration(
                                  hintText: 'Titularraren izena'),
                              onChanged: (value) {
                                setState(() {
                                  cardHolderName = value;
                                });
                              },
                              validator: (_) {
                                if (cardHolderName.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Titularraren izena sar ezazu.';
                                }
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          child: TextFormField(
                              initialValue: cvv,
                              decoration:
                                  const InputDecoration(hintText: 'CVV'),
                              maxLength: txartelmota == CardType.americanExpress
                                  ? 4
                                  : 3,
                              onChanged: (value) {
                                setState(() {
                                  cvv = value;
                                });
                              },
                              focusNode: !_isLoading ? _focusNode : null,
                              validator: (_) {
                                var ccNumResults =
                                    _ccValidator.validateCCNum(cardNumber);
                                var cvvResults = _ccValidator.validateCVV(
                                    cvv, ccNumResults.ccType);

                                if (cvvResults.isValid) {
                                  return null;
                                } else {
                                  return 'Iraungitze-data okerra';
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: Colors.deepPurple,
                        ),
                        onPressed: () {
                          bool isFormValid =
                              formCardKey.currentState?.validate() ?? false;
                          if (isFormValid) {
                            CredCardLogic.isCardCreatedForCurrentUser()
                                .then((cardExists) {
                              if (cardExists) {
                                if (oldcardNumber == cardNumber &&
                                    oldcardHolderName == cardHolderName &&
                                    oldexpiryDate == expiryDate &&
                                    oldcvv == cvv) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Mezua:'),
                                          content: const Text(
                                              'Ez da txartel bera modifikatuko.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, 'OK');
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  CredCardLogic.editCard(
                                          txartelZenbakia: cardNumber,
                                          iraungitzea: expiryDate,
                                          cvv: cvv,
                                          titularra: cardHolderName,
                                          txartelmota: txartelmota)
                                      .then((result) {
                                    if (result == 'Erab eguneratua') {
                                      setState(() {
                                        oldcardNumber = cardNumber;
                                        oldcardHolderName = cardHolderName;
                                        oldexpiryDate = expiryDate;
                                        oldcvv = cvv;
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Mezua:'),
                                              content: const Text(
                                                  'Kred txartela eguneratu da.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          });

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ShowCard(
                                                  title: 'Diru-zorroa',
                                                )),
                                      );
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Errorea:'),
                                              content: Text(result),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  });
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Mezua:'),
                                        content: const Text(
                                            'Ez duzu kreditu txartela!.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    });
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CreateCard(
                                            title: 'Sortu txartela',
                                          )),
                                );
                              }
                            });
                          }
                        },
                        child: const Text('Aldatu'),
                      ),
                      SizedBox(width: screenSize.width * 0.05),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: Colors.deepPurple,
                        ),
                        onPressed: () {
                          bool isFormValid =
                              formCardKey.currentState?.validate() ?? false;
                          if (isFormValid) {
                            CredCardLogic.isCardCreatedForCurrentUser()
                                .then((cardExists) {
                              if (cardExists) {
                                CredCardLogic.deleteCard().then((result) {
                                  if (result == 'Erab ezabatua') {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Mezua:'),
                                            content: const Text(
                                                'Kred txartela ezabatu da.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'OK');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginHome()),
                                                  );
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Errorea:'),
                                            content: Text(result),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Mezua:'),
                                        content: const Text(
                                            'Ez duzu kreditu txartela!.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    });
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CreateCard(
                                            title: 'Sortu txartela',
                                          )),
                                );
                              }
                            });
                          }
                        },
                        child: const Icon(Icons.delete),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Future<String?> getCardInfo() async {
    setState(() {
      _isLoading = true;
    });

    String userCred = '';
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      userCred =
          authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

      String cardId = '';

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
          oldcardNumber = cardNumber;
          cardNumberCtrl.text = cardNumber.replaceAll(' ', '');
          cardHolderName = querySnapshot['titularra'];
          oldcardHolderName = cardHolderName;
          expiryDate = querySnapshot['iraungitzea'];
          oldexpiryDate = expiryDate;
          expiryFieldCtrl.text = expiryDate;
          expiryFieldCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: expiryDate.length));
          cvv = querySnapshot['cvv'];
          oldcvv = cvv;
          txartelmota = getCardCast(querySnapshot['txartelmota']);
        });
      });
    } else {
      firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

      String userId = auth.userId;

      String cardId = '';

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
          oldcardNumber = cardNumber;
          cardNumberCtrl.text = cardNumber.replaceAll(' ', '');
          cardHolderName = querySnapshot['titularra'];
          oldcardHolderName = cardHolderName;
          expiryDate = querySnapshot['iraungitzea'];
          oldexpiryDate = expiryDate;
          expiryFieldCtrl.text = expiryDate;
          expiryFieldCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: expiryDate.length));
          cvv = querySnapshot['cvv'];
          oldcvv = cvv;
          txartelmota = getCardCast(querySnapshot['txartelmota']);
        });
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
}
