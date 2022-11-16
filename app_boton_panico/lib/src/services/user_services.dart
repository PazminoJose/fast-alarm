import 'dart:convert';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/entities.dart';
import 'package:http/http.dart' as http;

class UserServices {
  Future<User> getUser(credentials) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    };
    var url = Uri.http(Environments.url, Environments.getUser);
    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(credentials));
      var user = User();
      if (response.statusCode == 200) {
        final decoded = await json.decode(response.body);
        user = User.fromJson(decoded);
        return user;
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

  Future<User> saveUser(User user) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    };
    var url = Uri.http(Environments.url, Environments.getUser);
    try {
      final response =
          await http.post(url, headers: headers, body: userToJson(user));      
      if (response.statusCode == 200) {
        final decoded = await json.decode(response.body);
        user = userFromJson(decoded);
        return user;
      } else {
        return null;
      }
    } on SocketException {
      throw Failure("Error SocketExpetion");
    } on HttpException {
      throw Failure("Couldn't find the post");
    } on FormatException {
      throw Failure("Bad response format");
    }
  }

}
