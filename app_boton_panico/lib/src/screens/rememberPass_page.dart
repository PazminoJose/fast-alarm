import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:provider/provider.dart';

class RememberPassPage extends StatefulWidget {
  const RememberPassPage({Key key}) : super(key: key);

  @override
  State<RememberPassPage> createState() => _RememberPassPageState();
}

class _RememberPassPageState extends State<RememberPassPage> {
  var userProvider;
  final formKey = GlobalKey<FormState>();
  var user;
  bool _loading = false;
  bool _isNotConncet;
  bool isSwitched = false;

  final email = TextEditingController();
  final password = TextEditingController();

  String emailValue = "";
  String passwordValue = "";
  String textButtonSesion = "Recuperar";

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        //padding: const EdgeInsets.symmetric(vertical: 60),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(0, 150, 136, 1),
            Color.fromRGBO(56, 56, 76, 1),
          ]),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 27),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, right: 30),
                      child: Text(
                        "Recuperar constraseña",
                        style: Styles.textStyleBody.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 60, bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              "¿Ha olvidado su contraseña?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              "Se enviará una contraseña temporal a su correo electrónico",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                          Form(
                            key: formKey,
                            child: Column(children: [
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30),
                                ],
                                textInputAction: TextInputAction.next,
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
                              const SizedBox(height: 30),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
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
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                    ],
                                  ),
                                  onPressed: () {
                                    emailValue = email.text;
                                    _showHomePage(context, emailValue);
                                  }),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHomePage(context, usuario) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Map<String, dynamic> credentials = {
        "email": usuario,
      };

      if (!_loading) {
        try {
          user = await userProvider.getUser(credentials);

          if (user != null) {
            Navigator.of(context).pushReplacementNamed("/homePage");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
                'Usuario o Contraseña Incorrecta.\nPor favor intente de nuevo!',
                'Incorrecto!'));
            //_showToast("Usuario o Contraseña Incorrecta", "red", "error");
            setState(() {
              _loading = false;
              textButtonSesion = "Recuperar";
            });
          }
        } catch (e) {
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
}
