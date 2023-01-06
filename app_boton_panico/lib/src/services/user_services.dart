import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/failure.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserServices {
  Future<Map<String, dynamic>> getUser(credentials) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    };
    var url = Uri.http(Environments.url, Environments.getUser);
    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(credentials));

      if (response.statusCode == 200) {
        final decoded = await json.decode(response.body);
        User user = User.fromJson(decoded["user"]);
        var token = decoded["token"];
        Map<String, dynamic> userData = {"user": user, "token": token};
        return userData;
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

  Future<Map<String, dynamic>> postIdOneSignal(
      String id, String idOneSignal, String token) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      HttpHeaders.authorizationHeader: token
    };
    var url = Uri.http(Environments.url, Environments.postIdOneSignal);
    try {
      Map<String, String> idOneSignalPost = {
        "id": id,
        "idOneSignal": idOneSignal,
      };
      final response = await http.post(url,
          headers: headers, body: jsonEncode(idOneSignalPost));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        return map;
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

  Future<Map<String, dynamic>> saveUser(User user, Person person) async {
    try {
      //SE ALMACENA LA DAT DE LA PERSONA Y USUARIO E UNA SOLA
      Map<String, String> userData = {
        "userName": user.userName,
        "email": user.email,
        "password": user.password,
        "userType": user.userType,
      };
      Map<String, dynamic> userPersonPost = {
        "user": userData,
        "person": person
      };

      var url = Uri.http(Environments.url, Environments.postUser);
      var request = http.MultipartRequest("POST", url);
      request.fields["user"] = jsonEncode(userData);
      //person.id = "";
      request.fields["person"] = jsonEncode(jsonDecode(personToJson(person)));

      request.files.add(await http.MultipartFile.fromPath(
          "image", person.urlImage.path,
          filename: "image_${person.urlImage.name}"));

      var response = await request.send();
      if (response.statusCode == 200) {
        Map<String, dynamic> map =
            jsonDecode(await response.stream.bytesToString());
        return map;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> postChangePassword(
      Map changePasswordData) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    };
    var url = Uri.http(Environments.url, Environments.postChangePassword);
    try {
      final response = await http.post(url,
          headers: headers, body: jsonEncode(changePasswordData));

      if (response.statusCode == 200) {
        final decoded = await json.decode(response.body);
        Map<String, dynamic> responseData = decoded;
        return responseData;
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

  Future<Map<String, dynamic>> postSendEmailChangePassword(
      Map changePasswordData) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    };
    var url = Uri.http(Environments.url, Environments.postChangePassword);
    try {
      final response = await http.post(url,
          headers: headers, body: jsonEncode(changePasswordData));

      if (response.statusCode == 200) {
        final decoded = await json.decode(response.body);
        Map<String, dynamic> responseData = decoded;
        return responseData;
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
