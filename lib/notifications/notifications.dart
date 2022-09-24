import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../../utils/utilities/utilities.dart';
import 'package:afkcredits/app/app.logger.dart';

class Notifications {
  final log = getLogger("Notifications");

  Future<int> createPermanentNotification(
      {required String title,
      required String message,
      ScreenTimeSession? session}) async {
    int id = createUniqueId();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        payload:
            session == null ? null : getStringMapFromSession(session: session),
        groupKey: id.toString(),
        channelKey: kPermanentNotificationKey,
        title: '${Emojis.time_hourglass_not_done} ' + title,
        body: message,
        locked: true,
        // notificationLayout: NotificationLayout.ProgressBar,
        // progress: 70,
        category: NotificationCategory.Status,
        autoDismissible: false,
      ),
      actionButtons: [
        NotificationActionButton(
            key: kScheduledNotificationActionKey, label: "Close")
      ],
    );
    return id;
  }

  Future<int> createScheduledNotification({
    required String title,
    required String message,
    required DateTime date,
    ScreenTimeSession? session,
  }) async {
    int id = createUniqueId();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        payload:
            session == null ? null : getStringMapFromSession(session: session),
        id: id,
        groupKey: id.toString(),
        channelKey: kScheduledNotificationChannelKey,
        title: "\u26A0 " + title,
        body: message,
        criticalAlert: true,
        wakeUpScreen: true,
        category: NotificationCategory.Alarm,
        locked: false,
        //fullScreenIntent: true,
      ),
      schedule: NotificationCalendar.fromDate(
        date: date,
        preciseAlarm: true,
      ),
      actionButtons: [
        NotificationActionButton(
            key: kScheduledNotificationActionKey, label: "Show details")
      ],
    );
    return id;
  }

  Future<int> createPermanentIsUsingScreenTimeNotification(
      {required ScreenTimeSession session}) async {
    DateTime endDate =
        session.startedAt.toDate().add(Duration(minutes: session.minutes));
    int id = await Notifications().createPermanentNotification(
      title: "Screen time until " + formatDateToShowTime(endDate),
      message:
          session.userName + " is using ${session.minutes} min screen time",
      session: session,
    );
    return id;
  }

  Future<int> createScheduledIsUsingScreenTimeNotification(
      {required ScreenTimeSession session}) async {
    DateTime endDate =
        session.startedAt.toDate().add(Duration(minutes: session.minutes));
    int id = await Notifications().createScheduledNotification(
      title: "Screen time expired!",
      message:
          session.userName + "'s ${session.minutes} min screen time expired.",
      date: endDate,
      session: session,
    );
    return id;
  }
}
