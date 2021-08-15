import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/views/startup/startup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'flavor_config.dart';

const bool USE_EMULATOR = false;

void mainCommon(Flavor flavor) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (USE_EMULATOR) {
      await _connectToFirebaseEmulator();
    }

    setupLocator();
    // setupDialogUi();
    // setupBottomSheetUi();
    // setupSnackbarUi();
    // Logger.level = Level.verbose;

    runApp(MyApp());
  } catch (e) {
    print("ERROR: App main function failed with error: ${e.toString()}");
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: kAppName,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        home: StartUpView()
        //builder: (context, child) => child!,
        );
  }
}

Future _connectToFirebaseEmulator() async {
  final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  //final localHostString = "192.168.1.69";
  FirebaseFirestore.instance.settings = Settings(
    host: '$localHostString:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  await FirebaseAuth.instance.useEmulator('http://$localHostString:9099');
}
