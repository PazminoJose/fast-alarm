class Formats {
  static String FormatPhoneNumber(String number) {
    number = "+593${number.substring(1, 10)}";
    print(number);
    return number;
  }
}
