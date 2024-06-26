import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class AvatarAndEffectsOnMapViewModel extends BaseModel {
  final void Function() startAnimation;
  final void Function() stopAnimation;
  AvatarAndEffectsOnMapViewModel(
      {required this.startAnimation, required this.stopAnimation});

  final MapStateService mapStateService = locator<MapStateService>();
  final log = getLogger("AvatarOnMapViewModel");

  bool get isAvatarView => mapStateService.isAvatarView;
  bool get isFadingOutOverlay => layoutService.isFadingOutOverlay;
  bool get isMovingCamera => layoutService.isMovingCamera;
  bool get isFadingOutQuestDetails => layoutService.isFadingOutQuestDetails;
  bool get hasActiveQuest => activeQuestService.hasActiveQuest;
  bool get showAvatar =>
      (!((isShowingQuestDetails ||
              !isAvatarView ||
              isFadingOutOverlay ||
              isMovingCamera) &&
          !hasActiveQuest)) &&
      isAvatarView;

  bool prevValue = false;
  bool isAnimating = true;
  StreamSubscription? isFingerOnScreenListener;
  StreamSubscription? isMovingCameraSubscription;

  void listenToData() async {
    if (isFingerOnScreenListener == null) {
      isFingerOnScreenListener = mapStateService.isFingerOnScreenSubject.listen(
        (value) {
          if (value != prevValue) {
            if (value) {
              log.d("STOP the lottie animation");
              stopAnimation();
              isAnimating = false;
            } else {
              log.d("START the lottie animation");
              startAnimation();
              isAnimating = true;
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
    if (isMovingCameraSubscription == null) {
      isMovingCameraSubscription = layoutService.isMovingCameraSubject.listen(
        (value) {
          if (value) {
            log.v("STOP the lottie animation");
            stopAnimation();
            isAnimating = false;
          } else {
            log.v("START the lottie animation");
            startAnimation();
            isAnimating = true;
          }
          notifyListeners();
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    isFingerOnScreenListener?.cancel();
    isFingerOnScreenListener = null;
    isMovingCameraSubscription?.cancel();
    isMovingCameraSubscription = null;
  }
}
