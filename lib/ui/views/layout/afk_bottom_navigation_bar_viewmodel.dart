import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/common_viewmodels/layout_template_viewmodel.dart';

/////////////////////////////////
/// ! DEPRECATED!!!!!

class AFKBottomNavigationBarViewModel
    extends CustomBottomBarLayoutTemplateViewModel {
  BottomNavBarIndex _currentIndex = BottomNavBarIndex.home;

  bool get isOnHome => _currentIndex == BottomNavBarIndex.home;
  bool get isOnMap => _currentIndex == BottomNavBarIndex.quest;
  bool get isOnGift => _currentIndex == BottomNavBarIndex.giftcard;
  bool get isOnAddMarkers => _currentIndex == BottomNavBarIndex.addmarkers;

  void onHomePressed() {
    clearStackAndNavigateToHomeView();
    _currentIndex = BottomNavBarIndex.home;
    notifyListeners();
  }

  void onGiftPressed() {
    navigationService.clearStackAndShow(Routes.giftCardView);
    _currentIndex = BottomNavBarIndex.giftcard;
    notifyListeners();
  }

  void onMarkersPressed() {
    navigationService.clearStackAndShow(Routes.addMarkersView);
    _currentIndex = BottomNavBarIndex.addmarkers;
    notifyListeners();
  }

  void onMapPressed() {
    //navigationService.clearStackAndShow(Routes.mapScreen);
    if (questService.hasActiveQuest == false) {
      navigationService.clearStackAndShow(Routes.mapOverviewView);
      _currentIndex = BottomNavBarIndex.quest;
    } else {
      // this is not functional, would need to add activeQuestView here most likely
      navigationService.clearStackAndShow(Routes.mapOverviewView);
      _currentIndex = BottomNavBarIndex.quest;
    }
    notifyListeners();
  }
}
