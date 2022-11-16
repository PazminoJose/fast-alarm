class Validators {
  static bool isValidateIdCard(String idCard) {
    var total = 0;
    var longitud = idCard.length;
    var longcheck = longitud - 1;

    if (idCard != "" && longitud == 10) {
      for (int i = 0; i < longcheck; i++) {
        if (i % 2 == 0) {
          var aux = int.parse(idCard[i]) * 2;
          if (aux > 9) aux -= 9;
          total += aux;
        } else {
          total +=
              int.parse(idCard[i]); // parseInt o concatenará en lugar de sumar
        }
      }
    }
    total = total % 10 == 0 ? 10 - total % 10 : 0;

    return int.parse(idCard[longitud - 1]) == total ? true : false;
  }
}
