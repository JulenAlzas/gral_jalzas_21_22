
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class RegisterProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _pass = '';
  String _confirmPass = '';

  String get getPass{
    return _pass;
  }
  set setPass(String pass){
    _pass = pass;
    notifyListeners();
  }

   String get getConfirmPass{
    return _confirmPass;
  }
  set setconfirmPass(String confirmpass){
    _confirmPass = confirmpass;
    notifyListeners();
  }
  
  String email = '';
  bool isLoading = false;
  bool seePassButton = false;


  bool isValidForm(){
    print(formKey.currentState?.validate());

    return formKey.currentState?.validate()??false;
  }


}
