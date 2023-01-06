import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/models/alarm.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/screens/alerts.dart';
import 'package:app_boton_panico/src/services/notification_services.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initPlatform(context);
    _handleLocationPermission(context);
    //TODO:Pobar botonews de volumen, cancel de subscripcion
    //startListening();
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
    //setIdOneSignal();

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
                  padding: const EdgeInsets.only(top: 23),
                  child: IconButton(
                    onPressed: () {
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
                    icon: const Icon(Icons.notification_important,
                        color: Colors.white),
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
                    const Text("Envío de alerta de Incidente",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white)),
                    InkWell(
                        splashColor: Colors.white,
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
                currentAccountPicture: GestureDetector(
                  child: Image.asset("assets/image/account.png"),
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
                            title: const Text("Cambiar Contraseña"),
                            trailing: const Icon(Icons.lock_open_rounded),
                            onTap: () => _openFormChangePassword(context)),
                        const Divider(
                          height: 20,
                        ),
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

  Future<bool> _handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Los servicos de localización estan deshabilitados, Por favor habilite lo servicios')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Permisos de loxalización han sido denegados.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Los permisos de localización están permanentemente denegados, no podemos solicitar permisos.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
    }).catchError((e) {
      print(e);
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
      await _getCurrentPosition();
      //Obtener direccion excata del usuario
      await _getAddressFromLatLng(_currentPosition);
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
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.successSnackBar);
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
