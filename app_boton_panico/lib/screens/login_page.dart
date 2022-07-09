import 'dart:math';
import '../connection/server_controller.dart' as server;
import 'package:app_boton_panico/screens/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class loguin_page extends StatefulWidget {
  @override
  State<loguin_page> createState() => _loguin_pageState();
}

class _loguin_pageState extends State<loguin_page> {
  bool _loading = false;
  String emailValue;
  String passwordValue;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
          offset: Offset(0, -70),
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
                            decoration: const InputDecoration(
                              label: Text("Usuario"),
                            ),
                            onSaved: (value) => {emailValue = value},
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Ingrese su Correo electronico";
                              }
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              label: Text("Contraseña"),
                            ),
                            onSaved: (value) => {emailValue = value},
                            validator: (value) {
                              if (value.isEmpty) return "Ingrese su contraseña";
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
                                  Text("Inicar sesión"),
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
                                _showHomePage(context);
                              }),
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
      ]),
    );
  }

  void _showHomePage(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (!_loading) {
        setState(() {
          _loading = true;
        });
      }
      Map<String, dynamic> parameters = {
        "email": emailValue,
        "password": passwordValue
      };
      server.getUser(emailValue, passwordValue, parameters);
      /* formKey.currentState.save();
      Navigator.of(context)
          .pushNamed("/homePage", arguments: HomePageArguments()); */
    }
  }

  void _showForgetPassword_page(BuildContext context) {
    Navigator.of(context).pushNamed("/lostPassword_page");
  }
}

class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset.zero, size.bottomRight(Offset.zero), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // bad, but okay for example
    return true;
  }
}
