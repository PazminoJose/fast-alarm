import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';

class RememberPassPage extends StatefulWidget {
  const RememberPassPage({Key key}) : super(key: key);

  @override
  State<RememberPassPage> createState() => _RememberPassPageState();
}

class _RememberPassPageState extends State<RememberPassPage> {
  final formKey = GlobalKey<FormState>();
  bool _loading = false;

  String userNameValue = "";
  String textButtonSesion = "Recuperar";

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
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
            Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 60, bottom: 0),
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
                            "Se enviará una contraseña temporal a su correo electrónico.\n\nIngrese su nombre de usuario",
                            style: TextStyle(color: Colors.black, fontSize: 15),
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
                              decoration: const InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.person_outline_rounded),
                                  label: Text("Usuario"),
                                  hintText: "Ej. P0492834758"),
                              onSaved: (value) => {userNameValue = value},
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return "Ingrese su nombre de usuario";
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
                                  rememberPass(context);
                                }),
                          ]),
                        ),
                      ],
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

  void rememberPass(context) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Map<String, dynamic> changePasswordData = {
        "userName": userNameValue,
      };

      if (!_loading) {
        try {
          setState(() {
            _loading = true;
            textButtonSesion = "Enviando";
          });
          UserServices userServices = UserServices();
          Map response = await userServices
              .postSendEmailChangePassword(changePasswordData);

          if (response != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                MySnackBars.simpleSnackbar("${response["message"]}",
                    Icons.lock_reset_rounded, Styles.green));
            Navigator.of(context).pushReplacementNamed("/");
          } else {
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                  MySnackBars.simpleSnackbar("Verifique su nombre de Usuario",
                      Icons.dangerous, Styles.red));
              _loading = false;
              textButtonSesion = "Recuperar";
            });
          }
        } catch (e) {
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
}
