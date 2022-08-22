import 'package:afkcredits/enums/auth_exceptions/auth_exceptions.dart';

class FormValidators {
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      const exception = AuthExceptions.emptyPassword;
      return exception.message;
    } else {
      return null;
    }
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      const exception = AuthExceptions.emptyName;
      return exception.message;
    }
    if (value.length < 6) {
      const exception = AuthExceptions.weakPassword;
      return exception.message;
    }
    return null;
  }
}
