import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class StartScreenTimeCounterViewModel extends BaseModel {
  // ------------------------------------------------
  // services
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  final log = getLogger("StartScreenTimeCounterViewModel");

  // ----------------------------------------------
  // state
  int counter = 10;

  void startCounter({required ScreenTimeSession session}) {
    _stopWatchService.listenToSecondTime(
      callback: (int tick) {
        counter = 10 - tick;
        notifyListeners();
        if (counter == 0) {
          log.v("Replacing view with active screen time view");
          resetStopWatch();
          replaceWithActiveScreenTimeView(session: session);
        } else {
          log.v("Fired listener");
        }
      },
    );
  }

  void cancel() {
    resetStopWatch();
    popView();
  }

  void resetStopWatch() {
    _stopWatchService.resetTimer();
  }
}
