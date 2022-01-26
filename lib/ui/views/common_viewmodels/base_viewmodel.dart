import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/payments/transfers_history_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/active_distance_estimate_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_qrcode_search/active_qrcode_search_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_viewmodel.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/purchased_gift_cards_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';
// The Basemodel
// All our ViewModels inherit from this class so
// put everything here that needs to be available throughout the
// entire App

class BaseModel extends BaseViewModel {
  final NavigationService navigationService = locator<NavigationService>();
  final UserService userService = locator<UserService>();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final QuestService questService = locator<QuestService>();
  final DialogService dialogService = locator<DialogService>();
  final BottomSheetService bottomSheetService = locator<BottomSheetService>();
  final TransfersHistoryService transfersHistoryService =
      locator<TransfersHistoryService>();
  final LayoutService layoutService = locator<LayoutService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  final GiftCardService _giftCardService = locator<GiftCardService>();
  final GeolocationService geolocationService = locator<GeolocationService>();
  final QuestTestingService _questTestingService = locator<QuestTestingService>();

  User get currentUser => userService.currentUser;
  UserStatistics get currentUserStats => userService.currentUserStats;
  bool get isSuperUser => userService.isSuperUser;

  final baseModelLog = getLogger("BaseModel");
  bool get hasActiveQuest => questService.hasActiveQuest;
  // only access this
  ActivatedQuest get activeQuest => questService.activatedQuest!;
  ActivatedQuest get previouslyFinishedQuest =>
      questService.previouslyFinishedQuest!;
  ActivatedQuest? get activeQuestNullable => questService.activatedQuest;
  String? seconds;
  String? hours;
  String? minutes;

  String get getActiveHours => hours!;
  String get getActiveMinutes => minutes!;
  String? get getActiveSeconds => seconds!;

  String get getHourMinuteSecondsTime =>
      _stopWatchService.secondsToHourMinuteSecondTime(activeQuest.timeElapsed);

  bool? canVibrate;

  // void setTimer() {
  //   //Clock Timer
  //   final timerStream = _stopWatchService.stopWatchStream();

  //   _timerSubscription = timerStream.listen((int time) {
  //     hours = ((time / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
  //     minutes = ((time / 60) % 60).floor().toString().padLeft(2, '0');
  //     seconds = (time % 60).floor().toString().padLeft(2, '0');
  //   });
  //   _stopWatchService.setTimerStreamSubscription(
  //       timerSubscription: _timerSubscription!);
  //   setBusy(false);
  //   notifyListeners();
  // }

  int get numMarkersCollected =>
      activeQuest.markersCollected.where((element) => element == true).length;

  Future clearServiceData({bool logOutFromFirebase = true}) async {
    questService.clearData();
    _giftCardService.clearData();
    await userService.handleLogoutEvent(logOutFromFirebase: logOutFromFirebase);
    transfersHistoryService.clearData();
    geolocationService.clearData();
    _questTestingService.resetSettings();
  }

  void unregisterViewModels() {
    // unregister all singleton viewmodels when logging out
    // TODO: remove data from viewmodels on loggin!

    // if (locator.isRegistered<ActiveTreasureLocationSearchQuestViewModel>()) {
    //   locator.unregister<ActiveTreasureLocationSearchQuestViewModel>();
    // }
    // if (locator.isRegistered<ActiveDistanceEstimateQuestViewModel>()) {
    //   locator.unregister<ActiveDistanceEstimateQuestViewModel>();
    // }
    // if (locator.isRegistered<ActiveQrCodeSearchViewModel>()) {
    //   locator.unregister<ActiveQrCodeSearchViewModel>();
    // }
    // if (locator.isRegistered<PurchasedGiftCardsViewModel>()) {
    //   locator.unregister<PurchasedGiftCardsViewModel>();
    // }
  }

  Future logout() async {
    // TODO: Check that there is no active quest present!
    clearServiceData();
    unregisterViewModels();
    navigationService.clearStackAndShow(Routes.loginView);
  }

  Future setShowBottomNavBar(bool show) async {
    if (show == true) {
      await Future.delayed(Duration(milliseconds: 150));
    }
    //layoutService.setShowBottomNavBar(show);
  }

