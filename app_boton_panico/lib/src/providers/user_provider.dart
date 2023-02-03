import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:flutter/material.dart';

/// It's a class that provides a user object and a token to the rest of the app
class UserProvider extends ChangeNotifier {
  Map<String, dynamic> userData;

  /// It checks if the userData is null, if it is, it checks if the user and token are null, if they
  /// are, it calls the UserServices class and gets the userMap, if the userMap is null, it returns
  /// null, otherwise it sets the userData to the userMap and notifies the listeners
  /// 
  /// Args:
  ///   credentials: The credentials that the user entered in the login form.
  ///   user (User): The user object
  ///   token (String): The token that was returned from the server when the user logged in.
  /// 
  /// Returns:
  ///   A map of the user and token.
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

  

/// If the userData variable is not null, set it to null and return true. Otherwise, return false
/// 
/// Returns:
///   A boolean value.
  bool resetUser() {
    if (userData != null) {
      userData = null;
      return true;
    } else {
      return false;
    }
  }
}
