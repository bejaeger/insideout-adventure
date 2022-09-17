import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../../utils/utilities/utilities.dart';
import 'package:afkcredits/app/app.logger.dart';

class Notifications {
  final log = getLogger("Notifications");

  Future<int> createPermanentNotification(
      {required String title, required String message}) async {
    int id = createUniqueId();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        groupKey: id.toString(),
        channelKey: kPermanentNotificationKey,
        title: '${Emojis.time_hourglass_not_done} ' + title,
        body: message,
        locked: true,
        autoDismissible: false,
      ),
    );
    return id;
  }

  Future<int> createScheduledNotification({
    required String title,
    required String message,
    required DateTime date,
    required ScreenTimeSession session,
  }) async {
    int id = createUniqueId();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        payload: {"uid": session.uid, "sessionId": session.sessionId},
        id: id,
        groupKey: id.toString(),
        channelKey: kScheduledNotificationChannelKey,
        title: "\u26A0 " + title,
        body: message,
        category: NotificationCategory.Alarm,
        locked: false,
      ),
      schedule: NotificationCalendar.fromDate(
        date: date,
        preciseAlarm: true,
      ),
      actionButtons: [
        NotificationActionButton(
            key: kScheduledNotificationActionKey, label: "OK")
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
        message: session.userName + " is using screen time");
    return id;
  }

  Future<int> createScheduledIsUsingScreenTimeNotification(
      {required ScreenTimeSession session}) async {
    DateTime endDate =
        session.startedAt.toDate().add(Duration(minutes: session.minutes));
    int id = await Notifications().createScheduledNotification(
      title: "Screen time expired!",
      message: session.userName + "'s screen time expired.",
      date: endDate,
      session: session,
    );
    return id;
  }
}
