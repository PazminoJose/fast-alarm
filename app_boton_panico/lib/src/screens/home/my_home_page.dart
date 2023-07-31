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
import 'package:app_boton_panico/src/screens/coreTrust/family_group_page.dart';
import 'package:app_boton_panico/src/screens/home/components/permision_dialog.dart';
import 'package:app_boton_panico/src/services/alerts_services.dart';
import 'package:app_boton_panico/src/services/family_group_services.dart';
import 'package:app_boton_panico/src/services/notification_services.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:badges/badges.dart' as BG;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.Dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_boton_panico/src/methods/permissions.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:vibration/vibration.dart';
import 'package:location/location.dart' as LC;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String idOneSignal;
NotificationServices serviceNotification = NotificationServices();

class _MyHomePageState extends State<MyHomePage> {
  int pressVolumeId;
  User user;

  String token;
  String _currentAddress;
  Position _currentPosition;
  List<UserAlert> userAlerts;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _inkWellKey = GlobalKey();
  StreamSubscription<HardwareButton> subscription;
  String password = "";
  String passwordConfirm = "";
  SocketProvider socketProvider;
  final _formKey = GlobalKey<FormState>();
  AlertsServices serviceAlert = AlertsServices();
  String idAlarm;
  LC.Location location = LC.Location();
  StreamSubscription<LC.LocationData> locationSubscription;
  List<String> familyGroupIds;
  bool isSendLocation = false;
  bool isProcessSendLocation = false;
  bool isProcessFinalizeLocation = false;
  Key _key;
  String textButton = "Envío de alerta de Incidente";

  int count = 0;
  int countSocket = 0;

