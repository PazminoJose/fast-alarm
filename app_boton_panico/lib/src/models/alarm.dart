import 'dart:convert';
Alarm alarmFromJson(String str) => Alarm.fromJson(json.decode(str));

String alarmToJson(Alarm data) => json.encode(data.toJson());


/// The class Alarm has a constructor that takes a Map<String, dynamic> and returns an Alarm object
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

  /// This function takes a JSON object and returns an Alarm object
  /// 
  /// Args:
  ///   json (Map<String, dynamic>): The JSON data that you want to convert to a Dart object.
  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        user: json["user"],
        message: json["message"],
        state: json["state"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
      );

 /// It takes a JSON object and returns a Dart object
  Map<String, dynamic> toJson() => {
        "user": user,
        "message": message,
        "state": state,
        "latitude": latitude,
        "longitude": longitude,
      };
}
