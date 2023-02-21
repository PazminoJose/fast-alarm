import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/methods/formats.dart';
import 'package:app_boton_panico/src/methods/validators.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/screens/map/map_direcctions.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SecondRegisterPage extends StatefulWidget {
  const SecondRegisterPage({Key key}) : super(key: key);

  @override
  State<SecondRegisterPage> createState() => _SecondRegisterPageState();
}

class _SecondRegisterPageState extends State<SecondRegisterPage> {
  bool _loading = false;
  bool isSwitched = false;

  TextEditingController userNameController = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  TextEditingController address = TextEditingController();
  String textButtonSesion = "Registrarse";
  Person personArguments;
  LatLng directions;

  bool isMatchPaswwords = false;

  var serviceUser = UserServices();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    personArguments = ModalRoute.of(context).settings.arguments as Person;
    userNameController.text =
        getUserName(personArguments.firstName, personArguments.idCard);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Styles.tranparent,
        elevation: 0,
        title: const Text("Información Adicional"),
        centerTitle: true,
      ),
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
                    left: 15, right: 15, top: 90, bottom: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.house_outlined),
                                    const Gap(20),
                                    Text(
                                      "Domicilio",
                                      style: Styles.textStyleTitle,
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.location_on_outlined),
                                    label: Text("Obtener Dirección"),
                                  ),
                                  onSaved: (value) => {address.text = value},
                                  readOnly: true,
                                  controller: address,
                                  onTap: () => {_navigateAndReturnDirecction()},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su Dirección";
                                    }
                                    return null;
                                  },
                                ),
                                const Gap(30),

                                //TODO: ¨***********CUENTA*****************
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.account_box_outlined),
                                    const Gap(20),
                                    Text(
                                      "Cuenta",
                                      style: Styles.textStyleTitle,
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  readOnly: true,
                                  controller: userNameController,
                                  textInputAction: TextInputAction.next,
                                  autofocus: true,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.person_outline_rounded),
                                    label: Text(
                                      "Nombre de Usuario",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) =>
                                      {userNameController.text = value},
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        Styles.exprOnlydigists),
                                  ],
                                  controller: phone,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: "Ej. 09673803004",
                                    prefixIcon:
                                        const Icon(Icons.phone_outlined),
                                    label: Text(
                                      "Teléfono",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) => {phone.text = value},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su telefono";
                                    } else if (value.length != 10 ||
                                        value.substring(0, 2) != "09") {
                                      return "Ingrese un telefono correcto";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30),
                                    FilteringTextInputFormatter.deny(
                                        Styles.exprWithoutWhitspace),
                                  ],
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                    label: Text(
                                      "Email",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) => {email.text = value},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su Email";
                                    } else if (!Validators.validateEmail(
                                        value)) {
                                      return "Ingrese un correo valido";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                    FilteringTextInputFormatter.deny(
                                        Styles.exprWithoutWhitspace),
                                  ],
                                  controller: password,
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock_person),
                                    label: Text(
                                      "Contraseña",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) => {password.text = value},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su contraseña";
                                    } else if (value.length < 6) {
                                      return "La contraseña debe tener almenos 6 caracteres";
                                    }
                                    password.text = value;
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                    FilteringTextInputFormatter.deny(
                                        Styles.exprWithoutWhitspace),
                                  ],
                                  controller: passwordConfirm,
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock_person),
                                    label: Text(
                                      "Confirmar contraseña",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) =>
                                      {passwordConfirm.text = value},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su contraseña";
                                    } else if (value.length < 6) {
                                      return "La contraseña debe tener almenos 6 caracteres";
                                    }
                                    if (!(password.text == value)) {
                                      return "Las contraseñas no coinciden";
                                    }

                                    return null;
                                  },
                                ),
                              ]),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  maximumSize: Size(
                                    (size.width * 0.35),
                                    (size.width * 0.35),
                                  ),
                                  elevation: 10,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                  _showHomePage(context);
                                }),
                          ],
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
    );
  }

  ///  _showHomePage() It is a function that verifies the user in the database and allows entry to the application.
  /// A function that receives a context, a user and a password and returns a future.
  ///
  /// Args:
  ///   context: The context of the current page.
  ///   usuario: The username of the user who is trying to log in.
  ///   password: The password of the user.
  void _showHomePage(context) async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          textButtonSesion = "Registrando";
          _loading = false;
        });
        personArguments.phone = Formats.formatPhoneNumber(phone.text);
        personArguments.address = address.text;

        User user = User(
          password: passwordConfirm.text,
          userType: "user",
          userName: userNameController.text,
          email: email.text,
        );
        
        Map map = await serviceUser.saveUser(user, personArguments);
        if (map == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 15,
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

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                  title: Column(
                    children: [
                      const Text("¡Perfecto!"),
                      Text(map["message"]),
                    ],
                  ),
                  content: Text(
                      "Recuerda tu nombre de usuario para poder ingresar\nUsuario: ${map["userName"]}"),
                  actions: [
                    TextButton(
                        onPressed: (() =>
                            Navigator.of(context).pushReplacementNamed("/")),
                        child: Text(
                          "OK",
                          style: Styles.textLabel.copyWith(color: Colors.blue),
                        ))
                  ],
                ));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.errorConectionSnackBar());

      setState(() {
        _loading = false;
        textButtonSesion = "Registrarse";
      });
    }
  }

  /// It takes a name and an idCard and returns the first letter of the name and the idCard
  ///
  /// Args:
  ///   name (String): The name of the user.
  ///   idCard (String): The ID card number of the user.
  ///
  /// Returns:
  ///   The first character of the name and the idCard.
  String getUserName(String name, String idCard) {
    return (name.substring(0, 1) + idCard);
  }

  Future<void> _navigateAndReturnDirecction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPlaces()),
    );

    if (!mounted) return;
    address.text = result;
    print(personArguments.firstName);
  }
}
