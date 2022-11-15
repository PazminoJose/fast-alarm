import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _loading = false;
  bool _loadingFirst;
  bool isSwitched = false;

  final email = TextEditingController();
  final password = TextEditingController();

  String emailValue = "";
  String passwordValue = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
            "assets/image/fast_alert_logo.png",
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
                          SizedBox(height: 30),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Iniciar Sesión"),
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
                          const SizedBox(
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
        ],
      ),
    );
  }

  void _showHomePage(BuildContext context, usuario, password) async {
    if (formKey.currentState.validate()) {
      
    }
  }
}

  