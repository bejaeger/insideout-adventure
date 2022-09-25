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

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      const exception = AuthExceptions.emailRequired;
      return exception.message;
    }
    return null;
  }

  static String? customScreenTimeValidator(String? value) {
    if (value == null || value.isEmpty) {
      const exception = AuthExceptions.timeRequired;
      return exception.message;
    }
    try {
      int v = int.parse(value);
    } catch (e) {
      const exception = AuthExceptions.timeNotPosInt;
      return exception.message;
    }
    if (int.parse(value) < 0) {
      const exception = AuthExceptions.timeNotPosInt;
      return exception.message;
    } else {
      return null;
    }
  }
}
