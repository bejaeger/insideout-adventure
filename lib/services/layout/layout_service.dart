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

  BehaviorSubject<bool> isShowingARViewSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isShowingARView => isShowingARViewSubject.value;

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

  void setIsShowingARView(bool set) {
    isShowingARViewSubject.add(set);
  }

  void setIsMovingCamera(bool set) {
    isMovingCameraSubject.add(set);
  }

  void setIsFadingOutQuestDetails(bool set) {
    isFadingOutQuestDetailsSubject.add(set);
  }
}
