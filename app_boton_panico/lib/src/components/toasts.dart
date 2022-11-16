import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

FToast fToast;

class MyToast {
  static showToast(String messege, String color, String icon, context) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: (color == "red") ? Colors.red : Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon((icon == "error") ? Icons.error : Icons.key_outlined),
          const SizedBox(
            width: 12.0,
          ),
          Text(messege),
        ],
      ),
    );
    fToast.init(context);
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
      fadeDuration: 1000,
    );
  }
}
