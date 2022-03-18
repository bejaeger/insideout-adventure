import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

class LayoutService with ReactiveServiceMixin {
  LayoutService() {
    listenToReactiveValues([_isShowingQuestDetails]);
  }

  BehaviorSubject<bool> showBottomNavBarSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get showBottomNavBar => showBottomNavBarSubject.value;

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

  ReactiveValue<bool> _isShowingQuestDetails = ReactiveValue<bool>(false);
  bool get isShowingQuestDetails => _isShowingQuestDetails.value;
  void setIsShowQinguestDetails(bool show) {
    _isShowingQuestDetails.value = show;
  }
}
