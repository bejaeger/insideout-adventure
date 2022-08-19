import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

class LayoutService {
  BehaviorSubject<bool> showBottomNavBarSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get showBottomNavBar => showBottomNavBarSubject.value;

  // BehaviorSubject<bool> isShowingQuestListSubject =
  //     BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> isShowingQuestListSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isShowingQuestList => isShowingQuestListSubject.value;

  BehaviorSubject<bool> isShowingExplorerAccountSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isShowingExplorerAccount => isShowingExplorerAccountSubject.value;

  BehaviorSubject<bool> isFadingOutOverlaySubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isFadingOutOverlay => isFadingOutOverlaySubject.value;

  BehaviorSubject<bool> isMovingCameraSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isMovingCamera => isMovingCameraSubject.value;

  BehaviorSubject<bool> isFadingOutQuestDetailsSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isFadingOutQuestDetails => isFadingOutQuestDetailsSubject.value;

  void setShowBottomNavBar(bool show) {
    showBottomNavBarSubject.add(show);
  }

  void setIsShowingQuestList(bool set) {
    isShowingQuestListSubject.add(set);
  }

  void setIsShowingExplorerAccount(bool set) {
    isShowingExplorerAccountSubject.add(set);
  }

  void setIsFadingOutOverlay(bool set) {
    isFadingOutOverlaySubject.add(set);
  }

  void setIsMovingCamera(bool set) {
    isMovingCameraSubject.add(set);
  }

  void setIsFadingOutQuestDetails(bool set) {
    isFadingOutQuestDetailsSubject.add(set);
  }
}
