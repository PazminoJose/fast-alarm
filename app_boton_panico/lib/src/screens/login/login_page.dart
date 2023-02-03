import 'dart:convert';

import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/providers/socket_provider.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:flutter/services.Dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  FToast fToast;
  var user;
  bool _loading = false;
  bool _isNotConncet;
  bool isSwitched = false;

  final email = TextEditingController();
  final password = TextEditingController();

  String userNameValue = "";
  String passwordValue = "";
  String textButtonSesion = "Iniciar Sesión";
  final formKey = GlobalKey<FormState>();
  var userProvider;

  @override
  void initState() {
    super.initState();
    _isNotConncet = true;
    openUserPreferences(context);
  }

  @override
  Widget build(BuildContext context) {
    var contextPushScreen = context;
    userProvider = Provider.of<UserProvider>(context, listen: false);

    // ignore: prefer_const_constructors
    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          //padding: const EdgeInsets.symmetric(vertical: 60),
          padding: const EdgeInsets.only(top: 60),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(0, 150, 136, 1),
              Color.fromRGBO(56, 56, 76, 1),
            ]),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                "assets/image/vivo_vivo_logo.png",
                height: 170,
              ),
            ),
          ],
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 220, bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(
                            "Bienvenido",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Column(children: [
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11),
                                FilteringTextInputFormatter.deny(
                                    Styles.exprWithoutWhitspace),
                              ],
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              controller: email,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                label: Text("Nombre de Usuario"),
                              ),
                              onSaved: (value) => {userNameValue = value},
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Ingrese su Nombre de Usuario";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(15),
                              ],
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              controller: password,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock_person),
                                label: Text("Contraseña"),
                              ),
                              onSaved: (value) => {passwordValue = value},
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Ingrese su contraseña";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(textButtonSesion),
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
                                onPressed: () {
                                  userNameValue = email.text;
                                  passwordValue = password.text;

                                  _showHomePage(
                                      context, userNameValue, passwordValue);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Guardar Sesión"),
                                const Padding(
                                    padding: EdgeInsets.only(right: 15)),
                                Checkbox(
                                    value: isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        isSwitched = value;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("¿Olvidó su contraseña?"),
                                TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed("/rememberPassword");
                                    },
                                    child: const Text(
                                      "Recuerdame",
                                      style: TextStyle(color: Colors.blue),
                                    ))
                              ],
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Styles.blur),
                              onPressed: () =>
                                  _showRegisterPage(contextPushScreen),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "Registrate!",
                                  style: TextStyle(
                                      color: Styles.white, fontSize: 16),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_isNotConncet)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(56, 56, 76, 1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
              ],
            ),
          ),
      ]),
    );
  }

  void _showRegisterPage(context) {
    Navigator.of(context).pushNamed("/register");
  }

  ///  _showHomePage() It is a function that verifies the user in the database and allows entry to the application.
  /// A function that receives a context, a user and a password and returns a future.
  ///
  /// Args:
  ///   context: The context of the current page.
  ///   usuario: The username of the user who is trying to log in.
  ///   password: The password of the user.
  void _showHomePage(context, usuario, password) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Map<String, dynamic> credentials = {
        "userName": usuario,
        "password": password
      };

      print(credentials);

      if (!_loading) {
        setState(() {
          _loading = true;
          textButtonSesion = "Iniciando";
        });
        try {
          var userData = await userProvider.getUser(credentials);
          if (userData != null) {
            user = userData["user"];
            var token = userData["token"];
            if (isSwitched) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              var userString = jsonDecode(jsonEncode(userToJson(user)));
              preferences.setString("user", userString);
              preferences.setString("token", token);
            }

            Navigator.of(context).pushReplacementNamed("/homePage");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
                'Usuario o Contraseña Incorrecta.\nPor favor intente de nuevo!',
                'Incorrecto!'));
            //_showToast("Usuario o Contraseña Incorrecta", "red", "error");
            setState(() {
              _loading = false;
              textButtonSesion = "Iniciar Sesión";
            });
          }
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
              'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
              'Error!'));
          setState(() {
            _loading = false;
            textButtonSesion = "Iniciar Sesión";
          });
        }
      }
    }
  }

  /// It open the user preferences to check if the user has saved their session and start without entering the credentials
  ///
  /// Args:
  ///   context: The context of the page you're calling this function from.
  Future<void> openUserPreferences(context) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      user = preferences.getString("user");
      var token = preferences.getString("token");
      //Map<String, dynamic> credentials = {"email": email, "password": password};
      user = User.fromJson(jsonDecode(user));
      if (user != null && token != null) {
        await userProvider.getUser(null, user, token);
        ScaffoldMessenger.of(context).showSnackBar(MySnackBars.simpleSnackbar(
            "Ya ha iniciado sesión", Icons.key_outlined, Styles.green));
        print(user);
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _isNotConncet = false;
            });
          }
        });
        Navigator.of(context).pushReplacementNamed("/homePage");
      } else {
        setState(() {
          _isNotConncet = true;
        });
      }
    } catch (e) {
      setState(() {
        _isNotConncet = false;
      });
    }
  }
}
