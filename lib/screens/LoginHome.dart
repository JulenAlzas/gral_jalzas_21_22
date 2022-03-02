import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/screens/Joko1.dart';
import 'package:gral_jalzas_21_22/logic/LoginAuth.dart';
import 'package:gral_jalzas_21_22/screens/EditProfile.dart';
import 'package:gral_jalzas_21_22/screens/Joko2.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

import 'package:card_swiper/card_swiper.dart';

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
      swiperobjectWidth = screenSize.width * 0.08;
      swiperobjectHeight = screenSize.width * 0.08;
    }

    List<String> gameImages = [
      'assets/erruletaJokoa.png',
      'assets/Banana.png',
    ];

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Loginera bueltatzeko atera sesiotik')));
        return false;
      },
      child: Scaffold(
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
                  print('Eraman profila aldatzera');
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
                          }else  if (gameImages[index] == 'assets/Banana.png'){
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
                  )
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //     textStyle: const TextStyle(fontSize: 20),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const Joko1()),
                  //     );
                  //   },
                  //   child: const Text('Joko1'),
                  // ),
                  ,
                  const SizedBox(height: 30),
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //     textStyle: const TextStyle(fontSize: 20),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const Joko1()),
                  //     );
                  //   },
                  //   child: const Text('Joko2'),
                  // ),
                ],
              )),
            )
          ],
        ),
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
