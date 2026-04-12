import 'package:flutter/material.dart';

Color strengthColor(double passStrength){
    if(passStrength <= 1/4) {
      return Colors.red;
    } else if(passStrength <= 2/4) {
      return Colors.orange;
    } else if(passStrength <= 3/4) {
      return Colors.yellow;
    } else {
      return Colors.lightGreen;
    }
}