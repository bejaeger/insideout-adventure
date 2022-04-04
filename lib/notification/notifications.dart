import 'package:awesome_notifications/awesome_notifications.dart';
import '../../../utils/utilities/utilities.dart';

class Notifications {
  Future<void> unlockedAchievement({required String message}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: createUniqueId(),
          channelKey: "base_channel",
          title:
              '${Emojis.lock_unlocked + Emojis.game_crystal_ball} Achievement was Unlocked!',
          body: message),
    );
  }

  Future<void> dismissNotificationsByChannelKey(String channelKey) async {
    await AwesomeNotifications().dismissNotificationsByChannelKey(channelKey);
  }

  // ON BADGE METHODS, NULL CHANNEL SETS THE GLOBAL COUNTER

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
}
