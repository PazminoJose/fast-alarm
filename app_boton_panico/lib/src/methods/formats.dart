
class Formats {
  /// It takes a phone number, adds the country code to it, and returns the formatted phone number
  /// 
  /// Args:
  ///   number (String): The phone number to send the message to.
  /// 
  /// Returns:
  ///   The number is being returned with the country code.
  static String formatPhoneNumber(String number) {
    number = "+593${number.substring(1, 10)}";
    print(number);
    return number;
  }
}
