import 'package:app_boton_panico/src/components/toasts.dart';
import 'package:app_boton_panico/src/models/entities.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_boton_panico/src/components/snackbars.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  FToast fToast;
  var user;
  bool _loading = false;
  bool _loadingFirst;
  bool isSwitched = false;

  final email = TextEditingController();
  final password = TextEditingController();

  String emailValue = "";
  String passwordValue = "";
  final formKey = GlobalKey<FormState>();
  var userProvider;

  @override
  void initState() {
    super.initState();
    _loadingFirst = true;
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);

    // ignore: prefer_const_constructors
    return FutureBuilder(
      future: openUserPreferences(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Future hasn't finished yet, return a placeholder

        }
        return Scaffold(
          body: Stack(children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(0, 150, 136, 1),
                  Color.fromRGBO(56, 56, 76, 1),
                ]),
              ),
              child: Image.asset(
                "assets/image/fast_alert_logo.png",
                height: 170,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 260, bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: email,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  label: Text("Email"),
                                ),
                                onSaved: (value) => {emailValue = value},
                                validator: (value) {
                                  if (value.isEmpty || value == null) {
                                    return "Ingrese su correo electronico";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Iniciar Sesión"),
                                      if (_loading)
                                        Container(
                                          width: 20,
                                          height: 20,
                                          margin: const EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                    ],
                                  ),
                                  onPressed: () {
                                    emailValue = email.text;
                                    passwordValue = password.text;

                                    _showHomePage(
                                        context, emailValue, passwordValue);
                                  }),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  const Text("Guardar Sesión"),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 15)),
                                  Switch(
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
                                  const Text("¿No estas registrado?"),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed("/register");
                                      },
                                      child: const Text(
                                        "Registrate",
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
                ),
              ),
            ),
            if (_loadingFirst)
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
      },
    );
  }

  void _showHomePage(context, usuario, password) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Map<String, dynamic> credentials = {
        "email": usuario,
        "password": password
      };
      print(credentials);

      if (!_loading) {
        setState(() {
          _loading = true;
        });
        try {
          user = await userProvider.getUser(credentials);
          print(user);
          if (user != null) {
            if (isSwitched) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.setString("email", usuario);
              preferences.setString("password", password);
            }

            Navigator.of(context).pushReplacementNamed("/homePage");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
                'Usuario o Contraseña Incorrecta.\nPor favor intente de nuevo!',
                'Incorrecto!'));
            //_showToast("Usuario o Contraseña Incorrecta", "red", "error");
            setState(() {
              _loading = false;
            });
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
              'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
              'Error!'));
          setState(() {
            _loading = false;
          });
        }
      }
    }
  }

  Future<void> openUserPreferences(context) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var email = preferences.getString("email");
      var password = preferences.getString("password");
      Map<String, dynamic> credentials = {"email": email, "password": password};
      if (email != null && password != null) {
        user = await userProvider.getUser(credentials);
        MyToast.showToast("Ya ha iniciado sesión", "green", "ok", context);
        print(user);
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _loadingFirst = false;
            });
          }
        });
        Navigator.of(context).pushReplacementNamed("/homePage");
      } else {
        setState(() {
          _loadingFirst = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
          'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
          'Error!'));
      setState(() {
        _loadingFirst = true;
      });
    }
  }
}
