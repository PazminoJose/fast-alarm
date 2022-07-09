import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
/* import 'package:sky_engine/_http/http.dart' as http; */
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NodeJS - OneSignal"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _sendNotifacationAllDevices();
        },
        child: const Icon(Icons.navigation),
      ),
    );
  }

  Future<void> initPlatform() async {
    await OneSignal.shared.setAppId('9fd9a40d-8646-450c-bd3b-d661b0e8ee42');
    await OneSignal.shared
        .getDeviceState()
        .then((value) => {print(value?.userId)});
  }

  Future<http.Response> _sendNotifacationAllDevices() async {
    Map<String, dynamic> data = {
      "longuitud": "1234",
      "altitud": "5678",
      "sucursal": "sucursal1"
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      //"Content-type": "",
      "Authorization": "Basic YTQ1OThlOGQtZjc4Yi00MzExLWEyOTEtMTliYjZlYTdkMjhh",
    };
    var url =
        Uri.parse('http://192.168.100.160:4000/api/SendNotificationAllDevices');

    var response =
        await http.post(url, headers: headers, body: jsonEncode(data));
    print("resonse status:${response.statusCode}");
    print("resonse body:${response.body}");
  }
}

class HomePageArguments {
  String id;
  String idSucursal;
  String correo;
  String contrasenia;
  String tipoUSuario;
  HomePageArguments(
      {this.id,
      this.idSucursal,
      this.correo,
      this.contrasenia,
      this.tipoUSuario});
}
