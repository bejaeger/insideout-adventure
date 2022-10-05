import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/active_screen_time/start_screen_time_counter_view.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

mixin NavigationMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final QuestService _questService = locator<QuestService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final UserService _userService = locator<UserService>();
  final LayoutService _layoutService = locator<LayoutService>();
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();

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

  void navToSingleMarkerView() {
    //navigationService.replaceWith(Routes.homeView);
    _navigationService.navigateTo(
      Routes.singleMarkerView,
    );
  }

  void navToQrcodeView() {
    //navigationService.replaceWith(Routes.homeView);
    _navigationService.navigateTo(
      Routes.qRCodeView,
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

  void navToOnboardingScreens() {
    _navigationService.navigateTo(Routes.onBoardingScreensView);
  }

  void navToFeedbackView() {
    _navigationService.navigateTo(Routes.feedbackView);
  }

  Future replaceWithExplorerHomeView(
      {bool showBewareDialog = false,
      bool showNumberQuestsDialog = false,
      ScreenTimeSession? screenTimeSession}) async {
    await _navigationService.replaceWith(Routes.explorerHomeView,
        arguments: ExplorerHomeViewArguments(
            showBewareDialog: showBewareDialog,
            showNumberQuestsDialog: showNumberQuestsDialog,
            screenTimeSession: screenTimeSession));
  }

  Future replaceWithParentHomeView(
      {ScreenTimeSession? screenTimeSession}) async {
    await _navigationService.replaceWith(Routes.parentHomeView,
        arguments:
            ParentHomeViewArguments(screenTimeSession: screenTimeSession));
  }

  ////////////////////////////////////////
  // Navigation and dialogs
  void popView() {
    _navigationService.back();
  }

  void popViewReturnNull() {
    _navigationService.back(result: null);
  }

  void popViewReturnValue({dynamic result}) {
    _navigationService.back(result: result);
  }

  void navToParentMapView() {
    _navigationService.navigateTo(Routes.parentMapView);
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

  void navToQuestOverView() {
    //SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
    _navigationService.navigateTo(Routes.questsOverviewView);
    //});
  }

  void navToCreateQuest({bool fromMap = false}) {
    _navigationService.navigateTo(Routes.createQuestView,
        arguments: CreateQuestViewArguments(fromMap: fromMap));
    //});
  }

  Future popUntilMapView() async {
    await _navigationService.clearTillFirstAndShow(Routes.parentMapView);
  }

  void navBackToPreviousView() {
    _navigationService.back();
  }

  Future logout() async {
    // TODO: Check that there is no active quest present!
    _questService.clearData();
    _geolocationService.clearData();
    await _userService.handleLogoutEvent(logOutFromFirebase: true);
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

  void showQuestListOverlay() {
    _layoutService.setIsShowingQuestList(true);
  }

  void showExplorerAccountOverlay() {
    _layoutService.setIsShowingExplorerAccount(true);
  }

  void showCreditsOverlay() {
    _layoutService.setIsShowingCreditsOverlay(true);
  }

  void removeQuestListOverlay() {
    _layoutService.setIsShowingQuestList(false);
  }

  void removeCreditsOverlay() {
    _layoutService.setIsShowingCreditsOverlay(false);
  }

  void removeExplorerAccountOverlay() {
    _layoutService.setIsShowingExplorerAccount(false);
  }

  void maybeRemoveQuestListOverlay() {
    if (_layoutService.isShowingQuestList) {
      _layoutService.setIsShowingQuestList(false);
    }
  }

  void maybeRemoveExplorerAccountOverlay() {
    if (_layoutService.isShowingExplorerAccount) {
      _layoutService.setIsShowingExplorerAccount(false);
    }
  }

  void navToSingleChildView({required String uid}) async {
    await _navigationService.navigateTo(Routes.singleChildStatView,
        arguments: SingleChildStatViewArguments(uid: uid));
  }

  void replaceWithSingleChildView({required String uid}) async {
    await _navigationService.replaceWith(Routes.singleChildStatView,
        arguments: SingleChildStatViewArguments(uid: uid));
  }

  Future navToArObjectView(bool isCoins) async {
    if (!kIsWeb && Platform.isAndroid) {
      return await _navigationService.navigateTo(Routes.aRObjectAndroidView,
          arguments: ARObjectAndroidViewArguments(isCoins: isCoins));
    }
    if (!kIsWeb && Platform.isIOS) {
      return await _navigationService.navigateTo(Routes.aRObjectIosView,
          arguments: ARObjectIosViewArguments(isCoins: isCoins));
    }
  }

  Future navToSelectScreenTimeView(
      {String? childId, bool isParentAccount = true}) async {
    final session =
        _screenTimeService.getActiveScreenTimeInMemory(uid: childId);
    if (session != null) {
      navToActiveScreenTimeView(session: session);
    } else {
      await _navigationService.navigateTo(Routes.selectScreenTimeView,
          arguments: SelectScreenTimeViewArguments(
              childId: isParentAccount ? childId : null));
    }
  }

  Future navToCreateChildAccount() async {
    await _navigationService.navigateTo(Routes.createExplorerView);
  }

  Future navToActiveScreenTimeView({required ScreenTimeSession session}) async {
    await _navigationService.navigateTo(
      Routes.activeScreenTimeView,
      arguments: ActiveScreenTimeViewArguments(
        session: session,
      ),
    );
  }

  Future replaceWithActiveScreenTimeView(
      {required ScreenTimeSession session}) async {
    await _navigationService.replaceWith(
      Routes.activeScreenTimeView,
      arguments: ActiveScreenTimeViewArguments(
        session: session,
      ),
    );
  }

  Future navToScreenTimeCounterView(
      {required ScreenTimeSession session}) async {
    await _navigationService.navigateTo(
      Routes.startScreenTimeCounterView,
      arguments: StartScreenTimeCounterViewArguments(
        session: session,
      ),
    );
  }
}
