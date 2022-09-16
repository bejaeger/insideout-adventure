import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/gamification/gamification_service.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/permission_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/active_quest_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';
// The Basemodel
// All our ViewModels inherit from this class so
// put everything here that needs to be available throughout the
// entire App

class BaseModel extends BaseViewModel with NavigationMixin {
  final NavigationService navigationService = locator<NavigationService>();
  final UserService userService = locator<UserService>();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final QuestService questService = locator<QuestService>();
  final ActiveQuestService activeQuestService = locator<ActiveQuestService>();
  final DialogService dialogService = locator<DialogService>();
  final BottomSheetService bottomSheetService = locator<BottomSheetService>();
  final LayoutService layoutService = locator<LayoutService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  final GeolocationService geolocationService = locator<GeolocationService>();
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();
  final QRCodeService qrCodeService = locator<QRCodeService>();
  final GamificationService gamificationService =
      locator<GamificationService>();
  final ScreenTimeService screenTimeService = locator<ScreenTimeService>();
  final PermissionService _permissionService = locator<PermissionService>();

  final baseModelLog = getLogger("BaseModel");

  // ------------------------------------------------------
  // getters
  User get currentUser => userService.currentUser;
  User? get currentUserNullable => userService.currentUserNullable;
  UserStatistics get currentUserStats => userService.currentUserStats;
  bool get isSuperUser => userService.isSuperUser;
  bool get isParentAccount => currentUser.role == UserRole.sponsor;
  bool get isAdminMaster => userService.isAdminMaster;
  bool get useSuperUserFeatures => _questTestingService.isPermanentUserMode
      ? false
      : userService.isSuperUser;
  int? get currentGPSAccuracy => geolocationService.currentGPSAccuracy;
  int get currentPositionDistanceFilter =>
      geolocationService.currentPositionDistanceFilter;
  String? get gpsAccuracyInfo => geolocationService.gpsAccuracyInfo;
  bool get listenedToNewPosition => geolocationService.listenedToNewPosition;
  Position? get userLocation => geolocationService.getUserLivePositionNullable;

  // layout
  bool get isShowingQuestDetails =>
      (activeQuestService.selectedQuest != null) ||
      activeQuestService.previouslyFinishedQuest != null;
  bool get isShowingQuestList => layoutService.isShowingQuestList;
  bool get isShowingExplorerAccount => layoutService.isShowingExplorerAccount;
  bool get isShowingCreditsOverlay => layoutService.isShowingCreditsOverlay;
  bool get isFadingOutOverlay => layoutService.isFadingOutOverlay;
  bool get isMovingCamera => layoutService.isMovingCamera;
  bool get isFadingOutQuestDetails => layoutService.isFadingOutQuestDetails;

  // -----------------------------------------------
  // gamification system
  int currentLevel({num? lifetimeEarnings}) {
    return gamificationService.getCurrentLevel(
        lifetimeEarnings: lifetimeEarnings);
  }

  int get creditsToNextLevel => gamificationService.getCreditsToNextLevel();
  int get creditsForNextLevel => gamificationService.getCreditsForNextLevel();
  double get percentageOfNextLevel =>
      gamificationService.getPercentageOfNextLevel();
  String get currentLevelName => gamificationService.getCurrentLevelName();

  // --------------------------------------------------
  bool get hasSelectedQuest => activeQuestService.hasSelectedQuest;
  Quest? get selectedQuest => activeQuestService.selectedQuest;
  bool get hasActiveQuest => activeQuestService.hasActiveQuest;
  // only access this
  ActivatedQuest get activeQuest => activeQuestService.activatedQuest!;
  ActivatedQuest? get previouslyFinishedQuest =>
      activeQuestService.previouslyFinishedQuest;
  ActivatedQuest? get activeQuestNullable => activeQuestService.activatedQuest;

  String get getHourMinuteSecondsTime =>
      _stopWatchService.secondsToHourMinuteSecondTime(activeQuest.timeElapsed);

  bool? canVibrate;

  bool validatingMarker = false;

  int get numMarkersCollected =>
      activeQuest.markersCollected.where((element) => element == true).length;
  bool get isScreenTimeActive =>
      userService.supportedExplorerScreenTimeSessionsActive.length != 0;
  List<ScreenTimeSession> get childScreenTimeSessionsActive =>
      userService.supportedExplorerScreenTimeSessionsActive.values.toList();

  // ------------------------------------------
  // state

  int getMinSreenTimeLeftInSeconds(
      {required List<ScreenTimeSession> sessions}) {
    DateTime now = DateTime.now();
    int min = -1;
    sessions.forEach(
      (element) {
        int diff = now.difference(element.startedAt.toDate()).inSeconds;
        int timeLeft = element.minutes * 60 - diff;
        if (timeLeft < min || min < 0) {
          min = timeLeft;
        }
      },
    );
    return min;
  }

