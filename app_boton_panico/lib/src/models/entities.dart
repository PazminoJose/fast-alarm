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
    this.name,
    this.surname,
    this.idCard,
    this.email,
    this.password,
    this.userType,
  });

  String id;
  String name;
  String surname;
  String idCard;
  String email;
  String password;
  String userType;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        surname: json["surname"],
        idCard: json["idCard"],
        email: json["email"],
        password: json["password"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "surname": surname,
        "idCard": idCard,
        "email": email,
        "password": password,
        "userType": userType,
      };
}


class NotificationEntity {
    NotificationEntity({
        this.user,
        this.message,
        this.latitude,
        this.longitude,
    });

    String user;
    String message;
    double latitude;
    double longitude;

    factory NotificationEntity.fromJson(Map<String, dynamic> json) => NotificationEntity(
        user: json["user"],
        message: json["message"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "message": message,
        "latitude": latitude,
        "longitude": longitude,
    };
}


class Failure {
  // Use something like "int code;" if you want to translate error messages
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
