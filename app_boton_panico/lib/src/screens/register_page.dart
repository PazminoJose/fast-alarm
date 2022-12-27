import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/methods/validators.dart';
import 'package:app_boton_panico/src/models/entities.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _loading = false;
  bool isSwitched = false;
  TextEditingController dateController = TextEditingController();
  var serviceUser = UserServices();

  String email = "";
  String name = "";
  String suranme = "";
  String idCard = "";
  String phone = "";
  String password = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateController.text;
  }

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
          Column(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    child: Card(
                      semanticContainer: false,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 50, bottom: 40),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: true,
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.person_outline_rounded),
                                              label: Text(
                                                "Primer nombre",
                                                style: Styles.textLabel,
                                              ),
                                            ),
                                            onSaved: (value) => {name = value},
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  value == null) {
                                                return "Ingrese su nombre";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Gap(15),
                                        Expanded(
                                          child: TextFormField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: true,
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.person_outline_rounded),
                                              label: Text(
                                                "Segundo nombre",
                                                style: Styles.textLabel,
                                              ),
                                            ),
                                            onSaved: (value) => {name = value},
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  value == null) {
                                                return "Ingrese su nombre";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(15),
                                      ],
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.person_outline_rounded),
                                        label: Text("Apellidos"),
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
                                      height: 7,
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                            Icons.calendar_view_week_outlined),
                                        label: Text("Cedula"),
                                      ),
                                      onSaved: (value) => {idCard = value},
                                      validator: (value) {
                                        if (value.isEmpty || value == null) {
                                          return "Ingrese su cedula";
                                        } else if (value.substring(0, 2) !=
                                            "04") {
                                          return "Debe ingresar una cedula respectiva a Carchi";
                                        } else if ((!Validators
                                            .isValidateIdCard(value))) {
                                          return "Ingrese una cedula correcta";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 7,
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
                                      keyboardType: TextInputType.datetime,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.calendar_month_outlined),
                                        label: Text("Fecha de nacimiento"),
                                      ),
                                      onSaved: (value) => {email = value},
                                      readOnly: true,
                                      controller: dateController,
                                      onTap: (() async {
                                        DateTime pickerDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1970),
                                                lastDate: DateTime(2101));
                                        if (pickerDate != null) {
                                          final dateFormat =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(pickerDate);
                                          setState(() {
                                            dateController.text =
                                                dateFormat.toString();
                                          });
                                        } else {
                                          print("no seleccionado ");
                                        }
                                      }),
                                      validator: (value) {
                                        if (value.isEmpty || value == null) {
                                          return "Ingrese su fecha";
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
                                  ]),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
