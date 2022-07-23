import 'package:app_boton_panico/src/models/entities.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  var user;

  Future<User> getUser(credentials) async {
    if (user != null) {
      return user;
    }

    var service = UserServices();
    user = await service.getUser(credentials).onError((error, stackTrace) =>
        error.stackTrace(print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")));
    notifyListeners();
    return user;
  }
}
