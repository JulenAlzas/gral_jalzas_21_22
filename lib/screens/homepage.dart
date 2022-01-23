import 'package:flutter/material.dart';

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
          children: [
            Background(),
            OngiEtorri()
          ],
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
    return SingleChildScrollView(
      child: Column(
        children: [
           SafeArea(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('YouPlay4You', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white, overflow: TextOverflow.ellipsis)),
                //  ImageLayout(),
                 Text("last"),
               ]
             ),
           )
        ],
      ),
    );
  }
}


class ImageLayout extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ruleta.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Text('Proba') /* add child content here */,
      ),
    );
  }
}