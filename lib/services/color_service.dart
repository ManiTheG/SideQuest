import 'package:flutter/material.dart';

class AppColors {
  static const primaryBackground = Color.fromARGB(255, 16, 24, 40);
  static const secondaryBackground = Color.fromARGB(255, 29, 52, 97);
  static const secondary = Color.fromARGB(255, 25, 36, 54);
  static const profilePost = Color.fromARGB(255, 54, 67, 99);
  static const textColor = Colors.white;
  static const textColorAutor = Colors.white60;
  static const textColorOpis = Colors.white70;
  static const buttonColor = Color.fromARGB(255, 16, 103, 234);
  static const selectButtonColor = Color.fromARGB(255, 55, 73, 87);
  static const unselectButtonColor = Colors.white38;
  static const danger = Colors.red;
  static const buttonShadow = Color.fromARGB(255, 108, 99, 255);
}

Color strengthColor(double passStrength) {
  if (passStrength <= 1 / 4) {
    return Colors.red;
  } else if (passStrength <= 2 / 4) {
    return Colors.orange;
  } else if (passStrength <= 3 / 4) {
    return Colors.yellow;
  } else {
    return Colors.lightGreen;
  }
}
