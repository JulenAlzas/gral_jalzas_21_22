import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/logic/LoginAuth.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> formEditProfKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _fullName = '';
  String _email = '';
  String _telephNum = '';
  String _passw = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserEmail();
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final screenSize = MediaQuery.of(context).size;
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
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1))
                        ],
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/profile-no-image.jpg'))),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: screenSize.width * 0.85,
                    child: TextFormField(
                      style: const TextStyle(color: eremuKolorea),
                      initialValue: _email,
                      onChanged: (nameChange) {
                        setState(() {
                          _fullName = nameChange;
                        });
                      },
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: eremuKolorea, width: 2.0)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: eremuKolorea)),
                          labelStyle: TextStyle(color: eremuKolorea),
                          labelText: 'Izena',
                          hintText: 'Sartu izen berria',
                          hintStyle: TextStyle(color: eremuKolorea)),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: SizedBox(
                    width: screenSize.width * 0.85,
                    child: Form(
                      key: formEditProfKey,
                      child: TextFormField(
                        style: const TextStyle(color: eremuKolorea),
                        initialValue: _email,
                        onChanged: (emailChange) {
                          setState(() {
                            _email = emailChange;
                          });
                        },
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: eremuKolorea, width: 2.0)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: eremuKolorea)),
                            labelStyle: TextStyle(color: eremuKolorea),
                            labelText: 'E-posta',
                            hintText: 'Sartu e-posta berria',
                            hintStyle: TextStyle(color: eremuKolorea)),
                      ),
                    ),
                  ),
                ),              
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

  // void setEmail(Future<String> Function() getUserEmail) async {
  //   email = await getUserEmail();

  //   getUserEmail().then((String? result) {
  //     setState(() {
  //       email = result.toString();
  //     });
  //   });
  // }

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

  void getUserEmail() async {
      User? user = FirebaseAuth.instance.currentUser;

      setState(() {
        _email = user!.email!;
      });
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
