
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class RegisterProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
  double formHeight = 460;
  bool isLoading = false;
  bool seePassButton = false;


  bool isValidForm(){
    print(formKey.currentState?.validate());

    if(formKey.currentState != null && formKey.currentState!.validate()){
      formHeight = 460;
    }
    else if(formKey.currentState != null){
      formHeight = 595;
    }
  notifyListeners();

    return formKey.currentState?.validate()??false;
  }


}
