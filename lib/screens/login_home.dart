import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/logic/cred_card_logic.dart';
import 'package:gral_jalzas_21_22/screens/charts.dart';
import 'package:gral_jalzas_21_22/screens/create_card.dart';
import 'package:gral_jalzas_21_22/screens/edit_card.dart';
import 'package:gral_jalzas_21_22/screens/joko1.dart';
import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/screens/edit_profile.dart';
import 'package:gral_jalzas_21_22/screens/joko2.dart';
import 'package:gral_jalzas_21_22/screens/delete_account.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:gral_jalzas_21_22/screens/show_card.dart';

class LoginHome extends StatelessWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    double swiperobjectWidth = 0.0;
    double swiperobjectHeight = 0.0;

    if (defaultTargetPlatform == TargetPlatform.android) {
      swiperobjectWidth = screenSize.width * 0.7;
      swiperobjectHeight = screenSize.width * 0.7;
    } else {
      swiperobjectWidth = screenSize.width * 0.25;
      swiperobjectHeight = screenSize.width * 0.25;
    }

    List<String> gameImages = [
      'assets/erruletaJokoa.png',
      'assets/slotGame.png',
    ];

    return Scaffold(
      appBar: appBarDetails(context),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Container(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/Menu2.png'), fit: BoxFit.cover),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Profila aldatu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_remove_alt_1),
              title: const Text('Profila ezabatu'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeleteAccount()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet_travel),
              title: const Text('Diru-zorroa'),
              onTap: () {
                CredCardLogic.isCardCreatedForCurrentUser()
                    .then((cardExists) {
                  if (cardExists) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShowCard(
                                title: 'Diru-zorroa',
                              )),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateCard(
                                title: 'Sortu txartela',
                              )),
                    );
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card_rounded),
              title: const Text('Txartela modifikatu'),
              onTap: () {
                CredCardLogic.isCardCreatedForCurrentUser()
                    .then((cardExists) {
                  if (cardExists) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditCard(
                                title: 'Txartel informazio aldaketa',
                              )),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateCard(
                                title: 'Sortu txartela',
                              )),
                    );
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Diagramak'),
              onTap: () {
                CredCardLogic.existTransactions().then((transExist) {
                  if (transExist) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Charts()),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Errorea:'),
                            content: const Text(
                                'Ez da transakziorik existitzen grafikoak sortzeko.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });
                  }
                });
              },
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          const BackgroundHome(),
          Center(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Swiper(
                  itemCount: gameImages.length,
                  layout: SwiperLayout.STACK,
                  itemWidth: swiperobjectWidth,
                  itemHeight: swiperobjectHeight,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (gameImages[index] == 'assets/erruletaJokoa.png') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Joko1()),
                          );
                        } else if (gameImages[index] ==
                            'assets/slotGame.png') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Joko2()),
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/no-image.jpg'),
                          image: AssetImage(gameImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            )),
          )
        ],
      ),
    );
  }

  AppBar appBarDetails(BuildContext context) {
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
}

class BackgroundHome extends StatelessWidget {
  const BackgroundHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      ),
    );
  }
}
