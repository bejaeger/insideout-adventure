import 'package:afkcredits/constants/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

int createUniqueId() {
  return DateTime.now().microsecondsSinceEpoch.remainder(100000);
}

int mapAnimationSpeed() {
  return !kIsWeb && Platform.isIOS
      ? kMapAnimationSpeedIos
      : kMapAnimationSpeedAndroid;
}

double mapAnimationSpeedFraction() {
  return !kIsWeb && Platform.isIOS
      ? kMapAnimationSpeedFractionIos
      : kMapAnimationSpeedFractionAndroid;
}

String getPermanentNotificationKeyFromSessionId(String id) {
  return "PermanentNotification" + id;
}

String getScheduledNotificationKeyFromSessionId(String id) {
  return "ScheduledNotification" + id;
}