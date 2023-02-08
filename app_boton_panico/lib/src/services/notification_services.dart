import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/alarm.dart';
import 'package:http/http.dart' as http;
import 'package:app_boton_panico/src/models/failure.dart';

class NotificationServices {
  static const Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
  };

  /// It takes an object of type Alarm, converts it to a json string, and sends it to the server
  ///
  /// Args:
  ///   alert (Alarm): is the object that I want to send to the server
  ///
  /// Returns:
  ///   A Future<bool>
  Future<String> postAlarm(Alarm alert) async {
    var url = Uri.http(Environments.url, Environments.postAlarm);

    try {
      var response =
          await http.post(url, headers: headers, body: alarmToJson(alert));
      return (response.statusCode == 200) ? response.body : null;
    } on SocketException {
      throw Failure("Error de socketExpetion");
    } on HttpException {
      throw Failure("Couldn't find the post");
    } on FormatException {
      throw Failure("Bad response format");
    }
  }

  Future<bool> putAlarm(Map alarm) async {
    var url =
        Uri.http(Environments.url, "${Environments.putAlarm}/${alarm["id"]}");

    try {
      var response =
          await http.put(url, headers: headers, body: jsonEncode(alarm));
      if (response.statusCode == 200) {
        Map body = jsonDecode(response.body);
        return body["status"];
      } else {
        return false;
      }
    } on SocketException {
      throw Failure("Error de socketExpetion");
    } on HttpException {
      throw Failure("Couldn't find the post");
    } on FormatException {
      throw Failure("Bad response format");
    }
  }

  /// It gets a list of alarms from the server, and returns a list of alarms
  ///
  /// Args:
  ///   userId (String): String
  ///
  /// Returns:
  ///   A list of Alarm objects.
  Future<List<Alarm>> getAlertsByUser(String userId) async {
    var url = Uri.http(
      Environments.url,
      Environments.getAlertsByUser + userId,
    );
    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List result = json.decode(response.body);
        return result.map((e) => Alarm.fromJson(e)).toList();
      } else {
        return null;
      }
    } on SocketException {
      throw Failure("Error de socketExpetion");
    } on HttpException {
      throw Failure("Couldn't find the post");
    } on FormatException {
      throw Failure("Bad response format");
    }
  }

  /// It makes a GET request to the server and returns the response.
  ///
  /// Returns:
  ///   A Future<dynamic>
  Future<dynamic> getDevices() async {
    var url = Uri.http(Environments.url, Environments.getDevices);
    try {
      final response = await http.get(url, headers: headers);
      return response;
    } on SocketException {
      throw Failure("Error de socketExpetion");
    } on HttpException {
      throw Failure("Couldn't find the post");
    } on FormatException {
      throw Failure("Bad response format");
    }
  }

  /// It sends a notification to a user's family group
  ///
  /// Args:
  ///   userId (String): The user id of the user who is sending the notification
  ///
  /// Returns:
  ///   A boolean value.

  Future<bool> sendNotificationFamilyGroup(String userId) async {
    try {
      Map data = {"user": userId};

      var url =
          Uri.http(Environments.url, Environments.sendNotificationFamilyGroup);
      final response =
          await http.post(url, headers: headers, body: jsonEncode(data));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded["status"];
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
}
