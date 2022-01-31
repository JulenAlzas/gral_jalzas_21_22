import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/Provider/LoginProvider.dart';
import 'package:gral_jalzas_21_22/screens/LoginBackground.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ChangeNotifierProvider(
          create: (_) => LoginProvider(),
          child: LoginBackground(
          
        ),
        ),
      ),
    );
  }
}