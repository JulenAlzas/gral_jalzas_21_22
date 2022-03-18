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
import 'package:gral_jalzas_21_22/logic/add_creditcard.dart';
import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

class ShowCard extends StatefulWidget {
  const ShowCard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ShowCardState createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> {
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;
  CardType txartelmota = CardType.visa;

  bool _isLoading = false;

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
    getCardInfo();
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
              // mask: getCardTypeMask(cardType: CardType.americanExpress),
            ),
            const SizedBox(
              height: 40,
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
                    AddCreditCard.isCardCreatedForCurrentUser()
                        .then((cardExists) {
                      if (cardExists) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Mezua:'),
                                content:
                                    const Text('Iada kreditu txartela duzu'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            });
                      } else {
                        AddCreditCard.addNewCard(
                            txartelZenbakia: cardNumber,
                            iraungitzea: expiryDate,
                            cvv: cvv,
                            titularra: cardHolderName);

                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Mezua:'),
                                content: const Text('Kred txartela gorde da.'),
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
          .collection('credcard')
          .where('userUID', isEqualTo: userCred)
          .get()
          .then((querySnapshot) {
        cardId = querySnapshot.docs.first.id;
      });

      await FirebaseFirestore.instance
          .collection('credcard')
          .doc(cardId)
          .get()
          .then((querySnapshot) {
        setState(() {
          cardNumber = querySnapshot['txartelZenbakia'];
          cardHolderName = querySnapshot['titularra'];
          expiryDate = querySnapshot['iraungitzea'];
          cvv = querySnapshot['cvv'];
        });
      });
    } else {
      firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

      String userId = auth.userId;

      String cardId = firedart.Firestore.instance
          .collection('credcard')
          .where('userUID', isEqualTo: userId)
          .id;

      await firedart.Firestore.instance
          .collection('credcard')
          .document(cardId)
          .get()
          .then((querySnapshot) {
        setState(() {
          cardNumber = querySnapshot['txartelZenbakia'];
          cardHolderName = querySnapshot['titularra'];
          expiryDate = querySnapshot['iraungitzea'];
          cvv = querySnapshot['cvv'];
        });
      });
    }

    setState(() {
      _isLoading = false;
    });
  }
}
