import 'dart:convert';

Alarm alarmFromJson(String str) => Alarm.fromJson(json.decode(str));

String alarmToJson(Alarm data) => json.encode(data.toJson());

/// The class Alarm has a constructor that takes a Map<String, dynamic> and returns an Alarm object
class Alarm {
  Alarm({
    this.id,
    this.person,
    this.state,
    this.latitude,
    this.longitude,
    bool isLast,
  });

  String id;
  String person;
  String state;
  double latitude;
  double longitude;
  bool isLast;

  /// This function takes a JSON object and returns an Alarm object
  ///
  /// Args:
  ///   json (Map<String, dynamic>): The JSON data that you want to convert to a Dart object.
  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        person: json["person"],
        state: json["state"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  /// It takes a JSON object and returns a Dart object
  Map<String, dynamic> toJson() => {
        "person": person,
        "state": state,
        "latitude": latitude,
        "longitude": longitude,
        "isLast": isLast,
      };
}
