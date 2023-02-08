import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/alarm.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/models/user_alert.dart';
import 'package:app_boton_panico/src/providers/socket_provider.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/screens/alerts/alerts.dart';
import 'package:app_boton_panico/src/services/alerts_services.dart';
import 'package:app_boton_panico/src/services/family_group_services.dart';
import 'package:app_boton_panico/src/services/notification_services.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_boton_panico/src/methods/permissions.dart';
import 'package:vibration/vibration.dart';
import 'package:location/location.dart' as LC;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

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
  List<UserAlert> userAlerts;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<HardwareButton> subscription;
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  SocketProvider socketProvider;
  StreamSubscription<Position> _positionStream;
  final _formKey = GlobalKey<FormState>();
  AlertsServices serviceAlert = AlertsServices();
  String idAlarm;
  LC.Location location = LC.Location();
  StreamSubscription<LC.LocationData> locationSubscription;
  List<String> familyGroupIds;

  bool isSendLocation = false;

  String textButton = "Envío de alerta de Incidente";

  int count = 0;
  int countSocket = 0;

  @override
  void initState() {
    super.initState();
    userAlerts = [];
    familyGroupIds = [];
    initPlatform(context);
    Permissions.handleLocationPermission(context);
    user = Provider.of<UserProvider>(context, listen: false).userData["user"];
    token = Provider.of<UserProvider>(context, listen: false).userData["token"];
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    initSocket(user);
    getUsersAlerts(user.person.id);
    onAlerts(user.person.id);
    openStateUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = AppLayout.getSize(context);

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color.fromRGBO(56, 56, 76, 1)),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.04, left: 1, bottom: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Badge(
                            badgeContent: Text("$count"),
                            padding: const EdgeInsets.all(5.5),
                            animationType: BadgeAnimationType.slide,
                            child: const Icon(Icons.notification_important,
                                size: 27, color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          showBarModalBottomSheet(
                            context: context,
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) => Alerts(
                              personId: user.person.id,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState.openEndDrawer();
                        },
                        icon: const Icon(Icons.menu, color: Colors.white),
                      ),
                    ]),
              ),
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
                            Timer(const Duration(seconds: 3), (sendLocation));
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
                    Text("${user.person.firstName} ${user.person.lastName}"),
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
                currentAccountPicture: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ClipOval(
                    child: SizedBox(
                      child: CachedNetworkImage(
                        width: size.width * 0.9,
                        height: size.width * 0.07,
                        fit: BoxFit.cover,
                        imageUrl:
                            "http://${Environments.getImage}/${user.person.urlImage}",
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                      ),
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

  void initSocket(User user) async {
    socketProvider.connect(user);
  }

  void onAlerts(personId) {
    socketProvider.onAlerts("${Environments.event}-$personId", (_) {
      getUsersAlerts(personId);
    });
  }

  void getUsersAlerts(String personId) async {
    List<UserAlert> users = await serviceAlert.getUsersAlertsByPerson(personId);
    if (mounted) {
      setState(() {
        userAlerts = users;
        count =
            userAlerts.where((userAlert) => userAlert.state == "danger").length;
      });
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await Permissions.handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      log(_currentPosition.latitude.toString());
    }).catchError((e) {
      print(e);
    });
  }

  void sendLocation() async {
    try {
      await _getLivePosition();
      Vibration.vibrate(duration: 1000);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.successSnackBar);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
          'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
          'Error!'));
    }
  }

  Future<void> _getLivePosition() async {
    try {
      final hasPermission = await Permissions.handleLocationPermission(context);
      if (!hasPermission) return;

      await _getCurrentPosition();

      setState(() {
        isSendLocation = true;
        textButton = "Se esta enviando tu ubicación...";
      });
      UserServices serviceUser = UserServices();
      await serviceUser.putStateByUser(user.id, "danger");
      await postAlarmBD(_currentPosition.latitude, _currentPosition.longitude);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("state", "danger");
      await serviceNotification.sendNotificationFamilyGroup(user.id);
      startListening();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error de envio'),
      ));
    }
  }

  void openStateUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String state = preferences.getString("state");
    if (state == "danger") {
      setState(() {
        isSendLocation = true;
        textButton = "Se esta enviando tu ubicación...";
      });
    } else {
      setState(() {
        isSendLocation = false;
        textButton = "Envío de alerta de Incidente";
      });
    }
  }

  void getfamilyGruop() async {
    FamilyGroupServices familyGroupServices = FamilyGroupServices();
    List<User> users = await familyGroupServices.getfamilyGropuByUser(user.id);

    setState(() {
      users.forEach((user) {
        familyGroupIds.add(user.person.id);
      });
    });
  }

  void startListening() {
    getfamilyGruop();
    location.enableBackgroundMode(enable: true);
/* location.changeNotificationOptions(
          channelName: "channel",
          subtitle: "sub",
          description: "desc",
          title: "title",
          color: Colors.red); */
    locationSubscription =
        location.onLocationChanged.listen((LC.LocationData position) {
      log('${position.latitude}, ${position.longitude}');

      Map data = {
        "position": {"lat": position.latitude, "lng": position.longitude},
        "familyGroup": familyGroupIds
      };

      socketProvider.emitLocation("send-alarm", jsonEncode(data));
    });
  }

  Future<Position> _getLastKnownPosition() async {
    final position = await Geolocator.getLastKnownPosition();
    if (position != null) {
      return position;
    } else {
      return null;
    }
  }

  void cancelSendLocation() async {
    try {
      await locationSubscription.cancel();
      UserServices serviceUser = UserServices();
      await serviceUser.putStateByUser(user.id, "ok");
      Position lastPosition = await _getLastKnownPosition();
      bool isCancel = await putAlarmBD(idAlarm, "cancelada",
          lastPosition.latitude, lastPosition.longitude, true);
      Vibration.vibrate(duration: 100);
      if (isCancel) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("state", "ok");
        setState(() {
          isSendLocation = false;
          textButton = "Envío de alerta de Incidente";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No se pudo cancelar, Intente de nuevo'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
          'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
          'Error!'));
    }
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

  /// It sends a POST request to the server to save the notification in the database.
  Future<String> postAlarmBD(double lat, double lng) async {
    //CUERPO DE PETICION POST PARA GUARDAR LA NOTIFICACION EN LA BASE DE DATOS
    try {
      var contentAlertPostServer = Alarm(
          person: user.person.id,
          state: "en progreso",
          latitude: lat,
          longitude: lng);

      var id = await serviceNotification.postAlarm(contentAlertPostServer);
      setState(() {
        idAlarm = jsonDecode(id);
      });
      if (id != null) {
        return id;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> putAlarmBD(
      String idAlarm, String state, double lat, double lng, bool isLast) async {
    try {
      Map contentAlertPostServer = {
        "id": idAlarm,
        "person": user.person.id,
        "state": state,
        "latitude": lat,
        "longitude": lng,
        "isLast": isLast,
      };
      return await serviceNotification.putAlarm(contentAlertPostServer);
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  /// _logOut() is a function that removes the user and token from the shared preferences and navigates to
  /// the login page
  ///
  /// Args:
  ///   context: The context of the current widget.
  void _logOut(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("user");
    preferences.remove("token");
    Navigator.of(context).pushReplacementNamed("/");
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.resetUser();
  }

  Future<void> setIdOneSignal(String idOS) async {
    UserServices userServices = UserServices();
    if (user.idOneSignal == null || (user.idOneSignal != idOS)) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      Map idOne = await userServices.postIdOneSignal(user.id, idOS, token);
      user.idOneSignal = idOne["idOneSignal"];
      var userString = jsonDecode(jsonEncode(userToJson(user)));
      preferences.setString("user", userString);
      return;
    }
  }

  /// If the user clicks on a notification, the app will open and the function will be called. The
  /// function will then get the additional data from the notification and use it to open Google Maps with
  /// the destination coordinates
  ///
  /// Args:
  ///   context: The context of the widget that is calling the method.
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
    await dotenv.load(fileName: ".env");

    ///SUBSCRIPCION A ONE SIGNAL PARA RECIBIR Y ENVIAR TANTO SMS Y NOTIFICACIONES
    await OneSignal.shared.setAppId(dotenv.env['API_ONE_SIGNAL']);
    await OneSignal.shared.getDeviceState().then((value) {
      print(value.userId);
      setIdOneSignal(value.userId);
      //setSmsNumber(value.smsNumber);
    });
  }

  /// _changePassword() is a function that takes a context as a parameter and returns a Future
  ///
  /// Args:
  ///   context: BuildContext
  ///
  /// Returns:
  ///   A Map with a message and a status.
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

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.simpleSnackbar(
          "${response["message"]}", Icons.lock_reset_rounded, Styles.green));
    }
  }
}
