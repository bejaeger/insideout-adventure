import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'app_config_provider.dart';
import 'firebase_options_prod.dart' as prod;
import 'main_common.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      await Firebase.initializeApp(
          options: prod.DefaultFirebaseOptions.currentPlatform);
    }
    mainCommon(Flavor.prod);
  } catch (e) {
    print(
        "ERROR: App main function failed in main_prod.dart with error: ${e.toString()}");
  }
}
