import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/services/payments/transfers_history_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:stacked_services/stacked_services.dart';

mixin NavigationMixin {
  final _navigationService = locator<NavigationService>();
  final _questService = locator<QuestService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final GiftCardService _giftCardService = locator<GiftCardService>();
  final TransfersHistoryService transfersHistoryService =
      locator<TransfersHistoryService>();
  final _userService = locator<UserService>();

  void navToAdminHomeView({required UserRole role}) {
    //navigationService.replaceWith(Routes.homeView);
    _navigationService.replaceWith(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(userRole: role),
    );
  }

  void navToUpdatingQuestView() {
    //navigationService.replaceWith(Routes.homeView);
    _navigationService.navigateTo(
      Routes.updatingQuestView,
      //arguments: BottomBarLayoutTemplateViewArguments(userRole: role),
    );
  }

  void navToExplorerCreateAccount({required UserRole role}) {
    _navigationService.replaceWith(Routes.createAccountView,
        arguments: CreateAccountViewArguments(role: role));
  }

  void navToSponsorCreateAccount({required UserRole role}) {
    _navigationService.replaceWith(Routes.createAccountView,
        arguments: CreateAccountViewArguments(role: role));
  }

  void navToAdminCreateAccount({required UserRole role}) {
    _navigationService.replaceWith(Routes.createAccountView,
        arguments: CreateAccountViewArguments(role: role));
  }

  void navToLoginView() {
    _navigationService.replaceWith(Routes.loginView);
  }

  void navToMapView({required UserRole role}) {
    _navigationService.navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
          userRole: role,
          initialBottomNavBarIndex: BottomNavBarIndex.quest,
          questViewIndex: QuestViewType.map),
    );
  }

  void navBackToPreviousView() {
    _navigationService.back();
  }

  Future logout() async {
    // TODO: Check that there is no active quest present!
    _questService.clearData();
    _geolocationService.clearData();
    _giftCardService.clearData();
    await _userService.handleLogoutEvent(logOutFromFirebase: true);
    transfersHistoryService.clearData();
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  void navToQuestsOfSpecificTypeView(
      {required QuestType type, required UserRole role}) {
    // Use the below to have the nav bottom bar visible!
    _navigationService.navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
        userRole: role,
        initialBottomNavBarIndex: BottomNavBarIndex.quest,
        questViewIndex: QuestViewType.singlequest,
        questType: type,
      ),
    );
  }
}
