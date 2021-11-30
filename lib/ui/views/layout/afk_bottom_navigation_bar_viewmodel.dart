import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/common_viewmodels/layout_template_viewmodel.dart';

class AFKBottomNavigationBarViewModel extends LayoutTemplateViewModel {
  BottomNavigationBarIndex _currentIndex = BottomNavigationBarIndex.home;

  bool get isOnHome => _currentIndex == BottomNavigationBarIndex.home;
  bool get isOnMap => _currentIndex == BottomNavigationBarIndex.map;
  bool get isOnGift => _currentIndex == BottomNavigationBarIndex.giftcard;
  bool get isOnAddMarkers =>
      _currentIndex == BottomNavigationBarIndex.addmarkers;

  void onHomePressed() {
    clearStackAndNavigateToHomeView();
    _currentIndex = BottomNavigationBarIndex.home;
    notifyListeners();
  }

  void onGiftPressed() {
    navigationService.clearStackAndShow(Routes.giftCardView);
    _currentIndex = BottomNavigationBarIndex.giftcard;
    notifyListeners();
  }

  void onMarkersPressed() {
    navigationService.clearStackAndShow(Routes.addMarkersView);
    _currentIndex = BottomNavigationBarIndex.addmarkers;
    notifyListeners();
  }

  void onMapPressed() {
    //navigationService.clearStackAndShow(Routes.mapScreen);
    if (questService.hasActiveQuest == false) {
      navigationService.clearStackAndShow(Routes.mapView);
      _currentIndex = BottomNavigationBarIndex.map;
    } else {
      navigationService.clearStackAndShow(Routes.activeQuestView);
      _currentIndex = BottomNavigationBarIndex.map;
    }
    notifyListeners();
  }
}
