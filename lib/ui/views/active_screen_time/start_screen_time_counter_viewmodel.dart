import 'dart:async';

import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class StartScreenTimeCounterViewModel extends BaseModel {
  final log = getLogger("StartScreenTimeCounterViewModel");

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
