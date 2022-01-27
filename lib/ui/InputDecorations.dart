import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration loginInputDecoration(
      {required String hintText,
      required String labelText,
      required Color textStyleColor,
      IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2.0)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purple)),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: textStyleColor),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.purple,
              )
            : null);
  }
}
