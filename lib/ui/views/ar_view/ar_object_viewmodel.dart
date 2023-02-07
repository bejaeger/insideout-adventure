import 'dart:async';
import 'dart:io';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class ARObjectViewModel extends BaseModel
    with MapStateControlMixin {
  ARObjectViewModel() {
    startTimerForPotentialHelpMessage();
  }

  final log = getLogger("ARObjectViewModel");

  Timer? timer;
  bool showHelpMessage = false;

  void startTimerForPotentialHelpMessage() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (timer.tick == 8) { // shows help message after X seconds
          showHelpMessage = true;
          notifyListeners();
        }
      },
    );
  }

  Future handleCollectedArObjectEvent() async {
    log.i("Handling collected ar object event");
    // showing the dialog will make the app crash in android!
    if (!kIsWeb && Platform.isIOS) {
      await showCollectedMarkerDialog();
    }
    popArView(result: true);
  }

  void popArView({dynamic result}) async {
    layoutService.setIsFadingOutOverlay(false);
    popViewReturnValue(result: result);
    mapStateService.restoreBeforeArCameraPositionAndAnimate(
        moveInsteadOfAnimate: true);
  }

  @override
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }

  @override
  Future maybeStartQuest(
      {required Quest? quest, void Function()? notifyParentCallback}) {
    // TODO: implement maybeStartQuest
    throw UnimplementedError();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}
