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
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(0, 150, 136, 1),
                Color.fromRGBO(56, 56, 76, 1),
              ]),
            ),
          ),
          Center(
            child: SizedBox(
              child: Card(
                semanticContainer: false,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 15),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 25, bottom: 25),
                          child: Text(
                            "Registrarse",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 35),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  //controller: name,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.person_outline_rounded),
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
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  //controller: name,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.person_outline_rounded),
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
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  //controller: name,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.calendar_view_week_outlined),
                                    label: Text("Cedula"),
                                  ),
                                  onSaved: (value) => {idCard = value},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su cedula";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  //controller: name,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
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
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.lock_person_outlined),
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
                              ]),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHomePage(context) async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          _loading = false;
        });
        print(Validators.isValidateIdCard(idCard));
        User user = User(        
            name: name,
            surname: suranme,
            idCard: idCard,
            email: email,
            password: password,
            userType: "user");
        user = await serviceUser.saveUser(user);
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 15,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            backgroundColor: Colors.red[400],
            content: Row(
              children: const [
                Icon(
                  Icons.clear_outlined,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(' Error al ingresar el Usuario'),
              ],
            ),
          ));
          return;
        }
        Navigator.of(context).pushReplacementNamed("/");
        ScaffoldMessenger.of(context).showSnackBar(
            MySnackBars.successSaveSnackBar(
                'Usuario registrado con exito.', 'Perfecto!'));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
          'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
          'Error!'));
    }
  }
}
