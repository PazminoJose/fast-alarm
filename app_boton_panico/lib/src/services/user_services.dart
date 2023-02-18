import 'dart:convert';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/failure.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:http/http.dart' as http;

class UserServices {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
  };

  /// It takes a map of credentials, makes a post request to the server, and returns a map of user and
  /// token if the response is 200, otherwise it returns null
  ///
  /// Args:
  ///   credentials (Map): {"email": "email@email.com", "password": "password"}
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> getUser(Map credentials) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    };
    var url = Uri.https(Environments.url, Environments.getUser);
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

  /// It's a function that sends a POST request to the server with the user's id and the idOneSignal.
  ///
  /// Args:
  ///   id (String): The user's id
  ///   idOneSignal (String): The OneSignal user ID.
  ///   token (String): The token that you get from the login
  ///
  /// Returns:
  ///   A map of dynamic values.
  Future<Map<String, dynamic>> postIdOneSignal(
      String id, String idOneSignal, String token) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      HttpHeaders.authorizationHeader: token
    };
    var url = Uri.https(Environments.url, Environments.postIdOneSignal);
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
      var url = Uri.https(Environments.url, Environments.postUser);
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
      return null;
    }
  }

  Future<Map<String, dynamic>> postChangePassword(
      Map changePasswordData) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    };
    var url = Uri.https(Environments.url, Environments.postChangePassword);
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
    var url =
        Uri.https(Environments.url, Environments.postSendEmailChangePassword);
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

  Future<bool> putStateByUser(String userId, String state) async {
    var url =
        Uri.https(Environments.url, "${Environments.putStateByUser}/$userId");
    Map data = {"state": state};
    try {
      final response =
          await http.put(url, headers: headers, body: jsonEncode(data));

      if (response.statusCode == 200) {
        final decoded = await json.decode(response.body);
        var responseData = decoded["state"];
        return responseData;
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

  Future<Uint8List> getImageNetwork(String imgUrl) async {
    try {
      var url = Uri.https(
          Environments.url, "https://${Environments.getImage}/$imgUrl");
      var request = await http.get(url);
      var bytes = request.bodyBytes;
      return bytes;
    } catch (e) {
      ByteData imageData = await rootBundle.load("assets/image/user.png");
      Uint8List bytes = imageData.buffer.asUint8List();
      return bytes;
    }
  }
}
