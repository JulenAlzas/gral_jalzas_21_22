import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/screens/LoginScreen.dart';
import 'package:gral_jalzas_21_22/screens/RegisterScreen.dart';

import 'Background.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

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

class OngiEtorri extends StatelessWidget {
  const OngiEtorri({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'YouPlay4You',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 20),
                  CardImage(screenWidth: screenWidth),
                  const SizedBox(height: 20),
                  const CustomButtons(),
                ]),
          )
        ],
      ),
    );
  }
}

class CustomButtons extends StatelessWidget {
  const CustomButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CustomButton(
            myname: 'login',
            myiconName: Icons.login,
            mycolor: Colors.pink),
        CustomButton(
            myname: 'register',
            myiconName: Icons.app_registration,
            mycolor: Colors.pink),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final String myname;
  final IconData myiconName;
  final MaterialColor mycolor;

  const CustomButton({
    Key? key,
    required this.myname,
    required this.myiconName,
    required this.mycolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: myname,
      onPressed: () {
        if(myname == 'login'){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
        }
      },
      label: Text(myname),
      icon: Icon(myiconName),
      backgroundColor: mycolor,
    );
  }
}

class CardImage extends StatelessWidget {
  const CardImage({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Column(
        children: [
          FadeInImage(
            width: screenWidth,
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
