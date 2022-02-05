import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class Joko1 extends StatefulWidget {
  const Joko1({Key? key}) : super(key: key);

  @override
  State<Joko1> createState() => _Joko1State();
}

class _Joko1State extends State<Joko1> {
  @override
  Widget build(BuildContext context) {
    StreamController<int> controller = StreamController<int>();
    final screenSize = MediaQuery.of(context).size;
    double heighthRoulette = screenSize.width- screenSize.width*0.05;
    return Scaffold(
      body: Center(
        child: Container(
          width: heighthRoulette,
          child: FortuneWheel(
            indicators: const <FortuneIndicator>[
              FortuneIndicator(
                alignment: Alignment.topCenter, // <-- changing the position of the indicator
                child: TriangleIndicator(
                  color: Colors.black, // <-- changing the color of the indicator
                ),
              ),
            ],
            physics: CircularPanPhysics(
              duration: const Duration(seconds: 2),
              curve: Curves.decelerate,
            ),
            selected: controller.stream,
            items: [
              FortuneItem(
                child: const Text('Han Solo'),
                style: FortuneItemStyle(
                  color: Colors.pink,
                  borderColor:
                      Colors.pink.shade700, 
                  borderWidth: 10, 
                ),
              ),
              FortuneItem(
                child: const Text('Yoda'),
                style: FortuneItemStyle(
                  color: Colors.pink, 
                  borderColor:
                      Colors.pink.shade700, 
                  borderWidth: 10, 
                ),
              ),
              FortuneItem(child: const Text('Obi-Wan Kenobi'),style: FortuneItemStyle(
                  color: Colors.pink, 
                  borderColor:
                      Colors.pink.shade700, 
                  borderWidth: 10, 
                ),),
            ],
          ),
        ),
      ),
    );
  }
}
