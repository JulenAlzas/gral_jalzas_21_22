import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/screens/LoginHome.dart';
import 'package:gral_jalzas_21_22/screens/LoginScreen.dart';
import 'package:gral_jalzas_21_22/screens/RegisterScreen.dart';
import 'package:gral_jalzas_21_22/screens/EditProfile.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';

import 'package:firebase_core/firebase_core.dart';

// import 'package:firedart/firedart.dart';
import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb || Platform.isLinux || Platform.isWindows) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCcy_xzW16tX9LoUVXiP4CXZUhfvbh6SLA",
            authDomain: "gral-jalzas.firebaseapp.com",
            projectId: "gral-jalzas",
            storageBucket: "gral-jalzas.appspot.com",
            messagingSenderId: "312983830076",
            appId: "1:312983830076:web:dee094b1ff0e3803a10d39",
            measurementId: "G-5D6PWQE0L1"));
  } else if ((Platform.isAndroid)) {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'homepage',
      routes: {
        'homepage': (BuildContext context) => const Homepage(),
        'login': (BuildContext context) => const LoginScreen(),
        'register': (BuildContext context) => const RegisterScreen(),
        'loginhome': (BuildContext context) => const LoginHome(),
        'editprofile': (BuildContext context) => const EditProfile(),
      },
    );
  }
}
