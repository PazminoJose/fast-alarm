import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/methods/validators.dart';
import 'package:app_boton_panico/src/models/failure.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/screens/register/components/user_photo.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//TODO: cargar imagen
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController idCard = TextEditingController();
  TextEditingController bithDate = TextEditingController();
  TextEditingController maritalStatus = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController ethnic = TextEditingController();
  DateTime pickerDate;
  bool isDisability = false;

  List<String> listMaritalStatus = [
    'Casado',
    'Soltero',
    'Divorciado',
    'Viudo',
    'Union libre'
  ];
  List<String> listEthnic = [
    'Mestizo',
    'Afroecuatoriano',
    'Indigena',
    'Blanca'
  ];
  List<String> listGender = ['Masculino', 'Femenino', 'No especificado'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bithDate.text;
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
        title: const Text("Información Personal"),
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
                    left: 15, right: 15, top: 80, bottom: 10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        UserPhoto(),
                        Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter.allow(
                                              Styles.exprOnlyLetter),
                                        ],
                                        controller: firstName,
                                        textInputAction: TextInputAction.next,
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
                                        onSaved: (value) =>
                                            {firstName.text = value},
                                        validator: (value) {
                                          if (value.isEmpty || value == null) {
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
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter.allow(
                                              Styles.exprOnlyLetter),
                                        ],
                                        controller: middleName,
                                        textInputAction: TextInputAction.next,
                                        autofocus: true,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Segundo nombre",
                                            style: Styles.textLabel,
                                          ),
                                        ),
                                        onSaved: (value) =>
                                            {middleName.text = value},
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
                                const SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                    FilteringTextInputFormatter.allow(
                                        Styles.exprOnlyLetter),
                                  ],
                                  controller: surname,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.person_outline_rounded),
                                    label: Text("Apellidos"),
                                  ),
                                  onSaved: (value) => {surname.text = value},
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
                                    FilteringTextInputFormatter.allow(
                                        Styles.exprOnlydigists),
                                  ],
                                  controller: idCard,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.calendar_view_week_outlined),
                                    label: Text("Cedula"),
                                  ),
                                  onSaved: (value) => {idCard.text = value},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su cedula";
                                    } else if (value.substring(0, 2) != "04") {
                                      return "Debe ingresar una cedula respectiva a Carchi";
                                    } else if ((!Validators.isValidateIdCard(
                                        value))) {
                                      return "Ingrese una cedula correcta";
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
                                  onSaved: (value) => {bithDate.text = value},
                                  readOnly: true,
                                  controller: bithDate,
                                  onTap: (() async {
                                    pickerDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(1970),
                                        lastDate: DateTime(2101));
                                    if (pickerDate != null) {
                                      final dateFormat =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickerDate);
                                      setState(() {
                                        bithDate.text = dateFormat.toString();
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            label: Text("Estado Civil"),
                                          ),
                                          items: listMaritalStatus.map((e) {
                                            return DropdownMenuItem(
                                              child: Text(e),
                                              value: e,
                                            );
                                          }).toList(),
                                          validator: (value) => value == null
                                              ? "Elija su Estado Civil"
                                              : null,
                                          onChanged: (item) => setState(() {
                                                maritalStatus.text = item;
                                              })),
                                    ),
                                    Gap(10),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            label: Text("Género"),
                                          ),
                                          items: listGender.map((e) {
                                            return DropdownMenuItem(
                                              child: Text(e),
                                              value: e,
                                            );
                                          }).toList(),
                                          validator: (value) => value == null
                                              ? "Elija su Genero"
                                              : null,
                                          onChanged: (item) => setState(() {
                                                gender.text = item;
                                              })),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            label: Text("Etnia"),
                                          ),
                                          items: listEthnic.map((e) {
                                            return DropdownMenuItem(
                                              child: Text(e),
                                              value: e,
                                            );
                                          }).toList(),
                                          validator: (value) => value == null
                                              ? "Elija su Etnia"
                                              : null,
                                          onChanged: (item) => setState(() {
                                                ethnic.text = item;
                                              })),
                                    ),
                                    Gap(10),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("¿Sufre alguna\n discapacidad?"),
                                        Checkbox(
                                            activeColor: Styles.primaryColor,
                                            value: isDisability,
                                            onChanged: (value) {
                                              setState(() {
                                                isDisability = value;
                                              });
                                            }),
                                      ],
                                    )),
                                  ],
                                ),
                              ]),
                        ),
                        const SizedBox(height: 20),
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
                                  _showSecondPageRegister(context);
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
  void _showSecondPageRegister(BuildContext context) {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        //print(bithDate.text);
        String bithDateCast = DateFormat('yyyy-MM-dd').format(pickerDate);
        Person person = Person(
          firstName: firstName.text,
          middleName: middleName.text,
          idCard: idCard.text,
          birthDate: DateTime.parse(bithDateCast),
          maritalStatus: maritalStatus.text.toLowerCase(),
          gender: gender.text.toLowerCase(),
          ethnic: ethnic.text.toLowerCase(),
          disability: isDisability,
        );
        print(person.maritalStatus);

        Navigator.of(context)
            .pushNamed("/secondRegisterPage", arguments: person);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar(
          'No se pudo conectar a Internet.\nPor favor compruebe su conexión!',
          'Error!'));
    }
  }
}
