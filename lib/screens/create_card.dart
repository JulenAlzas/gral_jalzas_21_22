import 'dart:math' as math;
import 'package:credit_card_validator/validation_results.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:credit_card_validator/credit_card_validator.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                cardType: CardType.visa,
                // mask: getCardTypeMask(cardType: CardType.americanExpress),
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
                        },
                        validator: (_) {
                          var ccNumResults =
                              _ccValidator.validateCCNum(cardNumber);
                          if (ccNumResults.isValid) {
                            return null;
                          }
                           else if(ccNumResults.message == 'No input or contains non-numerical characters'){
                            return 'Sarrera hutsa edo karaktere ez zenbakizkoak';
                          }
                          else {
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
                      maxLength: 3,
                      onChanged: (value) {
                        setState(() {
                          cvv = value;
                        });
                      },
                      focusNode: _focusNode,
                      validator: (_) {
                        var ccNumResults =
                              _ccValidator.validateCCNum(cardNumber);
                          var cvvResults = _ccValidator.validateCVV(cvv, ccNumResults.ccType );
                          if (cvvResults.isValid) {
                            return null;
                          } else {
                            return 'Iraungitze-data okerra';
                          }
                        }
                    ),
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
                  if (formCardKey.currentState?.validate() ?? false) {}
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
