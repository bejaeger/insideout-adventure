import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

class LayoutService {
  BehaviorSubject<bool> showBottomNavBarSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get showBottomNavBar => showBottomNavBarSubject.value;

  // true when quest list is shown
  BehaviorSubject<bool> isShowingQuestListSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isShowingQuestList => isShowingQuestListSubject.value;

  // true if explorer account is shown
  BehaviorSubject<bool> isShowingExplorerAccountSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isShowingExplorerAccount => isShowingExplorerAccountSubject.value;

  // true if credits overlay (top right credits button) is shown
  BehaviorSubject<bool> isShowingCreditsOverlaySubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isShowingCreditsOverlay => isShowingCreditsOverlaySubject.value;

  // Fade out for when user enters AR view or Marker collection animation!
  BehaviorSubject<bool> isFadingOutOverlaySubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isFadingOutOverlay => isFadingOutOverlaySubject.value;

  BehaviorSubject<bool> isMovingCameraSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isMovingCamera => isMovingCameraSubject.value;

  // When quest details are faded out again
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

  void setIsShowingCreditsOverlay(bool set) {
    isShowingCreditsOverlaySubject.add(set);
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
