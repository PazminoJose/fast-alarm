/* import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/User.dart';
import '../services/MethodsWebServices.dart';

Future<http.Response> sendNotifacationPushAllDevices(data) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    //"Content-type": "",
    "Authorization": "Basic YTQ1OThlOGQtZjc4Yi00MzExLWEyOTEtMTliYjZlYTdkMjhh",
  };

  var url = Uri.http(Services.url, Services.postSendNotificationPushAllDevices);

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

//mETODO GET PARA OBTENER AL USUARIO QUE SE LE LOGEA
Future<MutableUser> getUser(credentails) async {
  Map<String, dynamic> valueResponse;
  var user = MutableUser();
  var company = MutableCompany();

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
  };

  var url = Uri.http(Services.url, Services.getUser);

  var response =
      await http.post(url, headers: headers, body: jsonEncode(credentails));
  print("resonse status:${response.statusCode}");

  if (response.statusCode == 200) {
    valueResponse = json.decode(response.body);

    Map<String, dynamic> userRespons = valueResponse;
    Map<String, dynamic> companyRespons = userRespons["company"];

    //SE SETEA LOS ATRIBUTOS DE LA SUCURSAL DEL USUARIO QUE ESTA INGRESANDO
    company.id = companyRespons["_id"];
    company.name = companyRespons["name"];
    company.address = companyRespons["address"];
    company.contact = companyRespons["contact"];
    company.latitude = companyRespons["latitude"];
    company.longitude = companyRespons["longitude"];

    //SE SETEA LOS ATRIBUTOS DEL USUARIO QUE ESTA INGRESANDO Y SU RESPECTIVA SUCURSAL
    user.id = userRespons["_id"];
    user.company = company;
    user.email = userRespons["email"];
    user.password = userRespons["password"];
    user.user_type = userRespons["user_type"];
    user.name = userRespons["name"];
    user.surname = userRespons["surname"];
    return user;
  } else {
    return null;
  }
}
 */