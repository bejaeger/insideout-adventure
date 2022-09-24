import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class AvatarAndEffectsOnMapViewModel extends BaseModel {
  // -----------------------------------------
  // services
  final MapStateService mapStateService = locator<MapStateService>();
  final log = getLogger("AvatarOnMapViewModel");

  // -----------------------------------------
  // getters
  int get characterNumber => mapStateService.characterNumber;
  bool get isAvatarView => mapStateService.isAvatarView;

  bool get isFadingOutOverlay => layoutService.isFadingOutOverlay;
  bool get isMovingCamera => layoutService.isMovingCamera;
  bool get isFadingOutQuestDetails => layoutService.isFadingOutQuestDetails;
  bool get hasActiveQuest => activeQuestService.hasActiveQuest;
  bool get show =>
      (!((isShowingQuestDetails ||
              !isAvatarView ||
              isFadingOutOverlay ||
              isMovingCamera) &&
          !hasActiveQuest)) &&
      isAvatarView;

  // -----------------------------------------
  // constructor with callbacks from animation controller
  final void Function() startAnimation;
  final void Function() stopAnimation;
  AvatarAndEffectsOnMapViewModel(
      {required this.startAnimation, required this.stopAnimation});

  // -----------------------------------------
  // state
  bool prevValue = false;
  StreamSubscription? isFingerOnScreenListener;

  // -----------------------------------------
  // functions
  void listenToData() async {
    if (isFingerOnScreenListener == null) {
      isFingerOnScreenListener = mapStateService.isFingerOnScreenSubject.listen(
        (value) {
          if (value != prevValue) {
            if (value) {
              log.v("STOP the lottie animation");
              stopAnimation();
            } else {
              log.v("START the lottie animation");
              startAnimation();
            }
            // TODO: not sure if this is needed! TEST
            notifyListeners();
          }
          prevValue = value;
        },
      );
    } else {
      log.w(
          "isFingerOnScreen subject already listened to. Not listening again");
    }
  }

  @override
  void dispose() {
    super.dispose();
    isFingerOnScreenListener?.cancel();
    isFingerOnScreenListener = null;
  }
}