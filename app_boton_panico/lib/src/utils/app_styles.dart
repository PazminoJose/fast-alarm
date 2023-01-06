import 'package:flutter/material.dart';

class Styles {
  static Color primaryColor = const Color.fromRGBO(56, 56, 76, 1);
  static Color secondaryColor = Colors.blueGrey[800];
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color green = Colors.green;
  static Color red = Colors.red[300];
  static Color tranparent = Colors.transparent;
  static Color blur = Color.fromARGB(48, 255, 255, 255);
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
  static TextStyle textLabel = TextStyle(
    fontSize: 15,
  );
}
