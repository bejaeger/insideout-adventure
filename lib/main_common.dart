import 'dart:io';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/lifecycle_manager.dart';
import 'package:afkcredits/services/connectivity/connectivity_service.dart';
import 'package:afkcredits/ui/shared/setup_dialog_ui_view.dart';
import 'package:afkcredits/ui/shared/setup_snackbar_ui.dart';
import 'package:afkcredits/ui/views/startup/startup_view.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'enums/connectivity_type.dart';
import 'app_config_provider.dart';
import 'notifications/notification_controller.dart';
import 'ui/shared/setup_bottom_sheet_ui.dart';
import 'package:flutter/services.dart';
import 'firebase_options_dev.dart' as dev;

// import 'firebase_options_prod.dart' as prod;

import 'package:flutter/foundation.dart' show kIsWeb;

// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart'
//     show ArCoreController;

const bool USE_EMULATOR = false;

void mainCommon(Flavor flavor) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // initialize firebase app via index.html
    if (!kIsWeb) {
      await Firebase.initializeApp(
          options: dev.DefaultFirebaseOptions.currentPlatform);
      //: prod.DefaultFirebaseOptions.currentPlatform);
/*       await Firebase.initializeApp(
          options: flavor == Flavor.dev
              ? dev.DefaultFirebaseOptions.currentPlatform
              : prod.DefaultFirebaseOptions.currentPlatform); */
    }

    if (USE_EMULATOR) {
      await _connectToFirebaseEmulator();
    }
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: kcPrimaryColor,
        systemNavigationBarColor: kcBlackHeadlineColor,
      ),
    );

    setupLocator();
    setupDialogUi();
    setupSnackbarUi();
    setupBottomSheetUi();
    // initialize notifications
    NotificationController().initializeLocalNotifications();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      print("FCM Token: $fcmToken");
    }

    // configure services that need settings dependent on flavor
    final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
    appConfigProvider.configure(flavor);
    print("==>> Running with flavor $flavor");

    // if (!kIsWeb &&
    //     Platform.isAndroid &&
    //     await ArCoreController.checkArCoreAvailability() &&
    //     await ArCoreController.checkIsArCoreInstalled()) {
    //   appConfigProvider.setIsARAvailable(true);
    // } else {
    appConfigProvider.setIsARAvailable(false);
    // }

    runApp(MyApp());
  } catch (e) {
    print("ERROR: App main function failed with error: ${e.toString()}");
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: StreamProvider<ConnectivityType>(
        create: (context) =>
            ConnectivityService().connectionStatusController.stream,
        initialData: ConnectivityType.Offline,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: kAppName,
            theme: ThemeData(
              elevatedButtonTheme:
                  ElevatedButtonThemeData(style: getRaisedButtonStyle()),
              primaryColor: kcPrimaryColor,
              appBarTheme: AppBarTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  color: kcPrimaryColor,
                  elevation: 5,
                  toolbarHeight: 80,
                  centerTitle: true),
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: kcPrimaryColor,
                  ),
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
      ),
    );
  }
}

// Declared as global, outside of any class
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");

  // Use this method to automatically convert the push data, in case you gonna use our data standard
  AwesomeNotifications().createNotificationFromJsonData(message.data);
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
    primary: kcPrimaryColor,
    minimumSize: Size(88, 45),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  );
}
