import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/lifecycle_manager.dart';
import 'package:afkcredits/services/connectivity/connectivity_service.dart';
import 'package:afkcredits/ui/shared/setup_dialog_ui_view.dart';
import 'package:afkcredits/ui/shared/setup_snackbar_ui.dart';
import 'package:afkcredits/ui/views/startup/startup_view.dart';
import 'package:arkit_plugin/arkit_plugin.dart'
    show ARKitConfiguration, ARKitPlugin;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app_config_provider.dart';
import 'enums/connectivity_type.dart';
import 'notifications/notification_controller.dart';
import 'ui/shared/setup_bottom_sheet_ui.dart';

const bool USE_EMULATOR = false;

void mainCommon(Flavor flavor) async {
  try {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
    NotificationController().initializeLocalNotifications();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        print("received remote message with id: ${event.messageId}");
        try {
          if (event.data["category"] == "feedback") {
            StackedService.navigatorKey?.currentState?.pushNamed(
              Routes.feedbackView,
            );
          }
        } catch (e) {
          print("Error: Could not check category in data");
        }
      },
    );

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      print("FCM Token: $fcmToken");
    }

    // configure services that need settings dependent on flavor
    final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
    appConfigProvider.configure(flavor);
    print("==>> Running with flavor $flavor");

    if (!kIsWeb && Platform.isAndroid) {
      appConfigProvider.setIsARAvailable(false);
    } else {
      if (await ARKitPlugin.checkConfiguration(
              ARKitConfiguration.worldTracking) &&
          await ARKitPlugin.checkConfiguration(
              ARKitConfiguration.imageTracking)) {
        appConfigProvider.setIsARAvailable(true);
      } else {
        appConfigProvider.setIsARAvailable(false);
      }
    }

    runApp(MyApp());
  } catch (e) {
    print("ERROR: App main function failed with error: ${e.toString()}");
  }
}

class MyApp extends StatelessWidget {
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
                // color of app bar title
                headline6: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3),
              ),
            ),
            navigatorKey: StackedService.navigatorKey,
            onGenerateRoute: StackedRouter().onGenerateRoute,
            home: StartUpView()),
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");

  // Use this method to automatically convert the push data, in case you gonna use our data standard
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future _connectToFirebaseEmulator() async {
  final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';
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
    primary: kcPrimaryColor,
    minimumSize: Size(88, 45),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  );
}
