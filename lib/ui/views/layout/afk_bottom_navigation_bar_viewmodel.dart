import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/common_viewmodels/layout_template_viewmodel.dart';

class AFKBottomNavigationBarViewModel extends LayoutTemplateViewModel {
  BottomNavigationBarIndex _currentIndex = BottomNavigationBarIndex.home;

  bool get isOnHome => _currentIndex == BottomNavigationBarIndex.home;
  bool get isOnMap => _currentIndex == BottomNavigationBarIndex.map;
  bool get isOnGift => _currentIndex == BottomNavigationBarIndex.giftcard;

  void onHomePressed() {
    clearStackAndNavigateToHomeView();
    _currentIndex = BottomNavigationBarIndex.home;
    notifyListeners();
  }

  void onGiftPressed() {
    clearStackAndNavigateToHomeView();
    navigationService.clearStackAndShow(Routes.giftCardView);
    _currentIndex = BottomNavigationBarIndex.giftcard;
    notifyListeners();
  }

  void onMapPressed() {
    //navigationService.clearStackAndShow(Routes.mapScreen);
    if (checkRunningQuest == false) {
      navigationService.clearStackAndShow(Routes.mapView);
      _currentIndex = BottomNavigationBarIndex.map;
    } else {
      navigationService.clearStackAndShow(Routes.activeQuestView);
      _currentIndex = BottomNavigationBarIndex.map;
    }

    notifyListeners();
  }
}
