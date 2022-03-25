import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

class LayoutService with ReactiveServiceMixin {
  LayoutService() {
    listenToReactiveValues([_isShowingQuestDetails]);
  }

  BehaviorSubject<bool> showBottomNavBarSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get showBottomNavBar => showBottomNavBarSubject.value;

  // BehaviorSubject<bool> isShowingQuestListSubject =
  //     BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> isShowingQuestListSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get isShowingQuestList => isShowingQuestListSubject.value;

  ReactiveValue<bool> _isShowingQuestDetails = ReactiveValue<bool>(false);
  bool get isShowingQuestDetails => _isShowingQuestDetails.value;

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
    _isShowingQuestDetails.value = !_isShowingQuestDetails.value;
  }

  void setIsShowingQuestDetails(bool set) {
    _isShowingQuestDetails.value = set;
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
