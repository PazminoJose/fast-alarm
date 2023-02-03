import 'package:flutter/cupertino.dart';

/// This class is used to get the size of the screen
class AppLayout {
  static getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}
