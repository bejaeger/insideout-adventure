import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/notifications/notifications.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/string_utils.dart';

class ActiveScreenTimeViewModel extends BaseModel {
  // -----------------------------------
  // services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final log = getLogger('ActiveScreenTimeViewModel');

  // -----------------------------------
  // getters
  int? get screenTimeLeft => _screenTimeService.hasActiveScreenTime
      ? _screenTimeService.screenTimeLeftInSeconds
      : -1;
  ScreenTimeSession? get currentScreenTimeSession =>
      _screenTimeService.currentSession;

  // constructor
  // used to start screen time
  final int minutes;
  // used if previous screen time session was found
  final String? screenTimeSessionId;
  ActiveScreenTimeViewModel({required this.minutes, this.screenTimeSessionId});

  Future initialize() async {
    if (screenTimeSessionId != null) {
      // previous screen time session found on disk
      setBusy(true);

      // TODO: Streamline this and put business logic in service ?
      // TODO: -> maybe all in one function?

      // load screen time from firestore
      final ScreenTimeSession session = await _screenTimeService
          .loadActiveScreenTimeSession(sessionId: screenTimeSessionId!);

      // check status
      // -> if completed:
      if (session.status == ScreenTimeSessionStatus.completed) {
        _screenTimeService.handleScreenTimeOverEvent();
      } else {
        // -> if not completed
        // --> check if time is UP already?
        if (DateTime.now().difference(session.startedAt.toDate()).inMinutes >
            session.minutes) {
          await _screenTimeService.handleScreenTimeOverEvent();
        } else {
          // --> if NOT: create session with remaining minutes!
          _screenTimeService.continueScreenTime(
              session: session, callback: listenToTick);
        }
      }

      setBusy(false);
    } else {
      // start a screen time session
      ScreenTimeSession session = ScreenTimeSession(
        sessionId: "",
        uid: currentUser.uid,
        minutes: minutes,
        status: ScreenTimeSessionStatus.active,
        afkCredits: double.parse(screenTimeToCredits(minutes).toString()),
      );

      DateTime endDate = DateTime.now().add(Duration(minutes: minutes));

      // start screen time session
      _screenTimeService.startScreenTime(
          session: session, callback: listenToTick);

      // create permanent notification
      Notifications().createPermanentNotification(
          title: "Screen time until " + formatDateToShowTime(endDate),
          message: currentUser.fullName + " is using screen time");
      Notifications().createScheduledNotification(
          title: "Screen time is over!",
          message: currentUser.fullName + "'s screen time expired.",
          date: endDate);

      // TODO: Schedule a notification.
      // Notifications().createNotificationsTimesUp(message: "Your Time is Up");
      // stopScreenTimeAfterZero();
    }
  }

  // Future<void> stopScreenTimeAfterZero() async {
  //   //Notifications().createNotificationsTimesUp(message: "Your Time is Up");
  //   await Notifications().setNotificationsValues();
  //   _screenTimeService.stopScreenTime();
  //   Notifications()
  //       .dismissNotificationsByChannelKey(channelKey: 'base_channel');
  //   navigationService.back();
  //   notifyListeners();
  // }

  // functions
  Future stopScreenTime() async {
    //int counter = 1;

    dynamic result;
    if (screenTimeLeft! > 0) {
      result = await dialogService.showDialog(
          buttonTitle: "YES",
          cancelTitle: "NO",
          title: "Cancel Active Screen Time?",
          description: "There are " +
              screenTimeLeft.toString() +
              " seconds left."); //, mainButtonTitle: "CANCEL", )
    }
    if (result == null || result?.confirmed == true) {
      await Notifications().setNotificationsValues();
      final res = await _screenTimeService.stopScreenTime();
      if (res is String) {
        log.wtf("Screen time couldn't be stopped, error: $res");
      }
      await Notifications().dismissPermanentNotifications();
      await Notifications().dismissScheduledNotifications();
      String snackBarTitle = "";
      String snackBarMsg = "";
      if (res == true) {
        snackBarTitle = "Cancelled screentime. ";
        snackBarMsg = "No credits are deducted";
      }
      if (res == false) {
        snackBarTitle = "Stopped screentime";
        snackBarMsg = "Credits are deducted accordingly";
      }
      replaceWithHomeView();
      snackbarService.showSnackbar(
        title: snackBarTitle,
        message: snackBarMsg,
        duration: Duration(seconds: 1),
      );
    }
  }

  void listenToTick() {
    notifyListeners();
  }
}
