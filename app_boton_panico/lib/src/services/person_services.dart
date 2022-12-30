import 'dart:convert';
import 'dart:io';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/failure.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:http/http.dart' as http;

class PersonServices {
  Future<Person> postPerson(Person person) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    };
    var url = Uri.http(Environments.url, Environments.postPerson);
    try {
      final response =
          await http.post(url, headers: headers, body: personToJson(person));
      if (response.statusCode == 200) {
        var decoded = await json.decode(json.encode(response.body.toString()));
        person = personFromJson(decoded);
        return person;
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
