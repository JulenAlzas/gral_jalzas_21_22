import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/screens/Background.dart';
import 'package:gral_jalzas_21_22/screens/login_screen.dart';
import 'package:gral_jalzas_21_22/screens/register_screen.dart';
import 'package:intl/intl.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      home: Scaffold(
        body: Stack(
          children: const [Background(), OngiEtorri()],
        ),
      ),
    );
  }
}

class OngiEtorri extends StatefulWidget {
  const OngiEtorri({
    Key? key,
  }) : super(key: key);

  @override
  State<OngiEtorri> createState() => _OngiEtorriState();
}

class _OngiEtorriState extends State<OngiEtorri> {
  DateTime currentTimestamp = DateTime.now();
  DateFormat formatterDate = DateFormat('dd/MM/yyyy');
  DateFormat formatteOrduMin = DateFormat.jm();
  String currentOrduMin = '';
  String currentDate = '';
  double loginhomeheighdistance = 0.0;
  double fontSize = 0.0;
  

  @override
  void initState() {
    currentDate = formatterDate.format(currentTimestamp);
    currentOrduMin = formatteOrduMin.format(currentTimestamp);
    var firstOrduMin = formatteOrduMin.format(currentTimestamp);
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) { 
      DateTime currentTime = DateTime.now();
      DateFormat currentOrduMinFormat = DateFormat.jm();
      var currentOrduMinEvery1s = currentOrduMinFormat.format(currentTime);
      if(firstOrduMin != currentOrduMinEvery1s){
        setState(() {
          currentOrduMin = currentOrduMinEvery1s;
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    if (defaultTargetPlatform == TargetPlatform.android) {
      loginhomeheighdistance = screenSize.height * 0.01;
      fontSize = screenWidth*0.1;
    }
    else{
      loginhomeheighdistance = screenSize.height * 0.005;
      fontSize = screenWidth*0.05;
    }

    return SingleChildScrollView(
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.3,
            height: screenSize.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/sideImage.jpg'), fit: BoxFit.cover),
            ),
          ),
          Container(
            width: screenWidth * 0.7,
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentOrduMin,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  currentDate,
                  style: const TextStyle(
                      fontSize: 15, fontFamily: 'avenir', color: Colors.grey),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  'UPlay4U',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(color: Colors.white,fontSize: fontSize),
                ),
                SizedBox(height: screenSize.height * 0.01),
                CardImage(screenSize: screenSize),
                SizedBox(height: screenSize.height * 0.01),
                const CustomButtons(),
              ],
            ),
          )
        ],
      ),
    );

    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       SafeArea(
    //         child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Text(
    //                 'YouPlay4You',
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .headline2
    //                     ?.copyWith(color: Colors.white),
    //               ),
    //               const SizedBox(height: 20),
    //               CardImage(screenWidth: screenWidth),
    //               const SizedBox(height: 20),
    //               const CustomButtons(),
    //             ]),
    //       )
    //     ],
    //   ),
    // );
  }
}

class CustomButtons extends StatelessWidget {
  const CustomButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomButton(
            myname: 'login', myiconName: Icons.login, mycolor: Colors.pink),
        CustomButton(
            myname: 'register',
            myiconName: Icons.app_registration,
            mycolor: Colors.pink.withOpacity(0.1)),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final String myname;
  final IconData myiconName;
  final Color mycolor;

  const CustomButton({
    Key? key,
    required this.myname,
    required this.myiconName,
    required this.mycolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height:  MediaQuery.of(context).size.height * 0.05,
      child: FloatingActionButton.extended(
        heroTag: myname,
        onPressed: () {
          if (myname == 'login') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          }
        },
        label: Text(myname),
        icon: Icon(myiconName),
        backgroundColor: mycolor,
      ),
    );
  }
}

class CardImage extends StatelessWidget {
  const CardImage({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Column(
        children: [
          FadeInImage(
            width: screenSize.width,
            height: screenSize.height*0.3,
            placeholder: const AssetImage('assets/loading2.gif'),
            image: const AssetImage('assets/ruleta.jpg'),
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 200),
          ),
          Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: const EdgeInsets.all(10),
              child: const Text("Ondo pasatzeko momentua da"))
        ],
      ),
    );
  }
}
