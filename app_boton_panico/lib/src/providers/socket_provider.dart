import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider implements FlutterForegroundTask {
  IO.Socket _socket;

  void connect(User user) async {
    try {
      if (_socket != null && _socket.connected) {
        return;
      }
      _socket = IO.io("https://${Environments.url}", <String, dynamic>{
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

  void emitLocation(User user, String event, [dynamic data]) {
    connect(user);
    _socket.emit(event, data);
  }

  /// The function takes in two parameters, an event and a callback function. The event is a string that
  /// is used to identify the event. The callback function is a function that is called when the event is
  /// triggered
  ///
  /// Args:
  ///   event (String): The name of the event.
  ///   callback (Function): The function to be called when the event is triggered.
  void onLocation(String event, Function callback) {
    _socket.on(event, callback);
  }

  /// The function takes in two parameters, the first is the event name and the second is the callback
  /// function. The function then calls the on method of the socket object and passes in the event name
  /// and the callback function
  ///
  /// Args:
  ///   event (String): The name of the event to listen for.
  ///   callback (Function): The function to be called when the event is triggered.
  void onAlerts(String event, Function callback) {
    _socket.on(event, callback);
  }
}
