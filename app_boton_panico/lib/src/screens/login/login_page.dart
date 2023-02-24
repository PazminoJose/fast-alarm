import 'dart:convert';

import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:flutter/services.Dart';

import '../../utils/app_layout.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  var user;
  bool _loading = false;
  bool isSwitched = false;
  bool _isNotConncet;

  final email = TextEditingController();
  final password = TextEditingController();

  String userNameValue = "";
  String passwordValue = "";
  String textButtonSesion = "Iniciar Sesión";
  final formKey = GlobalKey<FormState>();
  UserProvider userProvider;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _isNotConncet = true;
    openUserPreferences(context);
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    BuildContext contextPushScreen = context;
    final Size size = AppLayout.getSize(context);

    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          //padding: const EdgeInsets.symmetric(vertical: 60),
          padding: const EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Styles.primaryColorGradient,
              Styles.secondaryColorGradient,
            ]),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: (size.height * 0.09)),
              child: Image.asset(
                "assets/image/logo.png",
                height: (size.height * 0.2),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(bottom: (size.height * 0.05)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Styles.blur),
                        onPressed: () => _showRegisterPage(contextPushScreen),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "Registrate!",
                            style: TextStyle(color: Styles.white, fontSize: 16),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: (size.height * 0.18),
                      bottom: 20),
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
                              obscureText: _passwordVisible,
                              controller: password,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    (_passwordVisible)
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Styles.secondaryColor,
                                  ),
                                ),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                      "¿Olvidó su contraseña?",
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

  void _showHomePage(context, usuario, password) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Map<String, dynamic> credentials = {
        "userName": usuario,
        "password": password
      };

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

            saveCredentials(user, token);

            Navigator.of(context).pushReplacementNamed("/homePage");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
                'Usuario o Contraseña Incorrecta.\nPor favor intente de nuevo!',
                'Incorrecto!'));
            setState(() {
              _loading = false;
              textButtonSesion = "Iniciar Sesión";
            });
          }
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context)
              .showSnackBar(MySnackBars.errorConectionSnackBar());

          setState(() {
            _loading = false;
            textButtonSesion = "Iniciar Sesión";
          });
        }
      }
    }
  }

  Future<void> saveCredentials(user, String token) async {
    if (isSwitched) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var userString = jsonDecode(jsonEncode(userToJson(user)));
      preferences.setString("user", userString);
      preferences.setString("token", token);
    }
  }

  Future<void> openUserPreferences(context) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      user = preferences.getString("user");
      String token = preferences.getString("token");
      print(user);
      if (user != null && token != null) {
        user = User.fromJson(jsonDecode(user));
        await userProvider.getUser(null, user, token);

        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _isNotConncet = false;
            });
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(MySnackBars.simpleSnackbar(
            "Ya ha iniciado sesión", Icons.key_outlined, Styles.green));
        Navigator.of(context).pushReplacementNamed("/homePage");
      } else {
        setState(() {
          _isNotConncet = false;
        });
        return;
      }
    } catch (e) {
      setState(() {
        _isNotConncet = false;
      });
      return;
    }
  }
}
