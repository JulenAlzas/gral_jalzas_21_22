import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration loginInputDecoration(
      {required String hintText,
      required String labelText,
      required Color textStyleColor,
      int? errorMaxLines,
      IconData? prefixIcon}) {
    return InputDecoration(
        errorMaxLines: errorMaxLines,
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
