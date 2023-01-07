import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/alarm.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/screens/alerts.dart';
import 'package:app_boton_panico/src/services/notification_services.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:app_boton_panico/src/methods/permissions.dart';
import 'package:vibration/vibration.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String idOneSignal;
var serviceNotification = NotificationServices();

class _MyHomePageState extends State<MyHomePage> {
  int pressVolumeId;
  User user;
  String token;
  String _currentAddress;
  Position _currentPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<HardwareButton> subscription;
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  IO.Socket socket;
  StreamSubscription<Position> _positionStream;
  final _formKey = GlobalKey<FormState>();

  bool isSendLocation = false;

  String textButton = "Envío de alerta de Incidente";

  int count = 0;

  @override
  void initState() {
    super.initState();
    initPlatform(context);
    Permissions.handleLocationPermission(context);
    initSocket();

    //TODO:Pobar botonews de volumen, cancel de subscripcion
    //startListening();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket.disconnect();
    super.dispose();
  }

  void startListening() {
    subscription = FlutterAndroidVolumeKeydown.stream.listen((event) {
      if (event == HardwareButton.volume_down) {
        print("Volume down received");
      } else if (event == HardwareButton.volume_up) {
        print("Volume up received");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).userData["user"];
    token = Provider.of<UserProvider>(context).userData["token"];
    final Size size = AppLayout.getSize(context);
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color.fromRGBO(56, 56, 76, 1)),
          child: Stack(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 23, left: 10),
                  child: Badge(
                    badgeContent: Text("$count"),
                    padding: EdgeInsets.all(5.5),
                    animationType: BadgeAnimationType.slide,
                    child: InkWell(
                      child: Icon(Icons.notification_important,
                          size: 27, color: Colors.white),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (context) => Alerts(
                            user: user.id,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 23),
                    child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                      icon: const Icon(Icons.menu, color: Colors.white),
                    )),
              ]),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(textButton, style: Styles.textStyleBody),
                    if (!isSendLocation) ...[
                      InkWell(
                          splashColor: Colors.yellow,
                          onLongPress: () {
                            Timer(const Duration(seconds: 3),
                                (_handleSendNotification));
                          },
                          child: const Image(
                            image: AssetImage("assets/image/sos.png"),
                            height: 230,
                          )),
                      const Text(
                        "Presione durante 3 segundos para enviar alerta",
                        style: TextStyle(color: Colors.white),
                      )
                    ] else ...[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: Material(
                              elevation: 20,
                              child: Container(
                                color: Colors.grey[350],
                                child: SizedBox(
                                  width: size.width * 0.59,
                                  height: size.width * 0.59,
                                ),
                              ),
                            ),
                          ),
                          ClipOval(
                            child: Material(
                              color: Colors.green, // Button color
                              child: InkWell(
                                splashColor: Colors.white, // Splash color
                                onLongPress: () {
                                  Timer(const Duration(seconds: 3),
                                      (cancelSendLocation));
                                },
                                child: SizedBox(
                                    width: size.width * 0.55,
                                    height: size.width * 0.55,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_rounded,
                                          size: 80,
                                        ),
                                        Text(
                                          "¡Ya Estoy Seguro!",
                                          style: Styles.textStyleTitle,
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "Presione durante 3 segundos para terminar alerta",
                        style: TextStyle(color: Colors.white),
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
        endDrawer: Drawer(
          width: 270,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName:
                    Text("${user.person.firstName} ${user.person.middleName}"),
                accountEmail: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(user.email),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(user.person.phone),
                        ],
                      ),
                    ),
                  ],
                ),
                currentAccountPicture: ClipOval(
                  child: SizedBox(
                    child: CachedNetworkImage(
                      width: size.width * 0.9,
                      height: size.width * 0.07,
                      fit: BoxFit.cover,
                      imageUrl:
                          "https://www.afondochile.cl/site/wp-content/uploads/2018/06/jose-vaisman-e1529942487664.jpg",
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error_outline),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/image/back_user.jpg"),
                        fit: BoxFit.fill)),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        ListTile(
                            title: const Text("Nucleo de Confianza"),
                            trailing: const Icon(Icons.family_restroom),
                            onTap: () => _openFormChangePassword(context)),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                            title: const Text("Cambiar Contraseña"),
                            trailing: const Icon(Icons.lock_rounded),
                            onTap: () => _openFormChangePassword(context)),
                      ],
                    ),
                    Column(
                      children: [
                        ListTile(
                          title: const Text("Cancel"),
                          trailing: const Icon(Icons.cancel),
                          onTap: () => Navigator.pop(context),
                        ),
                        const Divider(),
                        ListTile(
                            title: const Text("Cerrar Sesión"),
                            trailing: const Icon(Icons.exit_to_app_rounded),
                            onTap: () => _logOut(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _getLivePosition() async {
    final hasPermission = await Permissions.handleLocationPermission(context);
    if (!hasPermission) return;
    LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
    setState(() {
      isSendLocation = true;
      textButton = "Se esta enviando tu ubicación...";
    });
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((position) {
      if (position == null) {
        return;
      } else {
        log('${position.latitude}, ${position.longitude}');
        Map coords = {"lat": position.latitude, "lng": position.longitude};
        socket.emit('position-change', jsonEncode(coords));
      }
    });
    /* await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
    }).catchError((e) {
      print(e);
    }); */
  }

  void cancelSendLocation() async {
    log("message");

    await _positionStream.cancel();
    setState(() {
      isSendLocation = false;
      textButton = "Envío de alerta de Incidente";
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress =
          '${place.subLocality}, ${place.subAdministrativeArea}, ${place.street}';
    }).catchError((e) {
      print(e);
    });
  }

  void _handleSendNotification() async {
    try {
      //CORDENADAS DE DONDE OCURRE EL INCIDENTE PARA ENVIO DE NOTIFICACION PUSH
      await _getLivePosition();
      //Obtener direccion excata del usuario
      /*  await _getAddressFromLatLng(_currentPosition);
      print(_currentAddress);
      Map<String, dynamic> cordinates = {
        "longitude": _currentPosition.longitude,
        "latitude": _currentPosition.latitude
      };

      //CREACION Y ENVIO DE NOTIFICACION PUSH A LOS USUASRIOS ACTIVOS
      var imgUrlString =
          "https://www.cloudways.com/blog/wp-content/uploads/MapPress-Easy-Google-Map-Plugin.jpg";
      var content = "Incidente en $_currentAddress";
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
      Vibration.vibrate(duration: 1000);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.successSnackBar); */
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
          'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
          'Error!'));
    }
  }

  Future<void> postNotificationBD() async {
    //CUERPO DE PETICION POST PARA GUARDAR LA NOTIFICACION EN LA BASE DE DATOS
    var contentAlertPostServer = Alarm(
        user: user.id,
        message: "Incidente en $_currentAddress",
        state: "active",
        latitude: _currentPosition.latitude,
        longitude: _currentPosition.longitude);

    await serviceNotification.postNotfication(contentAlertPostServer);
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io("http://${Environments.url}", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      log(socket.io.uri);
      socket.connect();
      socket.onConnect((data) => {print("Connectado. ${socket.id}")});
    } catch (e) {
      log(e);
    }
  }

  void _logOut(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("user");
    preferences.remove("token");
    Navigator.of(context).pushReplacementNamed("/");
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.resetUser();
  }

  void _logOutChangePassword(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("user");
    preferences.remove("token");
  }

  Future<void> setIdOneSignal() async {
    UserServices userServices = UserServices();
    if (user.idOneSignal == null || (user.idOneSignal != idOneSignal)) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      Map idOne =
          await userServices.postIdOneSignal(user.id, idOneSignal, token);
      user.idOneSignal = idOne["idOneSignal"];
      var userString = jsonDecode(jsonEncode(userToJson(user)));
      preferences.setString("user", userString);
    } else {
      return;
    }
  }

  Future _openFormChangePassword(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Cambiar Contraseña",
                              style: Styles.textLabel.copyWith(
                                  color: Styles.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15),
                                  FilteringTextInputFormatter.deny(
                                      Styles.exprWithoutWhitspace),
                                ],
                                controller: password,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_person),
                                  label: Text("Contraseña"),
                                ),
                                onSaved: (value) => {password.text = value},
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return "Ingrese su contraseña";
                                  }
                                  password.text = value;
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15),
                                  FilteringTextInputFormatter.deny(
                                      Styles.exprWithoutWhitspace),
                                ],
                                controller: passwordConfirm,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_person),
                                  label: Text("Confirmar contraseña"),
                                ),
                                onSaved: (value) =>
                                    {passwordConfirm.text = value},
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return "Ingrese su contraseña";
                                  }
                                  if (!(password.text == value)) {
                                    return "Las contraseñas no coinciden";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Styles.secondaryColor),
                                    child: Text("Cancelar"),
                                    onPressed: (() {
                                      Navigator.of(context).pop();
                                    }),
                                  ),
                                  ElevatedButton(
                                    child: Text("Aceptar"),
                                    onPressed: () => _changePassword(context),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> initPlatform(context) async {
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      //OBTENER DATOS DESDE LA NOTIFICACION PUSH
      Map<String, dynamic> valueNotify = result.notification.additionalData;
      //OBTENER LA UBICACION EXACTA DEL USUASRIO PARA REDIRECCION EN GOOGLE MAPS
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

    //SUBSCRIPCION A ONE SIGNAL PARA RECIBIR Y ENVIAR NOTIFICACIONES
    await OneSignal.shared.setAppId('9fd9a40d-8646-450c-bd3b-d661b0e8ee42');
    await OneSignal.shared
        .getDeviceState()
        .then((value) => {idOneSignal = value?.userId});
    var deviceState = await OneSignal.shared.getDeviceState();
    idOneSignal = deviceState.userId;

    setIdOneSignal();
  }

  void _changePassword(context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, String> changePasswordData = {
        "userId": user.id,
        "password": password.text,
      };
      UserServices userServices = UserServices();
      Map response = await userServices.postChangePassword(changePasswordData);
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
            'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
            'Error!'));
        return;
      }
      _scaffoldKey.currentState.closeEndDrawer();

      _logOutChangePassword(context);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.simpleSnackbar(
          "${response["message"]}", Icons.lock_reset_rounded, Styles.green));
    }
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