  @override
  void initState() {
    super.initState();
    userAlerts = [];
    familyGroupIds = [];
    initPlatform();
    user = Provider.of<UserProvider>(context, listen: false).userData["user"];
    token = Provider.of<UserProvider>(context, listen: false).userData["token"];
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    initSocket(user);
    getUsersAlerts(user.person.id);
    onAlerts(user.person.id);
    openStateUser();
    _openPermisionLocations();
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
                        key: _inkWellKey,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: BG.Badge(
                            badgeContent: Text("$count"),
                            padding: const EdgeInsets.all(5.5),
                            animationType: BG.BadgeAnimationType.slide,
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
                      (!isProcessSendLocation)
                          ? RawGestureDetector(
                              gestures: <Type, GestureRecognizerFactory>{
                                LongPressGestureRecognizer:
                                    GestureRecognizerFactoryWithHandlers<
                                        LongPressGestureRecognizer>(
                                  () => LongPressGestureRecognizer(
                                    debugOwner: this,
                                    duration: const Duration(seconds: 2),
                                  ),
                                  (LongPressGestureRecognizer instance) {
                                    instance.onLongPress = () {
                                      Vibration.vibrate(duration: 50);
                                      setState(() {
                                        isProcessSendLocation = true;
                                      });
                                      sendLocation(true);
                                    };
                                  },
                                ),
                              },
                              child: Image(
                                image: const AssetImage("assets/image/sos.png"),
                                height: (size.width * 0.6),
                              ),
                            )
                          : RippleAnimation(
                              key: _key,
                              repeat: true,
                              color: Styles.redText,
                              minRadius: 140,
                              ripplesCount: 8,
                              child: Image(
                                image:
                                    const AssetImage("assets/image/alert.gif"),
                                height: (size.width * 0.6),
                              ),
                            ),
                      const Text(
                        "Presione durante 3 segundos para enviar alerta",
                        style: TextStyle(color: Colors.white),
                      )
                    ] else ...[
                      Center(
                        child: (!isProcessFinalizeLocation)
                            ? Column(
                                children: [
                                 /*  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Styles.redText,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: size.height * 0.1),
                                      ),
                                      child: const Text("Cancelar"),
                                      onPressed: () {}), */
                                  const Gap(30),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipOval(
                                        child: Material(
                                          elevation: 20,
                                          child: Container(
                                            color: Colors.grey[350],
                                            child: SizedBox(
                                              width: size.width * 0.57,
                                              height: size.width * 0.57,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClipOval(
                                        child: Material(
                                            color: Styles.green, // Button color
                                            child: RawGestureDetector(
                                              gestures: <Type,
                                                  GestureRecognizerFactory>{
                                                LongPressGestureRecognizer:
                                                    GestureRecognizerFactoryWithHandlers<
                                                        LongPressGestureRecognizer>(
                                                  () =>
                                                      LongPressGestureRecognizer(
                                                    debugOwner: this,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ),
                                                  (LongPressGestureRecognizer
                                                      instance) {
                                                    instance.onLongPress = () {
                                                      Vibration.vibrate(
                                                          duration: 50);
                                                      setState(() {
                                                        isProcessFinalizeLocation =
                                                            true;
                                                      });
                                                      (cancelSendLocation());
                                                    };
                                                  },
                                                ),
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
                                                      size: (size.width * 0.2),
                                                    ),
                                                    Text(
                                                      "¡Ya Estoy Seguro!",
                                                      style: Styles
                                                          .textStyleTitle
                                                          .copyWith(
                                                              fontSize: 17),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : Lottie.asset(
                                'assets/lottie/chargeIsSecurity.json',
                                width: size.width * 0.8,
                                height: size.height * 0.35,
                              ),
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
                accountName: Text(
                    "${user.person.firstName}${user.person.middleName}${user.person.lastName}"),
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
                            "https://${Environments.getImage}/${user.person.urlImage}",
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error_outline),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
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
                            title: const Text("Núcleo de Confianza"),
                            trailing: const Icon(Icons.family_restroom),
                            onTap: () => showBarModalBottomSheet(
                                  context: context,
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (context) => FamilyGroup(
                                    userId: user.id,
                                  ),
                                )),
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
          bool passwordVisible = false;
          final Size size = AppLayout.getSize(context);

          return StatefulBuilder(
            builder: (context, setState) {
              String buttonTextAceptar = "Aceptar";
              var _loading = false;
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: (size.width * 0.15)),
                  decoration: BoxDecoration(
                      color: Styles.primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Center(
                    child: Text(
                      'Cambiar Contraseña',
                      style: Styles.textStyleBody,
                    ),
                  ),
                ),
                titlePadding: const EdgeInsets.all(0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15),
                                  FilteringTextInputFormatter.deny(
                                      Styles.exprWithoutWhitspace),
                                ],
                                textInputAction: TextInputAction.next,
                                obscureText: !passwordVisible,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_person),
                                  label: Text("Contraseña nueva"),
                                ),
                                onSaved: (value) => {password = value},
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return "Ingrese su contraseña";
                                  }
                                  password = value;
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                    FilteringTextInputFormatter.deny(
                                        Styles.exprWithoutWhitspace),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  obscureText: !passwordVisible,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock_person),
                                    label: Text("Confirmar contraseña"),
                                  ),
                                  onSaved: (value) => {passwordConfirm = value},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su contraseña";
                                    }
                                    if (!(password == value)) {
                                      return "Las contraseñas no coinciden";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Mostrar Contraseña"),
                        Checkbox(
                            value: passwordVisible,
                            onChanged: (value) {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            }),
                      ],
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Text("Cancelar"),
                          onPressed: (() {
                            Navigator.of(context).pop();
                          }),
                        ),
                        ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(buttonTextAceptar),
                              if (_loading)
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                  ),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                            ],
                          ),
                          onPressed: () async {
                            setState(() {
                              textButton = "Cambiando";
                              _loading = true;
                            });
                            bool isChangePassword =
                                await _changePassword(context);
                            if (isChangePassword) {
                              setState(() {
                                textButton = "Aceptar";
                                _loading = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        });
  }

  Future<void> _openPermisionLocations() async {
    bool isPermisionEnable = await Permissions.checkPermision(context);

    if (!isPermisionEnable) {
      SchedulerBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          builder: ((context) {
            return PermisionLocation();
          })));
    }
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
    }).catchError((e) {
      print(e);
    });
  }

  void sendLocation(bool isNewAlarm) async {
    try {
      bool isSendPosition = await _getLivePosition(isNewAlarm);
      if (isSendPosition) {
        setState(() {
          isProcessSendLocation = false;
          isSendLocation = true;
          textButton = "Se esta enviando tu ubicación...";
        });
        Vibration.vibrate(duration: 1000);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(MySnackBars.successSnackBar);
        await serviceNotification.sendNotificationFamilyGroup(
            user.id, "${user.person.firstName} ${user.person.lastName}");
      } else {
        setState(() {
          isProcessSendLocation = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.errorConectionSnackBar());
      setState(() {
        isProcessSendLocation = false;
      });
    }
  }

  Future<bool> _getLivePosition(bool isNewAlarm) async {
    try {
      bool hasPermission = false;

      if (mounted) {
        hasPermission = await Permissions.checkPermision(context);
      }

      if (hasPermission) {
        UserServices serviceUser = UserServices();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (isNewAlarm) {
          await _getCurrentPosition();
          await postAlarmBD(
              _currentPosition.latitude, _currentPosition.longitude);
          preferences.setString("idAlarm", idAlarm);
          await serviceUser.putStateByUser(user.id, "danger");
        }
        getFamilyGroup(isNewAlarm);
        preferences.setString("state", "danger");
        startListeningPosition();
        return true;
      } else {
        _openPermisionLocations();
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.errorConectionSnackBar());
      Vibration.vibrate(duration: 200);
      setState(() {
        isProcessSendLocation = false;
      });

      return false;
    }
  }

  void openStateUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String state = preferences.getString("state");
    if (state == "danger") {
      sendLocation(false);
    } else {
      setState(() {
        isSendLocation = false;
        textButton = "Envío de alerta de Incidente";
      });
    }
  }

  void getFamilyGroup(bool isNewAlert) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FamilyGroupServices familyGroupServices = FamilyGroupServices();
    List<User> users = await familyGroupServices.getfamilyGropuByUser(user.id);
    if (isNewAlert) {
      setState(() {
        familyGroupIds.clear();
        users.forEach((user) {
          familyGroupIds.add(user.person.id);
        });
      });
      preferences.setString("familyGroupIds", jsonEncode(familyGroupIds));
    } else {
      setState(() {
        familyGroupIds.clear();
        String codeList = preferences.getString("familyGroupIds");
        familyGroupIds = jsonDecode(codeList).cast<String>();
      });
    }
  }

  void startListeningPosition() {
    location.enableBackgroundMode(enable: true);
    location.changeNotificationOptions(
        channelName: "channel",
        subtitle: "Se esta enviando tu ubicación a tu núcleo de confianza.",
        description: "desc",
        title: "Vivo Vivo está accediendo a su ubicación",
        color: Colors.red);
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
      log('${position.latitude}  ${position.longitude}');
      return position;
    } else {
      return null;
    }
  }

  void cancelSendLocation() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      UserServices serviceUser = UserServices();
      Position lastPosition = await _getLastKnownPosition();
      String id = preferences.getString("idAlarm");

      bool isCancel = await putAlarmBD(
          id, "cancelada", lastPosition.latitude, lastPosition.longitude, true);
      if (isCancel) {
        await serviceUser.putStateByUser(user.id, "ok");
        await locationSubscription.cancel();
        location.enableBackgroundMode(enable: false);
        preferences.setString("state", "ok");
        preferences.remove("idAlarm");
        preferences.remove("familyGroupIds");
        setState(() {
          isProcessFinalizeLocation = false;
          isSendLocation = false;
          textButton = "Envío de alerta de Incidente";
        });
        Vibration.vibrate(duration: 100);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No se pudo cancelar, Intente de nuevo'),
        ));
        setState(() {
          isProcessFinalizeLocation = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.errorConectionSnackBar());
      setState(() {
        isProcessFinalizeLocation = false;
      });
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
          longitude: lng,
          type: "phone");

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
        "finalLatitude": lat,
        "finalLongitude": lng,
      };
      return await serviceNotification.putAlarm(contentAlertPostServer);
    } catch (e) {
      print(e.toString());
      return false;
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
  Future<void> initPlatform() async {
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {});
    await dotenv.load(fileName: ".env");

    ///SUBSCRIPCION A ONE SIGNAL PARA RECIBIR Y ENVIAR TANTO SMS Y NOTIFICACIONES
    await OneSignal.shared.setAppId(dotenv.env['API_ONE_SIGNAL']);

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      //  print(changes.to.userId);
      String userId = changes.to.userId ?? '';
      if (userId != '') {
        log(userId);
        setIdOneSignal(userId);
      }
    });
  }

  Future<bool> _changePassword(context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Map<String, String> changePasswordData = {
        "userId": user.id,
        "password": password,
      };
      UserServices userServices = UserServices();
      Map response = await userServices.postChangePassword(changePasswordData);
      if (response == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(MySnackBars.errorConectionSnackBar());

        return false;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.simpleSnackbar(
          "${response["message"]}", Icons.lock_reset_rounded, Styles.green));
      _scaffoldKey.currentState.closeEndDrawer();
      return true;
    }
    return false;
  }
}
