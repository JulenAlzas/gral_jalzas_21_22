import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _pass = '';

  String get pass {
    return _pass;
  }

  set pass(String pass) {
    _pass = pass;
    notifyListeners();
  }

  String email = '';
  double formHeight = 275;
  bool seePassButton = false;

  bool isValidForm() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formHeight = 275;
    } else if (formKey.currentState != null) {
      formHeight = 320;
    }
    notifyListeners();

    return formKey.currentState?.validate() ?? false;
  }
}
