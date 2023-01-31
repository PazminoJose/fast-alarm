import 'dart:convert';

import 'package:app_boton_panico/src/models/user.dart';

UserAlert userAlertFromJson(String str) => UserAlert.fromJson(json.decode(str));

class UserAlert {
  UserAlert({
    this.user,
    this.state,
  });

  String state;
  User user;
//TODO: aquii
  factory UserAlert.fromJson(Map<String, dynamic> json) => UserAlert(
        state: json["state"],
        user: userFromJson(jsonEncode(json["user"])),
      );
}
