import 'dart:async';
import 'dart:io';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ARObjectViewModel extends ActiveQuestBaseViewModel
    with MapStateControlMixin {
  Timer? timer;
  bool showHelpMessage = false;
  ARObjectViewModel() {
    startTimer();
  }

  // show help message after 5 seconds
  void startTimer() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (timer.tick == 8) {
          showHelpMessage = true;
          notifyListeners();
        }
      },
    );
  }

  @override
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
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
