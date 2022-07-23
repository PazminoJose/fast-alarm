//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

NotificationEntity notificationFromJson(String str) =>
    NotificationEntity.fromJson(json.decode(str));

String notificationToJson(NotificationEntity data) =>
    json.encode(data.toJson());

class User {
  User({
    this.id,
    this.company,
    this.name,
    this.surname,
    this.email,
    this.password,
    this.userType,
  });

  String id;
  Company company;
  String name;
  String surname;
  String email;
  String password;
  String userType;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        company: Company.fromJson(json["company"]),
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        password: json["password"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "company": company.toJson(),
        "name": name,
        "surname": surname,
        "email": email,
        "password": password,
        "user_type": userType,
      };
}

class Company {
  Company({
    this.id,
    this.headOffice,
    this.name,
    this.address,
    this.contact,
    this.latitude,
    this.longitude,
  });

  String id;
  dynamic headOffice;
  String name;
  String address;
  String contact;
  double latitude;
  double longitude;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["_id"],
        headOffice: json["headOffice"],
        name: json["name"],
        address: json["address"],
        contact: json["contact"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "headOffice": headOffice,
        "name": name,
        "address": address,
        "contact": contact,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class NotificationEntity {
  NotificationEntity({
    this.id,
    this.user,
    this.message,
    this.date,
  });

  String id;
  String user;
  String message;
  DateTime date;

  factory NotificationEntity.fromJson(Map<String, dynamic> json) =>
      NotificationEntity(
        id: json["_id"],
        user: json["user"],
        message: json["message"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "message": message,
        "date": date.toIso8601String(),
      };
}
