import 'package:app_boton_panico/src/models/entities.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/screens/my_home_page.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loguin_page extends StatefulWidget {
  @override
  State<loguin_page> createState() => _loguin_pageState();
}

class _loguin_pageState extends State<loguin_page> {
  FToast fToast;
  var user = User();
  bool _loading = false;
  bool _loadingFirst;
  bool isSwitched = false;

  final email = TextEditingController();
  final password = TextEditingController();

  String emailValue = "";
  String passwordValue = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController em = TextEditingController();
  TextEditingController pass = TextEditingController();
  var userProvider;

  @override
  void initState() {
    super.initState();
    _loadingFirst = true;
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _loadingFirst = false;
      });
    });
    preferences();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);

    // ignore: prefer_const_constructors
    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 60),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(0, 150, 136, 1),
              Color.fromRGBO(56, 56, 76, 1),
            ]),
          ),
          child: Image.asset(
            "assets/image/login.png",
            height: 170,
          ),
        ),
        Transform.translate(
          offset: Offset(0, -50),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 260, bottom: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
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
                                return "Ingrese su Correo electronico";
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
                          SizedBox(height: 30),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Iniciar sesión"),
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
                                emailValue = email.text;
                                passwordValue = password.text;

                                _showHomePage(
                                    context, emailValue, passwordValue);
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text("Guardar Sesión"),
                              Padding(padding: EdgeInsets.only(right: 15)),
                              Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                    });
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      _showForgetPassword_page(context);
                                    },
                                    child: const Text(
                                      "¿Olvido su contraseña?",
                                      style:
                                          TextStyle(color: Colors.blueAccent),
                                    ))
                              ])
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
  }

  void _showHomePage(BuildContext context, usuario, password) async {
    if (formKey.currentState.validate()) {
      Map<String, dynamic> credentials = {
        "email": usuario,
        "password": password
      };
      print(credentials);

      if (!_loading) {
        setState(() {
          _loading = true;
        });

        var user = await userProvider.getUser(credentials);

        if (user != null) {
          formKey.currentState.save();
          if (isSwitched) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString("email1", usuario);
            preferences.setString("password1", password);
          }

          Navigator.of(context).pushReplacementNamed("/homePage",
              arguments: HomePageArguments(user: user));
        } else {
          _showToast("Usuario o Contraseña Incorrecta", "red", "error");
          setState(() {
            _loading = false;
          });
        }
      }
    }
  }

  void _showForgetPassword_page(BuildContext context) {
    Navigator.of(context).pushNamed("/lostPassword_page");
  }

  _showToast(String messege, String color, String icon) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: (color == "red") ? Colors.red : Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon((icon == "error") ? Icons.error : Icons.key_outlined),
          const SizedBox(
            width: 12.0,
          ),
          Text(messege),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
      fadeDuration: 1000,
    );
  }

  Future<void> preferences() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var email = preferences.getString("email");
    var password = preferences.getString("password");
    Map<String, dynamic> credentials = {"email": email, "password": password};
    if (email != null && password != null) {
      var user = await userProvider.getUser(credentials);
      _showToast("Ya ha iniciado sesión", "green", "ok");

      Navigator.of(context).pushReplacementNamed("/homePage",
          arguments: HomePageArguments(user: user));
    } else {
      return;
    }
  }
}
