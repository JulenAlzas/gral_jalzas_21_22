import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/Provider/RegisterProvider.dart';
import 'package:gral_jalzas_21_22/screens/ResgisterBackground.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ChangeNotifierProvider(
          create: (_) => RegisterProvider(),
          child: RegisterBackground(
          
        ),
        )
      ),
    );
  }
}