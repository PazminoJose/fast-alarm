import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/methods/validators.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/screens/register/components/user_photo.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController idCard = TextEditingController();
  TextEditingController bithDate = TextEditingController();
  TextEditingController maritalStatus = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController ethnic = TextEditingController();
  DateTime pickerDate;
  bool isDisability = false;
  XFile imageFile;
  bool isPhoto = false;
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
          icon: const Icon(
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
                        UserPhoto(
                            imageFile: imageFile,
                            onImageSelected: ((file) {
                              setState(() {
                                imageFile = file;
                              });
                            })),
                        if (isPhoto)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "La imagen es obligatoria",
                                style: TextStyle(color: Colors.red[400]),
                              )
                            ],
                          ),
                        const Gap(10),
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
                                          LengthLimitingTextInputFormatter(15),
                                          FilteringTextInputFormatter.allow(
                                              Styles.exprOnlyLetter),
                                        ],
                                        controller: firstName,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
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
                                    const Gap(15),
                                    Expanded(
                                      child: TextFormField(
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(15),
                                          FilteringTextInputFormatter.allow(
                                              Styles.exprOnlyLetter),
                                        ],
                                        controller: middleName,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.name,
                                        textCapitalization:
                                            TextCapitalization.sentences,
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
                                    LengthLimitingTextInputFormatter(30),
                                    FilteringTextInputFormatter.allow(
                                        Styles.exprOnlyLetter),
                                  ],
                                  controller: lastName,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.person_outline_rounded),
                                    label: Text(
                                      "Apellidos",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) => {lastName.text = value},
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
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.calendar_view_week_outlined),
                                    label: Text(
                                      "Cédula",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) => {idCard.text = value},
                                  validator: (value) {
                                    if (value.isEmpty || value == null) {
                                      return "Ingrese su cédula";
                                    } /* else if (value.substring(0, 2) != "04") {
                                      return "Debe ingresar una cedula respectiva a Carchi";
                                    } */ else if ((!Validators.isValidateIdCard(
                                        value))) {
                                      return "Ingrese una cédula correcta";
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
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.calendar_month_outlined),
                                    label: Text(
                                      "Fecha de nacimiento",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) => {bithDate.text = value},
                                  readOnly: true,
                                  controller: bithDate,
                                  onTap: (() async {
                                    pickerDate = await showDatePicker(
                                        //locale: const Locale("es", "EC"),
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(1950),
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
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Estado Civil",
                                              style: Styles.textLabel,
                                            ),
                                          ),
                                          items: listMaritalStatus.map((e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            );
                                          }).toList(),
                                          validator: (value) => value == null
                                              ? "Elija su Estado Civil"
                                              : null,
                                          onChanged: (item) => setState(() {
                                                maritalStatus.text = item;
                                              })),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Género",
                                              style: Styles.textLabel,
                                            ),
                                          ),
                                          items: listGender.map((e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
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
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Etnia",
                                              style: Styles.textLabel,
                                            ),
                                          ),
                                          items: listEthnic.map((e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            );
                                          }).toList(),
                                          validator: (value) => value == null
                                              ? "Elija su Etnia"
                                              : null,
                                          onChanged: (item) => setState(() {
                                                ethnic.text = item;
                                              })),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "¿Sufre alguna\n discapacidad?",
                                          style: Styles.textLabel,
                                        ),
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
                                  children: const [
                                    Text("Continuar"),
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

  /// records all user data to move to a second screen that records the remaining data
  /// Returns:
  ///   The person object is being returned.
  Future<void> _showSecondPageRegister(BuildContext context) async {
    try {
      if (checkImage()) return;
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        String bithDateCast = DateFormat('yyyy-MM-dd').format(pickerDate);
        Person person = Person(
          firstName: firstName.text,
          middleName: middleName.text,
          lastName: lastName.text,
          idCard: idCard.text,
          urlImage: imageFile,
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
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.errorConectionSnackBar());
    }
  }

  bool checkImage() {
    if (imageFile == null) {
      setState(() {
        isPhoto = true;
      });
      return true;
    } else {
      setState(() {
        isPhoto = false;
      });
      return false;
    }
  }
}
