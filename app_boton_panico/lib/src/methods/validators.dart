class Validators {
  static bool isValidateIdCard(String cedula) {
    bool cedulaCorrecta = false;

    try {
      if (cedula.length == 10) // ConstantesApp.LongitudCedula
      {
        int tercerDigito = int.parse(cedula.substring(2, 3));
        if (tercerDigito < 6) {
// Coeficientes de validación cédula
// El decimo digito se lo considera dígito verificador
          List<int> coefValCedula = [2, 1, 2, 1, 2, 1, 2, 1, 2];
          int verificador = int.parse(cedula.substring(9, 10));
          int suma = 0;
          int digito = 0;
          for (int i = 0; i < (cedula.length - 1); i++) {
            digito = int.parse(cedula.substring(i, i + 1)) * coefValCedula[i];
            suma += ((digito % 10).toInt() + (digito ~/ 10));
          }

          if ((suma % 10 == 0) && (suma % 10 == verificador)) {
            cedulaCorrecta = true;
          } else if ((10 - (suma % 10)) == verificador) {
            cedulaCorrecta = true;
          } else {
            cedulaCorrecta = false;
          }
        } else {
          cedulaCorrecta = false;
        }
      } else {
        cedulaCorrecta = false;
      }
    } on FormatException {
      cedulaCorrecta = false;
    } on Exception {
      print("Una excepcion ocurrio en el proceso de validadcion");
      cedulaCorrecta = false;
    }

    if (!cedulaCorrecta) {
      print("La Cédula ingresada es Incorrecta");
    }
    return cedulaCorrecta;
  }
}
