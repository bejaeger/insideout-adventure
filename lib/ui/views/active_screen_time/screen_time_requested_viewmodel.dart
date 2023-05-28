import 'dart:async';

import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class ScreenTimeRequestedViewModel extends BaseModel {
  final log = getLogger("StartScreenTimeCounterViewModel");

  StreamSubscription? screenTimeSubscription;

  Future listenToData({required ScreenTimeSession session}) async {
    setBusy(true);
    await screenTimeService.uploadScreenTimeRequest(session: session);

    if (screenTimeSubscription == null) {
      screenTimeSubscription = screenTimeService
          .getScreenTimeStream(sessionId: session.sessionId)
          .listen(
        (session) async {
          if (session.status == ScreenTimeSessionStatus.active) {
            session = session.copyWith(startedAt: DateTime.now());
            navToActiveScreenTimeView(session: session);
            return;
          }
          if (session.status == ScreenTimeSessionStatus.denied) {
            await dialogService.showDialog(
                title: "Sorry",
                description:
                    "Your parents did not allow this screen time session");
            popView();
          }
        },
      );
    } else {
      log.v("Already listening to screen time");
    }
    setBusy(false);
  }

  void cancel({required ScreenTimeSession session}) {
    screenTimeSubscription?.cancel();
    screenTimeSubscription = null;
    screenTimeService.removeScreenTimeSession(session: session);
    popView();
  }

  @override
  void dispose() {
    super.dispose();
    screenTimeSubscription?.cancel();
    screenTimeSubscription = null;
  }
}
