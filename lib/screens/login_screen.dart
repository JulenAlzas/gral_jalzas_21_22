import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/Provider/login_provider.dart';
import 'package:gral_jalzas_21_22/screens/login_background.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ChangeNotifierProvider(
          create: (_) => LoginProvider(),
          child: const LoginBackground(),
        ),
      ),
    );
  }
}
