import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_ui_style.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/gamification/gamification_service.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/payments/transfers_history_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
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
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();
  final QRCodeService qrCodeService = locator<QRCodeService>();
  final GamificationService gamificationService =
      locator<GamificationService>();

  final baseModelLog = getLogger("BaseModel");

  // ------------------------------------------------------
  // getters
  User get currentUser => userService.currentUser;
  UserStatistics get currentUserStats => userService.currentUserStats;
  bool get isSuperUser => userService.isSuperUser;
  bool get isAdminMaster => userService.isAdminMaster;
  bool get useSuperUserFeatures => _questTestingService.isPermanentUserMode
      ? false
      : userService.isSuperUser;
  int? get currentGPSAccuracy => geolocationService.currentGPSAccuracy;
  int get currentPositionDistanceFilter =>
      geolocationService.currentPositionDistanceFilter;
  String? get gpsAccuracyInfo => geolocationService.gpsAccuracyInfo;
  bool get listenedToNewPosition => geolocationService.listenedToNewPosition;

  // --------------------------------------------------
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

  bool validatingMarker = false;

  int get numMarkersCollected =>
      activeQuest.markersCollected.where((element) => element == true).length;

  Future clearServiceData({bool logOutFromFirebase = true}) async {
    questService.clearData();
    _giftCardService.clearData();
    await userService.handleLogoutEvent(logOutFromFirebase: logOutFromFirebase);
    transfersHistoryService.clearData();
    geolocationService.clearData();
    _questTestingService.maybeReset();
    gamificationService.clearData();
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

  setListenedToNewPosition(bool set) {
    if (useSuperUserFeatures) {
      geolocationService.setListenedToNewPosition(set);
    }
  }

  Future setShowBottomNavBar(bool show) async {
    if (show == true) {
      await Future.delayed(Duration(milliseconds: 150));
    }
    //layoutService.setShowBottomNavBar(show);
  }

  bool hasEnoughSponsoring({required Quest? quest}) {
    if (quest == null) {
      baseModelLog.e(
          "Attempted to check whether sponsoring is enough for quest that is null!");
      return false;
    }
    // TODO: Pay attention to this here
    // return quest.afkCredits <= currentUserStats.availableSponsoring;
    // TODO: For now we always assume we have enough funding
    return true;
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

  Future showAdminDialogAndGetResponse() async {
    dynamic adminMode = true;
    dynamic response = await dialogService.showDialog(
        title: "You are in admin mode!",
        description:
            "Do you want to continue with admin mode (to see qr codes, ...) or normal user mode?",
        cancelTitle: "User Mode",
        buttonTitle: "Admin Mode",
        barrierDismissible: true);
    if (response?.confirmed == true) {
      adminMode = true;
    } else if (response?.confirmed == false) {
      adminMode = false;
    } else {
      return "Dismissed";
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

  // TODO: MAYBE this can go into the base_viewmodel as it's needed also in other screens!
  Future scanQrCode() async {
    if (await maybeCheatAndCollectNextMarker()) {
      return;
    }

    // navigate to qr code view, validate results in quest service, and continue
    MarkerAnalysisResult result = await navigateToQrcodeViewAndReturnResult();
    if (result.isEmpty) {
      baseModelLog.wtf("The object QuestQRCodeScanResult is empty!");
      return;
    }
    if (result.hasError) {
      baseModelLog.e("Error occured: ${result.errorMessage}");
      await dialogService.showDialog(
        title: "Cannot collect marker!",
        description: result.errorMessage!,
      );
      return;
    }
    return await handleMarkerAnalysisResult(result);
  }

  Future maybeCheatAndCollectNextMarker() async {
    if (useSuperUserFeatures) {
      final admin = await showAdminDialogAndGetResponse();
      if (admin == true) {
        // collect next marker automatically!
        AFKMarker? nextMarker = questService.getNextMarker();
        await questService.analyzeMarker(marker: nextMarker);
        final result = MarkerAnalysisResult.marker(marker: nextMarker);
        await handleMarkerAnalysisResult(result);
        return true;
      }
    }
    return false;
  }

  Future<MarkerAnalysisResult> navigateToQrcodeViewAndReturnResult() async {
    final marker = await navigationService.navigateTo(Routes.qRCodeView);
    if (useSuperUserFeatures && marker != null) {
      final adminMode = await showAdminDialogAndGetResponse();
      if (adminMode == true) {
        String qrCodeString =
            qrCodeService.getQrCodeStringFromMarker(marker: marker);
        await navigationService.navigateTo(Routes.qRCodeView,
            arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
        return MarkerAnalysisResult.empty();
      }
    }
    validatingMarker = true;
    MarkerAnalysisResult scanResult =
        await questService.analyzeMarker(marker: marker);
    validatingMarker = false;
    return scanResult;
  }

  ////////////////////////////
  // can be overriden?
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) async {
    baseModelLog.i("Handling marker analysis result");
    if (!hasActiveQuest &&
        (result.quests == null ||
            (result.quests != null && result.quests!.length == 0))) {
      await dialogService.showDialog(
          title:
              "The scanned marker is not a start of a quest. Please go to the starting point");
    }
    if (result.quests != null && result.quests!.length > 0) {
      // TODO: Handle case where more than one quest is returned here!
      // For now, just start first quest!
      if (!hasActiveQuest) {
        baseModelLog.i("Found quests associated to the scanned start marker.");
        await displayQuestBottomSheet(
          quest: result.quests![0],
          startMarker: result.quests![0].startMarker,
        );
      }
    }
    return false;
  }

  Future displayQuestBottomSheet(
      {required Quest quest, AFKMarker? startMarker}) async {
    SheetResponse? sheetResponse = await bottomSheetService.showCustomSheet(
        variant: BottomSheetType.questInformation,
        title: quest.name,
        enterBottomSheetDuration: Duration(milliseconds: 300),
        // exitBottomSheetDuration: Duration(milliseconds: 1),
        // curve: Curves.easeInExpo,
        // curve: Curves.linear,
        // barrierColor: Colors.black45,
        description: quest.description,
        mainButtonTitle: quest.type == QuestType.DistanceEstimate
            ? "Go to Quest"
            : "Go to Quest",
        secondaryButtonTitle: "Close",
        data: quest);
    if (sheetResponse?.confirmed == true) {
      baseModelLog
          .i("Looking at details of quest OR starting quest immediately");
      questService.getQuestUIStyle(quest: quest) == QuestUIStyle.map
          ? await navigateToActiveQuestUI(quest: quest)
          : await navigateToActiveQuestUI(quest: quest);
    }
  }

  Future navigateToActiveQuestUI({required Quest quest}) async {
    baseModelLog.i("Navigating to view with currently active quest");
    if (quest.type == QuestType.TreasureLocationSearch) {
      await navigationService.navigateTo(
          Routes.activeTreasureLocationSearchQuestView,
          arguments:
              ActiveTreasureLocationSearchQuestViewArguments(quest: quest));
    } else if (quest.type == QuestType.DistanceEstimate) {
      await navigationService.navigateTo(Routes.activeDistanceEstimateQuestView,
          arguments: ActiveDistanceEstimateQuestViewArguments(quest: quest));
    } else if (quest.type == QuestType.QRCodeSearch ||
        quest.type == QuestType.QRCodeSearchIndoor ||
        quest.type == QuestType.QRCodeHunt ||
        quest.type == QuestType.GPSAreaHunt) {
      await navigationService.navigateTo(Routes.activeQrCodeSearchView,
          arguments: ActiveQrCodeSearchViewArguments(quest: quest));
    } else if (quest.type == QuestType.QRCodeHike ||
        quest.type == QuestType.GPSAreaHike ||
        quest.type == QuestType.Hunt) {
      await navigationService.navigateTo(Routes.activeMapQuestView,
          arguments: ActiveMapQuestViewArguments(quest: quest));
    }
  }

  Future openSuperUserSettingsDialog() async {
    await dialogService.showCustomDialog(variant: DialogType.SuperUserSettings);
    setListenedToNewPosition(false);
    notifyListeners();
  }

  //////////////////////////////////////////
  /// Clean-up
  @override
  void dispose() {
    super.dispose();
  }
}
