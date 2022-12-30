import 'dart:convert';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/failure.dart';
import 'package:app_boton_panico/src/models/user.dart';
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

      if (response.statusCode == 200) {
        final decoded = await json.decode(response.body);
        User user = User.fromJson(decoded);
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
    var url = Uri.http(Environments.url, Environments.postUser);
    try {
      Map<String, String> userPsot = {
        "userName": user.userName,
        "email": user.email,
        "password": user.password,
        "userType": user.userType,
        "person": user.person.id.toString(),
      };
      final response =
          await http.post(url, headers: headers, body: jsonEncode(userPsot));
      if (response.statusCode == 200) {
        var decoded = await json.decode(json.encode(response.body.toString()));
        user = userFromJson(decoded);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }
}
