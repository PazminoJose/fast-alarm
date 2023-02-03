import 'dart:convert';

import 'package:app_boton_panico/src/models/user.dart';

UserAlert userAlertFromJson(String str) => UserAlert.fromJson(json.decode(str));

/// The UserAlert class has a user property of type User
class UserAlert {
  /// A constructor.
  UserAlert({
    this.user,
    this.state,
  });

  String state;
  User user;
  /// It takes a JSON string, converts it to a Map, then uses the Map to create a UserAlert object
  /// 
  /// Args:
  ///   json (Map<String, dynamic>): The JSON object that you want to convert to a Dart object.
  factory UserAlert.fromJson(Map<String, dynamic> json) => UserAlert(
        state: json["state"],
        user: userFromJson(jsonEncode(json["user"])),
      );
}