  Future startQuestMain(
      {required Quest quest,
      Future Function(int)? periodicFuncFromViewModel}) async {
    try {
      // if (quest.type == QuestType.VibrationSearch && startFromMap) {
      //   await navigateToVibrationSearchView();
      // }

      /// Once The user Click on Start a Quest. It is her/him to new Page
      /// Differents Markers will Display as Part of the quest as well The App showing the counting of the
      /// Quest.
      final isQuestStarted = await questService.startQuest(
          quest: quest,
          uids: [currentUser.uid],
          periodicFuncFromViewModel: periodicFuncFromViewModel);

      // this will also change the MapViewModel to show the ActiveQuestView
      if (isQuestStarted is String) {
        await dialogService.showDialog(
            title: "Sorry could not start the quest",
            description: isQuestStarted);
        return false;
      }
      return true;
    } catch (e) {
      baseModelLog.e("Could not start quest, error thrown: $e");
      rethrow;
    }
  }

  bool hasEnoughSponsoring({required Quest? quest}) {
    if (quest == null) {
      baseModelLog.e(
          "Attempted to check whether sponsoring is enough for quest that is null!");
      return false;
    }
    return quest.afkCredits <= currentUserStats.availableSponsoring;
  }

  ////////////////////////////////////////
  // Navigation and dialogs
  void navigateBack() {
    navigationService.back();
  }

  void showNotImplementedSnackbar() {
    snackbarService.showSnackbar(
        title: "Not yet implemented.",
        message: "I know... it's sad",
        duration: Duration(seconds: 2));
  }

  Future<bool> showAdminDialogAndGetResponse() async {
    bool adminMode = true;
    dynamic response = await dialogService.showDialog(
        title: "You are in admin mode!",
        description:
            "Do you want to continue with admin mode (to see qr codes, ...) or normal user mode?",
        cancelTitle: "User Mode",
        buttonTitle: "Admin Mode");
    if (response?.confirmed == true) {
      adminMode = true;
    } else {
      adminMode = false;
    }
    return adminMode;
  }

  Future clearStackAndNavigateToHomeView() async {
    await navigationService.clearStackAndShow(
        Routes.bottomBarLayoutTemplateView,
        arguments:
            BottomBarLayoutTemplateViewArguments(userRole: currentUser.role));
  }

  Future replaceWithHomeView() async {
    await navigationService.replaceWith(Routes.bottomBarLayoutTemplateView,
        arguments:
            BottomBarLayoutTemplateViewArguments(userRole: currentUser.role));
  }

  Future replaceWithMainView({required BottomNavBarIndex index}) async {
    await navigationService.replaceWith(Routes.bottomBarLayoutTemplateView,
        arguments: BottomBarLayoutTemplateViewArguments(
            userRole: currentUser.role, initialBottomNavBarIndex: index));
  }

  Future clearStackAndNavigateToMainView(
      {required BottomNavBarIndex index}) async {
    await navigationService.clearStackAndShow(
        Routes.bottomBarLayoutTemplateView,
        arguments: BottomBarLayoutTemplateViewArguments(
            userRole: currentUser.role, initialBottomNavBarIndex: index));
  }

  Future showGenericInternalErrorDialog() async {
    return await dialogService.showDialog(
        title: "Sorry",
        description:
            "An internal error occured on our side. Sorry, please try again later.");
  }

  Future handleSuccessfullyFinishedQuest() async {
    if (activeQuestNullable?.status == QuestStatus.success) {
      baseModelLog.i("Found that quest was successfully finished!");

      try {
        await questService.handleSuccessfullyFinishedQuest();
        return true;
      } catch (e) {
        if (e is QuestServiceException) {
          baseModelLog.e(e);
          await dialogService.showDialog(
              title: e.prettyDetails, buttonTitle: 'Ok');
          replaceWithMainView(index: BottomNavBarIndex.quest);
          questService.setUIDeadTime(false);
        } else if (e is CloudFunctionsApiException) {
          baseModelLog.e(e);
          await dialogService.showDialog(
              title: e.prettyDetails, buttonTitle: 'Ok');
          questService.setUIDeadTime(false);
        } else {
          baseModelLog.e("Unknown error occured from evaluateAndFinishQuest");
          questService.setUIDeadTime(false);
          setBusy(false);
          rethrow;
        }
        setBusy(false);
        return false;
      }
    } else {
      baseModelLog.w(
          "Active quest either null or not successfull. Either way, this function should not have been called!");
    }
  }

  //////////////////////////////////////////
  /// Clean-up
  @override
  void dispose() {
    super.dispose();
  }
}
