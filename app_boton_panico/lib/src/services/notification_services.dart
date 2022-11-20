import 'dart:convert';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:http/http.dart' as http;
import 'package:app_boton_panico/src/models/entities.dart';

class NotificationServices {
  static const Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
  };

  Future<bool> postNotfication(alert) async {
    var url = Uri.http(Environments.url, Environments.postNotification);

    try {
      var response =
          await http.post(url, headers: headers, body: alertToJson(alert));
      return (response.statusCode == 200) ? true : false;
    } on SocketException {
      throw Failure("Error de socketExpetion");
    } on HttpException {
      throw Failure("Couldn't find the post");
    } on FormatException {
      throw Failure("Bad response format");
    }
  }

  Future<List<Alert>> getAlertsByUser(userId) async {
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
        return result.map((e) => Alert.fromJson(e)).toList();
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
}
