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

  BehaviorSubject<bool> isShowingQuestDetailsSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isShowingQuestDetails => isShowingQuestDetailsSubject.value;

  BehaviorSubject<bool> isShowingARViewSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isShowingARView => isShowingARViewSubject.value;

  BehaviorSubject<bool> isMovingCameraSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isMovingCamera => isMovingCameraSubject.value;

  void setShowBottomNavBar(bool show) {
    showBottomNavBarSubject.add(show);
  }

  // bool isShowingQuestDetails = false;
  // void setIsShowQinguestDetails(bool showQuestDetailsIn) {
  //   isShowingQuestDetails = showQuestDetailsIn;
  // }

  void switchIsShowingQuestDetails() {
    isShowingQuestDetailsSubject.add(!isShowingQuestDetailsSubject.value);
  }

  void setIsShowingQuestDetails(bool set) {
    isShowingQuestDetailsSubject.add(set);
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
}
