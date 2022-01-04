import 'dart:io';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/services/connectivity/connectivity_service.dart';
import 'package:afkcredits/ui/shared/setup_dialog_ui.dart';
import 'package:afkcredits/ui/shared/setup_snackbar_ui.dart';
import 'package:afkcredits/ui/views/startup/startup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'enums/connectivity_type.dart';
import 'flavor_config.dart';
import 'ui/shared/setup_bottom_sheet_ui.dart';

import 'firebase_options_dev.dart' as dev;

const bool USE_EMULATOR = false;

void mainCommon(Flavor flavor) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: dev.DefaultFirebaseOptions.currentPlatform);
    if (USE_EMULATOR) {
      await _connectToFirebaseEmulator();
    }

    setupLocator();
    setupDialogUi();
    setupSnackbarUi();
    setupBottomSheetUi();
    // setupBottomSheetUi();
    // setupSnackbarUi();
    // Logger.level = Level.verbose;

    // configure services that need settings dependent on flavor
    final FlavorConfigProvider flavorConfigProvider =
        locator<FlavorConfigProvider>();
    flavorConfigProvider.configure(flavor);
    print("==>> Running with flavor $flavor");

    runApp(MyApp());
  } catch (e) {
    print("ERROR: App main function failed with error: ${e.toString()}");
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityType>(
      create: (context) =>
          ConnectivityService().connectionStatusController.stream,
      initialData: ConnectivityType.Offline,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: kAppName,
          theme: ThemeData(
            elevatedButtonTheme:
                ElevatedButtonThemeData(style: getRaisedButtonStyle()),
            primaryColor: kPrimaryColor,
            appBarTheme: AppBarTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                color: kPrimaryColor,
                elevation: 5,
                toolbarHeight: 80,
                centerTitle: true),
            primaryIconTheme: IconThemeData(color: Colors.white),
            primaryTextTheme: TextTheme(
              headline6: TextStyle(
                  // color of app bar title
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.3),
            ),
          ),
          navigatorKey: StackedService.navigatorKey,
          onGenerateRoute: StackedRouter().onGenerateRoute,

          ///////////////////////////
          /// Use the following with the AFK Custom bottom nav bar
          // builder: (context, child) => LayoutTemplateView(childView: child!),

          /////////////////////////////
          /// Use this when persistent nav bar is used
          home: StartUpView()),
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

ButtonStyle getRaisedButtonStyle() {
  return ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    // primary: darkTurquoise,
    primary: kPrimaryColor,
    minimumSize: Size(88, 45),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  );
}
