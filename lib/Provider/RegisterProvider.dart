
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class RegisterProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
   String name = '';
  String telepNum = '';
  String _pass = '';
  String _confirmPass = '';

  String get pass{
    return _pass;
  }

  set pass(String pass) {
    _pass = pass;
    notifyListeners();
  }

   String get confirmPass{
    return _confirmPass;
  }
  set confirmPass(String confirmpass){
    _confirmPass = confirmpass;
    notifyListeners();
  }
  
  String email = '';
  double formHeight = 475;

  bool isValidForm(){
    print(formKey.currentState?.validate());

    if(formKey.currentState != null && formKey.currentState!.validate()){
      formHeight = 475;
    }
    else if(formKey.currentState != null){
      formHeight = 610;
    }
  notifyListeners();

    return formKey.currentState?.validate()??false;
  }


}
