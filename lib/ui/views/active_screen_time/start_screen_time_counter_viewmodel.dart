import 'dart:async';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class StartScreenTimeCounterViewModel extends BaseModel {
  // ------------------------------------------------
  // services
  final log = getLogger("StartScreenTimeCounterViewModel");

  // ----------------------------------------------
  // state
  int get counter => screenTimeService.counter;
  Timer? timer;

  void startCounter({required ScreenTimeSession session}) {
    screenTimeService.scheduledScreenTimeSession = session;
    if (timer == null) {
      timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) async {
          log.v("Fired listener");
          // could happen from lifecycle manager
          if (screenTimeService.scheduledScreenTimeSession == null) {
            resetStopWatch();
            return;
          }

          int tick = timer.tick;
          screenTimeService.counter = 10 - tick;
          notifyListeners();
          if (counter <= 0) {
            log.v("Replacing view with active screen time view");
            await start(session: session);
            // store unique ids for notifications to keep track
          }
        },
      );
    }
  }

  void cancel() {
    resetStopWatch();
    popView();
  }

  Future startNow({required ScreenTimeSession session}) async {
    session = session.copyWith(startedAt: DateTime.now());
    start(session: session);
  }

  Future start({required ScreenTimeSession session}) async {
    session = await screenTimeService.startScreenTime(
        session: session, callback: () {});
    // await NotificationsService()
    //     .maybeCreatePermanentIsUsingScreenTimeNotification(session: session);
    // await NotificationsService()
    //     .maybeCreateScheduledIsUsingScreenTimeNotification(session: session);
    resetStopWatch();
    replaceWithActiveScreenTimeView(session: session);
  }

  void resetStopWatch() {
    screenTimeService.counter = 10;
    screenTimeService.scheduledScreenTimeSession = null;
    timer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}
