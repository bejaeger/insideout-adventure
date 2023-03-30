import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationController {
  Future<void> initializeLocalNotifications() async {
    //Notificaitons Package
    await AwesomeNotifications().initialize(
      kDefaultNotificationIconPath,
      [
        NotificationChannel(
          channelKey: kScheduledNotificationChannelKey,
          channelName: kScheduledNotificationChannelName,
          channelDescription:
              'Scheduled notification when screen time is expired.',
          defaultColor: kcPrimaryColor,
          importance: NotificationImportance.Max,
          criticalAlerts: true,
          enableVibration: true,
          playSound: true,
          //channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: kPermanentNotificationKey,
          channelName: kPermanentNotificationName,
          channelDescription:
              'Basic notifications for ongoing screen time and quests.',
          defaultColor: kcPrimaryColor,
          importance: NotificationImportance.High,
          //channelShowBadge: true,
          locked: true,
        ),
        NotificationChannel(
          channelKey: kUpdatedScreenTimeNotificationKey,
          channelName: kUpdatedScreenTimeNotificationChannelName,
          channelDescription: 'Basic notifications for updated screen times.',
          defaultColor: kcPrimaryColor,
          importance: NotificationImportance.High,
          //channelShowBadge: true,
          locked: true,
        ),
      ],
      debug: true,
    );
  }

  Future<void> initializeNotificationsEventListeners() async {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized
    WidgetsFlutterBinding.ensureInitialized();
    print("==>> on action received method");

    // if this is an expired screen time session alarm we navigate to the active screen time session
    // to show statistics
    if (receivedAction.payload != null) {
      Map<String, String?> payload = receivedAction.payload!;
      if (payload.containsKey("uid") && payload.containsKey("sessionId")) {
        ScreenTimeSession? session;
        try {
          session = getSessionFromStringMap(payload: payload);
        } catch (e) {
          print("==>> Error when getting the screen time session: $e");
          return;
        }
        await StackedService.navigatorKey?.currentState?.pushNamed(
            Routes.startUpScreenTimeView,
            arguments:
                StartUpScreenTimeViewArguments(screenTimeSession: session));
      }
    }
  }

  static String _toSimpleEnum(NotificationLifeCycle lifeCycle) =>
      lifeCycle.toString().split('.').last;

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    print("==>> onNotificationDisplayedMethod");
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    print("==>> onNotificationCreatedMethod");
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print("==>> onDismissActionReceivedMethod");
  }

  Future<String?> getTimeZone() async {
    return await AwesomeNotifications().getLocalTimeZoneIdentifier();
  }

  Future<void> dismissPermanentNotifications() async {
    await AwesomeNotifications()
        .dismissNotificationsByChannelKey(kPermanentNotificationKey);
  }

  Future<void> dismissUpdatedScreenTimeNotifications() async {
    await AwesomeNotifications()
        .dismissNotificationsByChannelKey(kUpdatedScreenTimeNotificationKey);
  }

  Future<void> dismissScheduledNotifications() async {
    await AwesomeNotifications()
        .dismissNotificationsByChannelKey(kScheduledNotificationChannelKey);
  }

  Future<void> cancelNotifications({required int? id}) async {
    if (id == null) return;
    await AwesomeNotifications().cancelNotificationsByGroupKey(id.toString());
  }

  Future<void> dismissNotificationsByChannelKey(
      {required String channelKey}) async {
    await AwesomeNotifications().dismissNotificationsByChannelKey(channelKey);
  }

  Future<int> getBadgeIndicator() async {
    int amount = await AwesomeNotifications().getGlobalBadgeCounter();
    return amount;
  }

  Future<void> setBadgeIndicator(int amount) async {
    await AwesomeNotifications()
        .setGlobalBadgeCounter((amount - 1).clamp(0, 10000));
  }

  Future<int> incrementBadgeIndicator() async {
    return await AwesomeNotifications().incrementGlobalBadgeCounter();
  }

  Future<void> setNotificationsValues() async {
    final currentBadgeCounter = await getBadgeIndicator();
    //Set the Global Counter to a New Value
    setBadgeIndicator(currentBadgeCounter);
  }
}
