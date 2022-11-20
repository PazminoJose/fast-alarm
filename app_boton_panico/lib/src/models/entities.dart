import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

Alert alertFromJson(String str) => Alert.fromJson(json.decode(str));

String alertToJson(Alert data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.name,
    this.surname,
    this.idCard,
    this.phone,
    this.email,
    this.password,
    this.userType,
  });

  String id;
  String name;
  String surname;
  String idCard;
  String phone;
  String email;
  String password;
  String userType;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        surname: json["surname"],
        idCard: json["idCard"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "surname": surname,
        "idCard": idCard,
        "phone": phone,
        "email": email,
        "password": password,
        "userType": userType,
      };
}

class Alert {
  Alert({
    this.id,
    this.user,
    this.message,
    this.state,
    this.latitude,
    this.longitude,
    this.createdAt,
  });

  String id;
  String user;
  String message;
  String state;
  double latitude;
  double longitude;
  DateTime createdAt;

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        user: json["user"],
        message: json["message"],
        state: json["state"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "message": message,
        "state": state,
        "latitude": latitude,
        "longitude": longitude,
        "createdAt": createdAt.toIso8601String(),
      };
}

class Failure {
  // Use something like "int code;" if you want to translate error messages
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
