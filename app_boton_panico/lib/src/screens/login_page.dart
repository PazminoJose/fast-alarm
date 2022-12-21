import 'package:app_boton_panico/src/providers/user_provider.dart';
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

  String emailValue = "";
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
    userProvider = Provider.of<UserProvider>(context, listen: false);

    // ignore: prefer_const_constructors
    return Scaffold(

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
          textButtonSesion = "Iniciando";
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
              textButtonSesion = "Iniciar Sesión";
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

  Future<void> openUserPreferences(context) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var email = preferences.getString("email");
      var password = preferences.getString("password");
      Map<String, dynamic> credentials = {"email": email, "password": password};
      if (email != null && password != null) {
        user = await userProvider.getUser(credentials);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 15,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
          backgroundColor: Colors.green,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(
                Icons.key_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 20,
              ),
              Text(' Ya ha iniciado sesión'),
            ],
          ),
        ));
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
          _isNotConncet = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Los permisos de localización están permanentemente denegados, no podemos solicitar permisos.'),
        ),
      );
      setState(() {
        _isNotConncet = true;
      });
    }
  }
}
