import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/logic/LoginAuth.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const labelizena = 'Izena';
    const hintizena = 'Zure izena hemen';
    const Color eremuKolorea = Colors.white;

    return Scaffold(
      appBar: appBarDetails(context),
      body: Stack(
        children: [
          const BackgroundHome(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 15),
                Container(
                  height: 25,
                  padding: const EdgeInsets.only(left: 30),
                  child: ListView(
                    children: const [
                      Text('Profila Aldatu',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/profile-no-image.jpg'))),
                  ),
                ),
                erab_eremuak(
                    screenSize: screenSize,
                    eremuKolorea: eremuKolorea,
                    labelizena: labelizena,
                    hintizena: hintizena),
                const SizedBox(height: 5),
                erab_eremuak(
                    screenSize: screenSize,
                    eremuKolorea: eremuKolorea,
                    labelizena: 'E-posta',
                    hintizena: 'Sartu e-posta berria'),
                const SizedBox(height: 5),
                erab_eremuak(
                    screenSize: screenSize,
                    eremuKolorea: eremuKolorea,
                    labelizena: 'Pasahitza',
                    hintizena: 'Sartu pasahitz berria'),
                const SizedBox(height: 10),
                erab_eremuak(
                    screenSize: screenSize,
                    eremuKolorea: eremuKolorea,
                    labelizena: 'Mugikor zenbakia',
                    hintizena: 'Sartu mugikor zenbaki berria'),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {},
                    child: const Text('Aldatu'),
                  ),
                ),
              ],
            ),
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

class erab_eremuak extends StatelessWidget {
  const erab_eremuak({
    Key? key,
    required this.screenSize,
    required this.eremuKolorea,
    required this.labelizena,
    required this.hintizena,
  }) : super(key: key);

  final Size screenSize;
  final Color eremuKolorea;
  final String labelizena;
  final String hintizena;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: screenSize.width * 0.85,
        child: TextField(
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: eremuKolorea, width: 2.0)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: eremuKolorea)),
              labelStyle: TextStyle(color: eremuKolorea),
              labelText: labelizena,
              hintText: hintizena,
              hintStyle: TextStyle(color: eremuKolorea)),
        ),
      ),
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
