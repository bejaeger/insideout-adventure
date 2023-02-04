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

String formatDateDetailsType6(DateTime timestamp) {
  return DateFormat.jm().format(timestamp);
}

String formatDateDetails(DateTime timestamp) {
  return DateFormat.yMd().add_jm().format(timestamp);
}

String formatDateToShowTime(DateTime timestamp) {
  return DateFormat.jm().format(timestamp);
}

String removeLastCharacters(String string, {int removeNumber = 1}) {
  String returnValue = string.substring(0, string.length - removeNumber);
  return returnValue;
}

String secondsToHourMinuteSecondTime(int? value) {
  if (value == null) return "00:00:00";
  int h = value ~/ 3600;
  int m = ((value - h * 3600)) ~/ 60;
  int s = value - (h * 3600) - (m * 60);

  String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();
  String minuteLeft =
      m.toString().length < 2 ? "0" + m.toString() : m.toString();
  String secondsLeft =
      s.toString().length < 2 ? "0" + s.toString() : s.toString();
  String result =
      "$hourLeft" + "h" + " $minuteLeft" + "m" + " $secondsLeft" + "s";
  return result;
}

String secondsToMinuteSecondTime(int? value) {
  if (value == null) return "0m 0s";
  int m = ((value)) ~/ 60;
  int s = value - (m * 60);

  String minuteLeft =
      m.toStringAsFixed(1).length < 2 ? "0" + m.toString() : m.toString();
  String secondsLeft =
      s.toStringAsFixed(1).length < 2 ? "0" + s.toString() : s.toString();
  String result =
      (minuteLeft == "00" ? "" : (minuteLeft + "m")) + " " + secondsLeft + "s";
  return result;
}

String secondsToMinuteTime(int? value) {
  if (value == null) return "0m";
  int m = ((value) / 60).round();

  String minuteLeft =
      m.toStringAsFixed(1).length < 2 ? "0" + m.toString() : m.toString();
  String result = (minuteLeft == "00" ? "" : (minuteLeft + "m"));
  return result;
}
