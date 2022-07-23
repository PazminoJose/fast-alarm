import 'dart:convert';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  static const Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
  };
  Future<void> postNotfication(data) async {
    var url = Uri.http(Environments.url, Environments.postNotification);

    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));
  }

  Future<dynamic> getDevices() async {
    var url = Uri.http(Environments.url, Environments.getDevices);
    final response = await http.get(url, headers: headers);
    return response;
  }
}
