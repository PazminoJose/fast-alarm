// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';


import 'package:app_boton_panico/src/models/person.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.userName,
    this.email,
    this.password,
    this.idOneSignal,
    this.userType,
    this.person,
    this.coreTrust,
  });

  String id;
  String userName;
  String email;
  String password;
  String idOneSignal;
  String userType;
  Person person;
  List<Person> coreTrust;
//TODO: aquii
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
        idOneSignal: json["idOneSignal"],
        userType: json["userType"],
        person: personFromJson(jsonEncode(json["person"])),
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "email": email,
        "password": password,
        "idOneSignal": idOneSignal,
        "userType": userType,
        "person": person.toJson(),
      };
}