  ScreenTimeSession? getScreenTime({required String uid}) {
    try {
      return childScreenTimeSessionsActive
          .firstWhere((element) => element.uid == uid);
    } catch (e) {
      if (e is StateError) {
        return null;
      } else {
        rethrow;
      }
    }
  }

  // screen time will be added to subject every 60 seconds.
  // Map<String, StreamSubscription?> screenTimeSubjectSubscription = {};
  // void listenToScreenTime() {
  //   baseModelLog.e(
  //       "active screen time length: ${userService.supportedExplorerScreenTimeSessionsActive.length}");
  //   userService.supportedExplorerScreenTimeSessionsActive.forEach(
  //     (key, element) {
  //       if (!screenTimeSubjectSubscription.containsKey(element.uid) ||
  //           screenTimeSubjectSubscription[element.uid] == null) {
  //         screenTimeSubjectSubscription[element.uid] =
  //             screenTimeService.screenTimeActiveSubject[element.uid]?.listen(
  //           (_) {
  //             newScreenTimeLeft = secondsToMinuteTime(
  //                 screenTimeService.getMinSreenTimeLeftInSeconds());
  //             baseModelLog.e("new screentime left: $newScreenTimeLeft");
  //             notifyListeners();
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  Future clearServiceData(
      {bool logOutFromFirebase = true,
      bool doNotClearSponsorReference = false}) async {
    questService.clearData();
    activeQuestService.clearData();
    geolocationService.clearData();
    screenTimeService.clearData();
    _questTestingService.maybeReset();
    gamificationService.clearData();
    await userService.handleLogoutEvent(
        logOutFromFirebase: logOutFromFirebase,
        doNotClearSponsorReference: doNotClearSponsorReference);
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

  void setListenedToNewPosition(bool set) {
    if (useSuperUserFeatures) {
      geolocationService.setListenedToNewPosition(set);
    }
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

  bool hasEnoughCredits({required int credits}) {
    return currentUserStats.afkCreditsBalance >= credits;
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
        duration: Duration(seconds: 1));
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
    if (currentUser.role == UserRole.sponsor) {
      await navigationService.clearStackAndShow(
        Routes.parentHomeView,
      );
    } else if (currentUser.role == UserRole.adminMaster) {
      await navigationService.clearStackAndShow(
          Routes.bottomBarLayoutTemplateView,
          arguments:
              BottomBarLayoutTemplateViewArguments(userRole: currentUser.role));
    } else {
      await navigationService.clearStackAndShow(
        Routes.explorerHomeView,
      );
    }
  }

  Future replaceWithHomeView({bool showPermissionView = false}) async {
    // ? Request for all necessary permissions
    if (showPermissionView) {
      if (!(await _permissionService.allPermissionsProvided())) {
        await navigationService.navigateTo(Routes.permissionsView);
      }
    }
    if (currentUser.role == UserRole.sponsor) {
      replaceWithParentHomeView();
    } else if (currentUser.role == UserRole.adminMaster) {
      await navigationService.replaceWith(Routes.bottomBarLayoutTemplateView,
          arguments:
              BottomBarLayoutTemplateViewArguments(userRole: currentUser.role));
    } else {
      replaceWithExplorerHomeView();
    }
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
        AFKMarker? nextMarker = activeQuestService.getNextMarker();
        await activeQuestService.analyzeMarker(marker: nextMarker);
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
        await activeQuestService.analyzeMarker(marker: marker);
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

  Future<SheetResponse?> displayQuestBottomSheet(
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
        mainButtonTitle: isParentAccount ? "Show quest" : "Play",
        secondaryButtonTitle: isParentAccount ? "Delete quest" : "Close",
        data: quest);
    return sheetResponse;
    // if (sheetResponse?.confirmed == true) {
    //   baseModelLog
    //       .i("Looking at details of quest OR starting quest immediately");
    //   return true;
    // questService.getQuestUIStyle(quest: quest) == QuestUIStyle.map
    //     ? await navigateToActiveQuestUI(quest: quest)
    //     : await navigateToActiveQuestUI(quest: quest);
  }

  Future openSuperUserSettingsDialog() async {
    await dialogService.showCustomDialog(variant: DialogType.SuperUserSettings);
    setListenedToNewPosition(false);
    notifyListeners();
  }

  Future showCollectedMarkerDialog() async {
    await dialogService.showCustomDialog(variant: DialogType.CollectedMarker);
  }

  //////////////////////////////////////////
  /// Clean-up

  // void cancelScreenTimeLeftInSecondsSubjectListener() {
  //   screenTimeSubjectSubscription.forEach((key, value) {
  //     value?.cancel();
  //     screenTimeSubjectSubscription[key] = null;
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    //cancelScreenTimeLeftInSecondsSubjectListener();
  }
}
