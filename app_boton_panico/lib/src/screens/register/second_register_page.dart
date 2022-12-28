import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/methods/validators.dart';
import 'package:app_boton_panico/src/models/entities.dart';
import 'package:app_boton_panico/src/screens/register/components/user_photo.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class SecondRegisterPage extends StatefulWidget {
  const SecondRegisterPage({Key key}) : super(key: key);

  @override
  State<SecondRegisterPage> createState() => _SecondRegisterPageState();
}

class _SecondRegisterPageState extends State<SecondRegisterPage> {
  bool _loading = false;
  bool isSwitched = false;
  var serviceUser = UserServices();

  List<String> listParroquias = [
    'Chical',
    'El Carmelo',
    'Gonazales Suarez',
    'Julio Andrade',
    'Maldonado',
    'Pioter',
    'Santa Marta de Cuba',
    'Tobar Donoso',
    'Tufiño',
    'Tulcan',
    'Urbina'
  ];
  String selectParroquia = "";
  String email = "";
  String name = "";
  String suranme = "";
  String idCard = "";
  String phone = "";
  String password = "";
  String barrio = "";
  TextEditingController userNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameController.text = "P0401527650";
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
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
                    left: 15, right: 15, top: 90, bottom: 40),
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
                                Text(
                                  "Domicilio",
                                  style: Styles.textStyleTitle,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            label: Text("Parroquia"),
                                          ),
                                          items: listParroquias.map((e) {
                                            return DropdownMenuItem(
                                              child: Text(e),
                                              value: e,
                                            );
                                          }).toList(),
                                          onChanged: (item) => setState(() {
                                                selectParroquia = item;
                                              })),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Barrio",
                                            style: Styles.textLabel,
                                          ),
                                        ),
                                        onSaved: (value) => {barrio = value},
                                        validator: (value) {
                                          if (value.isEmpty || value == null) {
                                            return "Ingrese su nombre";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Cuenta",
                                  style: Styles.textStyleTitle,
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
                                    prefixIcon:
                                        Icon(Icons.person_outline_rounded),
                                    label: Text(
                                      "Nombre de Usuario",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) =>
                                      {userNameController.text = value},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su nombre";
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: "09673803004",
                                    prefixIcon: Icon(Icons.phone_outlined),
                                    label: Text("Teléfono"),
                                  ),
                                  onSaved: (value) => {phone = value},
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
                                  ],
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
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
                                  height: 7,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
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
                                const SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock_person),
                                    label: Text("Confirmar contraseña"),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                    const Text("Continuar"),
                                    Icon(Icons.arrow_forward_rounded)
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

//TODO: Comprobar cedula con 0
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
            phone: phone,
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
