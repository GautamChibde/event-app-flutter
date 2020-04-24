class Validator {
  static const emailPattern = "^[A-Za-z0-9]+(.|_)+[A-Za-z0-9]+@+gmail.com\$";

  static bool validEmail(String email) {
    RegExp regex = new RegExp(emailPattern);
    return regex.hasMatch(email);
  }
}

class StringUtils {
  static String capitalize(String text) {
    return "${text[0].toUpperCase()}${text.substring(1)}";
  }
}
