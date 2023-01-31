import 'dart:convert';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/alarm.dart';
import 'package:http/http.dart' as http;
import 'package:app_boton_panico/src/models/failure.dart';

class NotificationServices {
  static const Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
  };

  Future<bool> postNotfication(alert) async {
    var url = Uri.http(Environments.url, Environments.postNotification);

    try {
      var response =
          await http.post(url, headers: headers, body: alarmToJson(alert));
      return (response.statusCode == 200) ? true : false;
    } on SocketException {
      throw Failure("Error de socketExpetion");
    } on HttpException {
      throw Failure("Couldn't find the post");
    } on FormatException {
      throw Failure("Bad response format");
    }
  }

  Future<List<Alarm>> getAlertsByUser(userId) async {
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
