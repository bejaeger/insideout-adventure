import 'dart:io';

import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/main_common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'firebase_options_dev.dart' as dev;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      // not in agreement with GoogleService.plist warning appears
      // for iOS run in prod mode for now!
      await Firebase.initializeApp(
          name: Platform.isIOS ? "Dev" : null,
          options: dev.DefaultFirebaseOptions.currentPlatform);
    } else {
      await Firebase.initializeApp(
          options: dev.DefaultFirebaseOptions.currentPlatform);
    }

    mainCommon(Flavor.dev);
  } catch (e) {
    print(
        "ERROR: App main function failed in main_dev.dart with error: ${e.toString()}");
  }
}
