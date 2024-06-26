import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/services/local_secure_storage_service.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/utilities.dart';

class NotificationsService {
  final log = getLogger("NotificationsService");
  final LocalSecureStorageService _localStorageService =
      locator<LocalSecureStorageService>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();

  Future createPermanentNotification(
      {required String title,
      required String message,
      required int id,
      required ScreenTimeSession session}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        payload: getStringMapFromSession(session: session),
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
  }

  Future createScheduledNotification({
    required String title,
    required String message,
    required DateTime date,
    required ScreenTimeSession session,
    required int id,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        payload:
            // set completed here already so we can react to it in the notification received action function.
            getStringMapFromSession(
          session: session.copyWith(status: ScreenTimeSessionStatus.completed),
        ),
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
  }

  Future maybeCreatePermanentIsUsingScreenTimeNotification(
      {required ScreenTimeSession session}) async {
    // AwesomeNotifications().listScheduledNotifications();
    final notificationId = await _localStorageService.getFromDisk(
        key: getPermanentNotificationKeyFromSessionId(session.sessionId));
    if (notificationId != null) {
      log.w(
          "Permanent is using screen time notification already active. Not adding another one.");
      return;
    }
    DateTime endDate =
        getEndDate(startedAt: session.startedAt, minutes: session.minutes);
    int id = createUniqueId();
    await _localStorageService.saveToDisk(
        key: getPermanentNotificationKeyFromSessionId(session.sessionId),
        value: id.toString());
    await NotificationsService().createPermanentNotification(
      title: "Screen time until " + formatDateToShowTime(endDate),
      message:
          session.userName + " is using ${session.minutes} min screen time",
      id: id,
      session: session,
    );
  }

  Future maybeCreateScheduledIsUsingScreenTimeNotification(
      {required ScreenTimeSession session}) async {
    final notificationId = await _localStorageService.getFromDisk(
        key: getScheduledNotificationKeyFromSessionId(session.sessionId));
    if (notificationId != null) {
      log.w(
          "Screen time expiry notification already scheduled. Not adding another one.");
      return;
    }
    DateTime endDate =
        getEndDate(startedAt: session.startedAt, minutes: session.minutes);
    int id = createUniqueId();
    await _localStorageService.saveToDisk(
        key: getScheduledNotificationKeyFromSessionId(session.sessionId),
        value: id.toString());
    await NotificationsService().createScheduledNotification(
      title: session.userName + "'s screen time expired",
      message: session.userName +
          "'s ${session.minutes} min screen time is over. Let your child collect more credits for more screen time :)",
      date: endDate,
      id: id,
      session: session,
    );
  }

  DateTime getEndDate({required dynamic startedAt, required int minutes}) {
    late DateTime endDate;
    if (startedAt is DateTime) {
      endDate = startedAt.add(Duration(minutes: minutes));
    } else {
      endDate = startedAt.toDate().add(Duration(minutes: minutes));
    }
    return endDate;
  }

  Future<void> dismissPermanentNotification({required String sessionId}) async {
    String key = getPermanentNotificationKeyFromSessionId(sessionId);
    String? id = await _localStorageService.getFromDisk(key: key);
    if (id != null) {
      await AwesomeNotifications().dismissNotificationsByGroupKey(id);
      await _localStorageService.deleteFromDisk(key: key);
    }
  }

  Future<void> dismissScheduledNotification({required String sessionId}) async {
    String key = getScheduledNotificationKeyFromSessionId(sessionId);
    String? id = await _localStorageService.getFromDisk(key: key);
    if (id != null) {
      await AwesomeNotifications().dismissNotificationsByGroupKey(id);
      await _localStorageService.deleteFromDisk(key: key);
    }
  }

  Future<void> cancelScheduledNotification({required String sessionId}) async {
    String key = getScheduledNotificationKeyFromSessionId(sessionId);
    String? id = await _localStorageService.getFromDisk(key: key);
    if (id != null) {
      await AwesomeNotifications().cancelNotificationsByGroupKey(id);
      await _localStorageService.deleteFromDisk(key: key);
    }
  }

  Future pushToken({required String uid, required List<String>? tokens}) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      if ((tokens != null && tokens.length > 1) ||
          (tokens != null && tokens.length == 1 && tokens[0] != token)) {
        _firestoreApi.updateTokenForUser(uid: uid, token: token);
      }
    } else {
      log.w("No fcm token could be retrieved");
    }
    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) =>
        _firestoreApi.updateTokenForUser(uid: uid, token: token));
  }
}
