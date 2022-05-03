import 'package:awesome_notifications/awesome_notifications.dart';
import '../../../utils/utilities/utilities.dart';

class Notifications {
  Future<void> createNotifications({required String message}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: "base_channel",
        title: '${Emojis.time_alarm_clock + Emojis.game_crystal_ball}',
        body: message,
        category: NotificationCategory.Reminder,
        //  bigPicture: kAFKCreditsLogoPath,
      ),
    );
  }

  Future<void> createNotificationsTimesUp({required String message}) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 20, //1,
        channelKey: "time_up_channel",
        //notificationLayout: NotificationLayout.BigPicture,
        category: NotificationCategory.Reminder,
        // bigPicture: kClockMelted,
        title: '${Emojis.time_alarm_clock} Unfortunately Your Time is Up!',
        body: message,
        //  bigPicture: kAFKCreditsLogoPath,

        //timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
    );
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
