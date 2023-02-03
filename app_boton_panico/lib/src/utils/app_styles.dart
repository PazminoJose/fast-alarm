import 'package:flutter/material.dart';

/// It's a class that contains static variables that are used throughout the app
class Styles {
  static Color primaryColor = const Color.fromRGBO(56, 56, 76, 1);
  static Color secondaryColor = Colors.blueGrey[800];
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color gray = Colors.grey[400];
  static Color green = Colors.green;
  static Color red = Colors.red[300];
  static Color redText = Colors.red;
  static Color tranparent = Colors.transparent;
  static Color blur = const Color.fromARGB(48, 255, 255, 255);
  static RegExp exprOnlyLetter = RegExp(r'[ a-zA-Z]');
  static RegExp exprOnlydigists = RegExp(r'[0-9]');
  static RegExp exprWithoutWhitspace = RegExp(r'[ ]');
  static RegExp exprWithLetterDigits = RegExp(r'[ A-Za-z0-9]');
  static TextStyle textStyleBody = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: white,
  );
  static TextStyle textStyleTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: black,
  );

  static TextStyle textStyleBotttomTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: black,
  );
  static TextStyle textLabel = const TextStyle(
    fontSize: 15,
  );
  static TextStyle textButtonTrackLocation = TextStyle(color: redText);
  static TextStyle textState =
      TextStyle(color: redText, fontWeight: FontWeight.bold);
}
