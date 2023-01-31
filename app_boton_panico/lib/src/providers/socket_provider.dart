import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider {
  IO.Socket _socket;
  void connect(User user) async {
    try {
      if (_socket != null && _socket.connected) {
        return;
      }
      _socket = IO.io("http://${Environments.url}", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'query': {"personId": user.person.id}
      });

      _socket.connect();
      _socket.onConnect((data) => {print("Connectado. ${_socket.id}")});
    } catch (e) {
      print(e);
    }
  }

  void disconnect() {
    _socket.disconnect();
  }

  void emitLocation(String event, [dynamic data]) {
    _socket.emit(event, data);
  }

  void onLocation(String event, Function callback) {
    _socket.on(event, callback);
  }

  void onAlerts(String event, Function callback) {
    _socket.on(event, callback);
  }
}
