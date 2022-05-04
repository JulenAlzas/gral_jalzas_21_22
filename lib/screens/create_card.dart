import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:gral_jalzas_21_22/logic/cred_card_logic.dart';
import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:gral_jalzas_21_22/screens/show_card.dart';

class CreateCard extends StatefulWidget {
  const CreateCard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CreateCardState createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;
  CardType txartelmota = CardType.visa;

  double cardWidth = 0.0;
  double cardHeight = 0.0;

  late FocusNode _focusNode;
  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();

  GlobalKey<FormState> formCardKey = GlobalKey<FormState>();
  final CreditCardValidator _ccValidator = CreditCardValidator();

  @override
  void initState() {
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
      ),
      body: SingleChildScrollView(
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
                        decoration:
                            const InputDecoration(hintText: 'Txartel zenbakia'),
                        maxLength: 16,
                        onChanged: (value) {
                          final newCardNumber = value.trim();
                          var newStr = '';
                          int step = 4;

                          for (var i = 0; i < newCardNumber.length; i += step) {
                            newStr += newCardNumber.substring(
                                i, math.min(i + step, newCardNumber.length));
                            if (i + step < newCardNumber.length) newStr += ' ';
                          }

                          setState(() {
                            cardNumber = newStr;
                          });

                          var ccNumResults =
                              _ccValidator.validateCCNum(cardNumber);

                          if (ccNumResults.isValid) {
                            setState(() {
                              if (ccNumResults.ccType == CreditCardType.visa) {
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
                                  ccNumResults.ccType == CreditCardType.mir ||
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
                            return 'Sarrera okerra: ' + ccNumResults.message;
                          }
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                        controller: expiryFieldCtrl,
                        decoration:
                            const InputDecoration(hintText: 'Iraungitze-data'),
                        maxLength: 5,
                        onChanged: (value) {
                          var newDateValue = value.trim();
                          final isPressingBackspace =
                              expiryDate.length > newDateValue.length;
                          final containsSlash = newDateValue.contains('/');

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
                                TextSelection.fromPosition(
                                    TextPosition(offset: newDateValue.length));
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
                        decoration: const InputDecoration(hintText: 'CVV'),
                        maxLength:
                            txartelmota == CardType.americanExpress ? 4 : 3,
                        onChanged: (value) {
                          setState(() {
                            cvv = value;
                          });
                        },
                        focusNode: _focusNode,
                        validator: (_) {
                          var ccNumResults =
                              _ccValidator.validateCCNum(cardNumber);
                          var cvvResults = _ccValidator.validateCVV(
                              cvv, ccNumResults.ccType);

                          if (cvvResults.isValid) {
                            return null;
                          } else {
                            return 'CVV okerra';
                          }
                        }),
                  ),
                ],
              ),
            ),
            Center(
              child: TextButton(
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
                      if (!cardExists) {
                        CredCardLogic.addNewCard(
                                txartelZenbakia: cardNumber,
                                iraungitzea: expiryDate,
                                cvv: cvv,
                                titularra: cardHolderName,
                                txartelmota: txartelmota)
                            .then((value) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Mezua:'),
                                  content:
                                      const Text('Kred txartela gorde da.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShowCard(
                                      title: 'Diru-zorroa',
                                    )),
                          );
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Mezua:'),
                                content:
                                    const Text('Iada kreditu txartela duzu.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            });
                      }
                    });
                  }
                },
                child: const Text('Txartela sortu'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
