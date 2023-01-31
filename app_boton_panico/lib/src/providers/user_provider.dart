import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> userData;

  Future<Map<String, dynamic>> getUser(credentials,
      [User user, String token]) async {
    if (userData != null) {
      return userData;
    }

    if (user != null && token != null) {
      userData = {
        "user": user,
        "token": token,
      };
    } else {
      var service = UserServices();
      Map userMap = await service.getUser(credentials);
      if (userMap == null) return null;
      userData = {
        "user": userMap["user"],
        "token": userMap["token"],
      };
    }

    notifyListeners();
    return userData;
  }

  

  bool resetUser() {
    if (userData != null) {
      userData = null;
      return true;
    } else {
      return false;
    }
  }
}
