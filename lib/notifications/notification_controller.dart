import 'dart:developer';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController {
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();

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
          importance: NotificationImportance.High,
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
    AwesomeNotifications().displayedStream.listen((notification) async {
      // if a scheduled notification is shown, we can remove the permanent notifications!
      if (notification.channelKey == kScheduledNotificationChannelKey) {
        AwesomeNotifications()
            .dismissNotificationsByChannelKey(kPermanentNotificationKey);
        await Future.delayed(Duration(milliseconds: 500));
        _screenTimeService.handleScreenTimeOverEvent();
      }
    });

    AwesomeNotifications().actionStream.listen((notification) async {
      // if a scheduled notification is shown, we can remove the permanent notifications!

      print("==>> LISTEN TO ACTION STREAM");
      if (notification.channelKey == kScheduledNotificationChannelKey) {
        print("==>> button key pressed");
        print("==>> NOW WE CAN DO SOME NAVIGATION");
        // AwesomeNotifications()
        //     .dismissNotificationsByChannelKey(kPermanentNotificationKey);
        // await Future.delayed(Duration(milliseconds: 500));
        // _screenTimeService.handleScreenTimeOverEvent();
      }
    });
  }

  // this code is needed for new version of awesome notifications
  // Only after at least the action method is set, the notification events are delivered
  // AwesomeNotifications().setListeners(
  //     onActionReceivedMethod: NotificationController.onActionReceivedMethod,
  //     onNotificationCreatedMethod:
  //         NotificationController.onNotificationCreatedMethod,
  //     onNotificationDisplayedMethod:
  //         NotificationController.onNotificationDisplayedMethod,
  //     onDismissActionReceivedMethod:
  //         NotificationController.onDismissActionReceivedMethod);

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized
    WidgetsFlutterBinding.ensureInitialized();

    print("==>> on action received method");
    // bool isSilentAction = receivedAction.actionType == ActionType.SilentAction;

    // SilentBackgroundAction runs on background thread and cannot show
    // UI/visual elements
    // if (receivedAction.actionType != ActionType.SilentBackgroundAction)
    //   log("message");
/*       Fluttertoast.showToast(
        msg:
            '${isSilentAction ? 'Silent action' : 'Action'} received on ${_toSimpleEnum(receivedAction.actionLifeCycle!)}',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: isSilentAction ? Colors.blueAccent : Colors.teal,
        gravity: ToastGravity.BOTTOM,
      ); */
  }

  static String _toSimpleEnum(NotificationLifeCycle lifeCycle) =>
      lifeCycle.toString().split('.').last;

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    print("==>> onNotificationDisplayedMethod");
/*     Fluttertoast.showToast(
        msg:
            'Notification displayed on ${_toSimpleEnum(receivedNotification.displayedLifeCycle!)}',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue,
        gravity: ToastGravity.BOTTOM); */
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    print("==>> onNotificationCreatedMethod");

/*     Fluttertoast.showToast(
        msg:
            'Notification created on ${_toSimpleEnum(receivedNotification.createdLifeCycle!)}',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        gravity: ToastGravity.BOTTOM); */
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print("==>> onDismissActionReceivedMethod");

/*     Fluttertoast.showToast(
        msg:
            'Notification dismissed on ${_toSimpleEnum(receivedAction.dismissedLifeCycle!)}',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.orange,
        gravity: ToastGravity.BOTTOM); */
  }

  Future<String?> getTimeZone() async {
    return await AwesomeNotifications().getLocalTimeZoneIdentifier();
  }
}