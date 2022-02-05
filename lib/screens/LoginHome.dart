import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/screens/Joko1.dart';

class LoginHome extends StatelessWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Lehen jokoa')),
          elevation: 0,
        ),
        body: Stack(
          children: [
            // const BackgroundHome(), 

            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Joko1()),
                        );
                      },
                      child: const Text('Joko1'),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Joko1()),
                        );
                      },
                      child: const Text('Joko2'),
                    ),
                  ],
                )
              ),
            )
          
          ],
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
          end: Alignment(0.4,0.5),
          colors: <Color>[
            Color.fromARGB(235,153,0,76),
            Color.fromARGB(235, 204,0,102)
          ], 
          tileMode: TileMode.repeated, 
        ),
      ),
    );
  }
}