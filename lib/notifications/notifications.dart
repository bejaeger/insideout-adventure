import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../../utils/utilities/utilities.dart';
import 'package:afkcredits/app/app.logger.dart';

class Notifications {
  final log = getLogger("Notifications");

  Future<void> createPermanentNotification(
      {required String title, required String message}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: kPermanentNotificationKey,
        title: '${Emojis.time_alarm_clock} ' + title,
        body: message,
        locked: true,
        autoDismissible: false,
      ),
    );
  }

  // ? NOT USED AT THE MOMENT
  Future<void> createUpdatedScreenTimeNotification(
      {required String title, required String message}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        displayOnForeground: true, // just update the other notification
        displayOnBackground: true,
        id: createUniqueId(),
        channelKey: kUpdatedScreenTimeNotificationKey,
        title: '${Emojis.time_alarm_clock} ' + title,
        body: message,
        locked: true,
        category: NotificationCategory.StopWatch,
        autoDismissible: false,
      ),
    );
  }

  Future<void> createScheduledNotification(
      {required String title,
      required String message,
      required DateTime date}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
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
        ]);
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

  Future<void> dismissNotificationsByChannelKey(
      {required String channelKey}) async {
    await AwesomeNotifications().dismissNotificationsByChannelKey(channelKey);
  }

  Future<int> getBadgeIndicator() async {
    int amount = await AwesomeNotifications().getGlobalBadgeCounter();
    return amount;
  }

  Future<void> setBadgeIndicator(int amount) async {
    await AwesomeNotifications().setGlobalBadgeCounter(amount - 1);
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
