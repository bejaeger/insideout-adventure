import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/settings/user_settings.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveScreenTimeViewModel extends BaseModel {
  ScreenTimeSession?
      session; // not null if previous screen time session was found
  ActiveScreenTimeViewModel({required this.session});

  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  final log = getLogger('ActiveScreenTimeViewModel');

  ScreenTimeSession? get currentScreenTimeSession =>
      _screenTimeService.getActiveScreenTimeInMemory(uid: session?.uid);
  ScreenTimeSession? get expiredScreenTime =>
      _screenTimeService.getExpiredScreenTimeSessionInMemory(
          uid: session?.uid, sessionId: session?.sessionId);
  UserSettings get currentUserSettings => userService.currentUserSettings;

  String get childName => session != null ? session!.userName : "";
  String get childId => session != null ? session!.uid : "";

  int? screenTimeLeft;
  bool justStartedListeningToScreenTime = false;
  Timer? _timer;

  Future initialize() async {
    setBusy(true);

    if (session != null &&
        session?.status == ScreenTimeSessionStatus.notStarted) {
      log.i("screen time session will be started");

      session = await _screenTimeService.startScreenTime(
          session: session!, callback: listenToTick);
      justStartedListeningToScreenTime = true;
    }

    bool continueExistingScreenTime =
        session != null && session?.status == ScreenTimeSessionStatus.active;
    if (continueExistingScreenTime) {
      log.i(
          "screen time session has started or is active and will be continued");
      int screenTimeLeftInSecondsPreset =
          screenTimeService.getTimeLeftInSeconds(session: session!);
      screenTimeLeft = screenTimeLeftInSecondsPreset;
      notifyListeners();

      _stopWatchService.forceListenToSecondTime(
        callback: (int tick) {
          screenTimeLeft = screenTimeLeftInSecondsPreset - tick;
          notifyListeners();
          log.v("Fired listener");
        },
      );
    }

    if (session == null) {
      log.wtf("session is null, cannot navigate to active screen time view");
      popView();
      return;
    }
    setBusy(false);
  }

  Future stopScreenTime({required ScreenTimeSession? session}) async {
    if (session == null) return;
    if (screenTimeLeft == null) return;
    dynamic result;
    if (screenTimeLeft! > 0) {
      result = await dialogService.showDialog(
          buttonTitle: "YES",
          cancelTitle: "NO",
          title: "Cancel Active Screen Time?",
          description:
              "There are " + secondsToMinuteTime(screenTimeLeft) + "in left.");
    }
    setBusy(true);
    if (result == null || result?.confirmed == true) {
      final res = await _screenTimeService.stopScreenTime(session: session);
      if (res is String) {
        log.wtf("Screen time couldn't be stopped, error: $res");
      }
      String snackBarTitle = "";
      String snackBarMsg = "";
      if (res == false) {
        snackBarTitle = "Cancelled screentime ";
        snackBarMsg = "No credits are being deducted";
      }
      if (res == true) {
        snackBarTitle = "Stopped screentime";
        snackBarMsg = "Credits are deducted accordingly";
      }
      resetStopWatch();
      replaceWithHomeView();
      snackbarService.showSnackbar(
        title: snackBarTitle,
        message: snackBarMsg,
        duration: Duration(seconds: 2),
      );
    }
    setBusy(false);
  }

  DateTime getStartedAt() {
    if (expiredScreenTime!.startedAt is Timestamp) {
      return expiredScreenTime!.startedAt.toDate();
    } else {
      return expiredScreenTime!.startedAt;
    }
  }

  void resetStopWatch() {
    _timer?.cancel();
  }

  void cancelOnlyActiveScreenTimeSubjectListeners({required String uid}) {
    screenTimeService.cancelOnlyActiveScreenTimeSubjectListeners(uid: uid);
  }

  void listenToTick() {
    notifyListeners();
  }

  void resetActiveScreenTimeView({required String uid}) {
    resetStopWatch();
    cancelOnlyActiveScreenTimeSubjectListeners(uid: uid);
    clearStackAndNavigateToHomeView();
  }

  @override
  dispose() {
    super.dispose();
    log.v("Resetting stop watch timer");
    // this is important but will stop the active screen time listener
    // when we navigate from outside the app inside the app when
    // the active screen time was shown also last time
    _stopWatchService.resetTimer();
  }
}
