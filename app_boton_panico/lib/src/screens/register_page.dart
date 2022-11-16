import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/components/toasts.dart';
import 'package:app_boton_panico/src/methods/validators.dart';
import 'package:app_boton_panico/src/models/entities.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _loading = false;
  bool _loadingFirst;
  bool isSwitched = false;

  String email = "";
  String name = "";
  String suranme = "";
  String idCard = "";
  String password = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var serviceUser = UserServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                          key: _formKey,
                          child: Column(children: [
                            TextFormField(
                              keyboardType: TextInputType.name,
                              //controller: name,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_rounded),
                                label: Text("Nombre"),
                              ),
                              onSaved: (value) => {name = value},
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Ingrese su nombre";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              //controller: name,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_rounded),
                                label: Text("Apellido"),
                              ),
                              onSaved: (value) => {suranme = value},
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Ingrese su apellido";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              //controller: name,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_rounded),
                                label: Text("Apellido"),
                              ),
                              onSaved: (value) => {idCard = value},
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Ingrese su cedula";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              //controller: name,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                label: Text("Email"),
                              ),
                              onSaved: (value) => {email = value},
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Ingrese su Email";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              //obscureText: true,
                              //controller: password,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock_person),
                                label: Text("Contraseña"),
                              ),
                              onSaved: (value) => {password = value},
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
                                    const Text("Registrarse"),
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

  void _showHomePage(context) async {
    try {
      if (_loading) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          setState(() {
            _loading = false;
          });
          print(Validators.isValidateIdCard(idCard));
          User user = User(
              id: "",
              name: name,
              surname: suranme,
              idCard: idCard,
              email: email,
              password: password,
              userType: "user");
          user = await serviceUser.saveUser(user);
          if (user == null) {
            MyToast.showToast(
                "Error al ingresar el Usuario", "red", "error", context);
            return;
          }
          Navigator.of(context).pushReplacementNamed("/");
          ScaffoldMessenger.of(context).showSnackBar(
              MySnackBars.successSaveSnackBar(
                  'Usuario registrado con exito.', 'Perfecto!'));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
          'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
          'Error!'));
    }
  }
}
