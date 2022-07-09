import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/User.dart';
import '../WebServices/MethodsWebServices.dart';

Future<http.Response> sendNotifacationPushAllDevices(data) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    //"Content-type": "",
    "Authorization": "Basic YTQ1OThlOGQtZjc4Yi00MzExLWEyOTEtMTliYjZlYTdkMjhh",
  };
  var url =
      Uri.parse(Services.url + Services.postSendNotificationPushAllDevices);

  var response = await http.post(url, headers: headers, body: jsonEncode(data));
  print("resonse status:${response.statusCode}");
  print("resonse body:${response.body}");
  return response;
}

Future<http.Response> postNotification(data) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
  };
  var url = Uri.parse(Services.url + Services.postNotification);

  var response = await http.post(url, headers: headers, body: jsonEncode(data));
  print("resonse status:${response.statusCode}");
  print("resonse body:${response.body}");
  return response;
}

Future<MutableUser> getUser(email, password, parameters) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
  };
  var url = Uri.http(Services.url, Services.getUser, parameters);

  var response = await http.get(url, headers: headers);
  print("resonse status:${response.statusCode}");
  print("resonse body:${response.body}");
  var user = MutableUser();
  List<dynamic> values;
  List<dynamic> post;
  values = json.decode(response.body);

  Map<String, dynamic> userRespons = values[0];
  Map<String, dynamic> branch = userRespons["branch"];

  user.id = userRespons["_id"];
  user.email = userRespons["email"];
  user.password = userRespons["password"];
  user.user_type = userRespons["user_type"];
  user.idSucursal = branch["_id"];

  return user;
  //user.email = response.body.email.toString();

  // MutableUser(id=response.body._id, email=response.body.email, password=response.)
}
