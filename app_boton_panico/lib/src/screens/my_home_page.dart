import 'dart:async';
import 'dart:convert';

import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../models/entities.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User user;
  @override
  Future<void> initState() {
    super.initState();
    initPlatform();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Color.fromRGBO(56, 56, 76, 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Envio de alerta de Incidente ${user.name}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
            InkWell(
                splashColor: Colors.white,
                onLongPress: () {
                  Timer(Duration(seconds: 3), (_handleSendNotification));
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
      ),
    );
  }

  void _handleSendNotification() async {
    var deviceState = await OneSignal.shared.getDeviceState();
    var serviceNotification = NotificationServices();

    if (deviceState == null || deviceState.userId == null) return;
    var playerId = deviceState.userId;

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

    listPlayers.forEach((element) {
      print(element);
    });

    var sucursal = user.company.name;
    var contentNotificationPostServer = NotificationEntity(
        date: DateTime.now(),
        message: "Ha ocurrido un incidente en $sucursal",
        user: user.id);
    Map<String, dynamic> cordinates = {
      "longitude": user.company.longitude,
      "latitude": user.company.latitude
    };

    var imgUrlString =
        "https://www.cloudways.com/blog/wp-content/uploads/MapPress-Easy-Google-Map-Plugin.jpg";

    var content = "Ha ocurrido un incidente en $sucursal";
    var notification = OSCreateNotification(
      additionalData: cordinates,
      playerIds: listPlayers,
      content: content,
      heading: "¡Alerta de Incidente!",
      iosAttachments: {"id1": imgUrlString},
      bigPicture: imgUrlString,
    );
    print(notification);
    var response = await OneSignal.shared.postNotification(notification);

    var responsePostNotification = await serviceNotification
        .postNotfication(contentNotificationPostServer.toJson());
    print(response);
  }
}

Future<void> initPlatform() async {
  Location location = Location();
  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
    if (await location.hasPermission() != PermissionStatus.granted) {
      location.requestPermission().then((value) => print(value));
    } else {
      //OBTENER DATOS DESDE LA NOTIFICACION PUSH
      Map<String, dynamic> valueNotify = result.notification.additionalData;
      var devices = await OneSignal.shared.getTags();
      devices.forEach(
        (key, value) => {print("*********************+"), print(value)},
      );
      //OBTENER LA UBICACION EXACTA DEL USUASRIO PARA REDIRECCION EN GOOGLE MAPS
      //var ubication = await location.getLocation();

      var longitude = valueNotify["longitude"];
      var latitude = valueNotify["latitude"];
      if (await MapLauncher.isMapAvailable(MapType.google)) {
        MapLauncher.showDirections(
          mapType: MapType.google,
          destination: Coords(latitude,
              longitude), /* origin: Coords(ubication.latitude, ubication.longitude) */
        );
      }

      /* oneSignalInAppMessagingTriggerExamples() async {
      OneSignal.shared.addTrigger("catchNotifiy", "yesNotify");

      Object triggerValue =
          await OneSignal.shared.getTriggerValueForKey("catchNotifiy");
      print("'catchNotifiy' key trigger value: ${triggerValue?.toString()}");

      OneSignal.shared.pauseInAppMessages(false);
    } */
    }
  });

  OneSignal.shared
      .setInAppMessageClickedHandler((OSInAppMessageAction action) {});

  var init =
      await OneSignal.shared.setAppId('9fd9a40d-8646-450c-bd3b-d661b0e8ee42');

  await OneSignal.shared
      .getDeviceState()
      .then((value) => {print(value?.userId)});
}

class HomePageArguments {
  User user;

  HomePageArguments({this.user});
}
