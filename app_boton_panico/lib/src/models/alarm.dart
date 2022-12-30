import 'dart:convert';
Alarm alarmFromJson(String str) => Alarm.fromJson(json.decode(str));

String alarmToJson(Alarm data) => json.encode(data.toJson());


class Alarm {
  Alarm({
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

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        user: json["user"],
        message: json["message"],
        state: json["state"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "message": message,
        "state": state,
        "latitude": latitude,
        "longitude": longitude,
      };
}
