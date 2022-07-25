import 'dart:async';
import 'dart:convert';

import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
//import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../models/entities.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var serviceNotification = NotificationServices();

class _MyHomePageState extends State<MyHomePage> {
  User user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Future<void> initState() {
    super.initState();
    initPlatform(context);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color.fromRGBO(56, 56, 76, 1)),
          child: Stack(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 23),
                  child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                      icon: const Icon(Icons.menu, color: Colors.white)),
                ),
              ]),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Envio de alerta de Incidente",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white)),
                    InkWell(
                        splashColor: Colors.white,
                        onLongPress: () {
                          Timer(
                              Duration(seconds: 3), (_handleSendNotification));
                        },
                        child: const Image(
                          image: AssetImage("assets/image/sos.png"),
                          height: 230,
                        )),
                    const Text(
                      "Presione durante 3 segundos para enviar alerta",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text(user.email),
                accountName: Text(user.name),
                currentAccountPicture: GestureDetector(
                  child: Image.asset("assets/image/account.png"),
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/image/back_user.jpg"),
                        fit: BoxFit.fill)),
              ),
              ListTile(
                  title: const Text("Cerrar Sesión"),
                  trailing: const Icon(Icons.exit_to_app_rounded),
                  onTap: () => _cerrarSesion(context)),
              Divider(),
              ListTile(
                title: Text("Cancel"),
                trailing: Icon(Icons.cancel),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ));
  }

  void _handleSendNotification() async {
    try {
      //CORDENADAS DE DONDE OCURRE EL INCIDENTE PARA ENVIO DE NOTIFICACION PUSH
      Map<String, dynamic> cordinates = {
        "longitude": user.company.longitude,
        "latitude": user.company.latitude
      };

      //CREACION Y ENVIO DE NOTIFICACION PUSH A LOS USUASRIOS ACTIVOS
      var imgUrlString =
          "https://www.cloudways.com/blog/wp-content/uploads/MapPress-Easy-Google-Map-Plugin.jpg";
      var content = "Ha ocurrido un incidente en ${user.company.name}";
      var listPlayers = await getDevices(await getIdDevice());
      var notification = OSCreateNotification(
        additionalData: cordinates,
        playerIds: listPlayers,
        content: content,
        heading: "¡Alerta de Incidente!",
        iosAttachments: {"id1": imgUrlString},
        bigPicture: imgUrlString,
      );
      print(notification);
      //PETICIONES A PUSH NOTIFICATIONS Y NOTIFICACION A LA BASE DE DATOS
      await OneSignal.shared.postNotification(notification);
      await postNotificationBD();
      Vibration.vibrate(duration: 2000);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.successSnackBar);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
          'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
          'Error!'));
      print(e.message);
    }
  }

  Future<void> postNotificationBD() async {
    //CUERPO DE PETICION POST PARA GUARDAR LA NOTIFICACION EN LA BASE DE DATOS
    var sucursal = user.company.name;
    var contentNotificationPostServer = NotificationEntity(
        date: DateTime.now(),
        message: "Ha ocurrido un incidente en $sucursal",
        user: user.id);

    await serviceNotification
        .postNotfication(contentNotificationPostServer.toJson());
  }

  _cerrarSesion(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("email");
    preferences.remove("password");
    Navigator.of(context).pushReplacementNamed("/");
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.resetUser();
  }
}

Future<String> getIdDevice() async {
  var deviceState = await OneSignal.shared.getDeviceState();
  if (deviceState == null || deviceState.userId == null) return "";
  return deviceState.userId;
}

Future<List<String>> getDevices(playerId) async {
  List<String> listPlayers = List.empty(growable: true);

  var responsePlayers = await serviceNotification.getDevices();
  Map<String, dynamic> devices = json.decode(responsePlayers.body);
  var playersId = devices["players"];

  for (var i = 0; i < playersId.length; i++) {
    Map<String, dynamic> userEntry = playersId[i];
    if (!userEntry["invalid_identifier"]) {
      listPlayers.add(userEntry["id"].toString());
    }
  }
  listPlayers.remove(playerId);
  return listPlayers;
}

Future<void> initPlatform(context) async {
  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
    //OBTENER DATOS DESDE LA NOTIFICACION PUSH
    Map<String, dynamic> valueNotify = result.notification.additionalData;

    //OBTENER LA UBICACION EXACTA DEL USUASRIO PARA REDIRECCION EN GOOGLE MAPS
    //Location location = Location();

    //var ubication = await location.getLocation();
    var longitude = valueNotify["longitude"];
    var latitude = valueNotify["latitude"];

    if (await MapLauncher.isMapAvailable(MapType.google)) {
      MapLauncher.showDirections(
        mapType: MapType.google,
        destination: Coords(latitude, longitude),
        //origin: Coords(ubication.latitude, ubication.longitude)
      );
    }
  });

  var init =
      await OneSignal.shared.setAppId('9fd9a40d-8646-450c-bd3b-d661b0e8ee42');

  await OneSignal.shared
      .getDeviceState()
      .then((value) => {print(value?.userId)});
}

Future<bool> getLocation() async {
  Location location = Location();
  location.requestPermission().then((value) => print(value));

  if (await location.hasPermission() == PermissionStatus.granted) {
    return true;
  } else {
    return false;
  }
}
