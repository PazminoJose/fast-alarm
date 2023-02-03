import 'dart:convert';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/user_alert.dart';
import 'package:http/http.dart' as http;
import 'package:app_boton_panico/src/models/failure.dart';

class AlertsServices {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
  };

 /// I'm trying to get a list of objects from a rest api, but I'm getting a null value
 /// 
 /// Args:
 ///   personId (String): String
 /// 
 /// Returns:
 ///   A list of UserAlert objects.
  Future<List<UserAlert>> getUsersAlertsByPerson(String personId) async {
    var url = Uri.http(
      Environments.url,
      "${Environments.getUsersAlertsByPersson}/$personId",
    );
    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List result = json.decode(response.body);
        return result.map((e) => UserAlert.fromJson(e)).toList();
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
}
