import 'package:awesome_notifications/awesome_notifications.dart';

import '../../../utils/utilities/utilities.dart';

class Notifications {
  Future<void> unlockedAchievement() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: createUniqueId(),
          channelKey: "base_channel",
          title:
              '${Emojis.lock_unlocked + Emojis.game_crystal_ball} Achievement was Unlocked!',
          body: "Managed To Unlock an Achievement"),
    );
  }
}
