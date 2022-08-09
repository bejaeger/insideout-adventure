// Some small helper functions

import 'package:intl/intl.dart';

String getInitialsFromName(String name) {
  List<String> splitName = name.split(" ");
  List<String> initials = [];
  for (var i = 0; i < 2; i++) {
    if (splitName.length >= i + 1) {
      if (splitName[i].length > 0) {
        initials.add(splitName[i][0].toUpperCase());
      }
    }
  }
  return initials.join("");
}

List<String> getListOfKeywordsFromString(String? str) {
  if (str == null) return [];
  List<String> splitList = str.split(' ');
  List<String> searchKeywords = [];
  for (int i = 0; i < splitList.length; i++) {
    for (int j = 1; j <= splitList[i].length; j++) {
      searchKeywords.add(splitList[i].substring(0, j).toLowerCase());
    }
  }
  return searchKeywords;
}

String getFirstName(String name) {
  List<String> splitName = name.split(" ");
  return splitName[0];
}

String getStringFromEnum(dynamic enumItem) {
  if (enumItem == null) return "";
  return enumItem.toString().split('.').last;
}

String formatDate(DateTime timestamp) {
  return DateFormat.MMMEd().format(timestamp);
}

String formatDateDetailsType2(DateTime timestamp) {
  return DateFormat.yMMMEd().add_jm().format(timestamp);
}

String formatDateDetailsType3(DateTime timestamp) {
  return DateFormat.MMMEd().add_jm().format(timestamp);
}

String formatDateDetailsType4(DateTime timestamp) {
  return DateFormat.MMMd().add_jm().format(timestamp);
}

String formatDateDetailsType5(DateTime timestamp) {
  return DateFormat.MMMEd().format(timestamp);
}

String formatDateDetails(DateTime timestamp) {
  return DateFormat.yMd().add_jm().format(timestamp);
}

String removeLastCharacters(String string, {int removeNumber = 1}) {
  String returnValue = string.substring(0, string.length - removeNumber);
  return returnValue;
}
