import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/gamification/gamification_service.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/permission_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/active_quest_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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
  final GamificationService gamificationService =
      locator<GamificationService>();
  final ScreenTimeService screenTimeService = locator<ScreenTimeService>();
  final PermissionService _permissionService = locator<PermissionService>();
  final baseModelLog = getLogger("BaseModel");

  User get currentUser => userService.currentUser;
  User? get currentUserNullable => userService.currentUserNullable;
  UserStatistics get currentUserStats => userService.currentUserStats;
  bool get isSuperUser => userService.isSuperUser;
  bool get isGuardianAccount => currentUser.role == UserRole.guardian;
  bool get isAdminMaster => userService.isAdminUser;
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
  bool get isShowingWardAccount => layoutService.isShowingWardAccount;
  bool get isShowingCreditsOverlay => layoutService.isShowingCreditsOverlay;
  bool get isFadingOutOverlay => layoutService.isFadingOutOverlay;
  bool get isMovingCamera => layoutService.isMovingCamera;
  bool get isFadingOutQuestDetails => layoutService.isFadingOutQuestDetails;

  int get avatarIdx => currentUserNullable?.avatarIdx != null
      ? currentUserNullable!.avatarIdx!
      : 1;

  int currentLevel({num? lifetimeEarnings}) {
    return gamificationService.getCurrentLevel(
        lifetimeEarnings: lifetimeEarnings);
  }

  int get creditsToNextLevel => gamificationService.getCreditsToNextLevel();
  int get creditsForNextLevel => gamificationService.getCreditsForNextLevel();
  double get percentageOfNextLevel =>
      gamificationService.getPercentageOfNextLevel();
  String get currentLevelName => gamificationService.getCurrentLevelName();

  bool get hasSelectedQuest => activeQuestService.hasSelectedQuest;
  Quest? get selectedQuest => activeQuestService.selectedQuest;
  bool get hasActiveQuest => activeQuestService.hasActiveQuest;
  ActivatedQuest get activeQuest => activeQuestService.activatedQuest!;
  ActivatedQuest? get previouslyFinishedQuest =>
      activeQuestService.previouslyFinishedQuest;
  ActivatedQuest? get activeQuestNullable => activeQuestService.activatedQuest;

  String get getHourMinuteSecondsTime =>
      _stopWatchService.secondsToHourMinuteSecondTime(activeQuest.timeElapsed);

  int get numMarkersCollected =>
      activeQuest.markersCollected.where((element) => element == true).length;
  bool get isScreenTimeActive =>
      screenTimeService.supportedWardScreenTimeSessionsActive.length != 0;
  List<ScreenTimeSession> get wardScreenTimeSessionsActive =>
      screenTimeService.supportedWardScreenTimeSessionsActive.values.toList();

  bool? canVibrate;
  bool validatingMarker = false;

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
      return wardScreenTimeSessionsActive
          .firstWhere((element) => element.uid == uid);
    } catch (e) {
      if (e is StateError) {
        return null;
      } else {
        rethrow;
      }
    }
  }

  Future clearServiceData() async {
    questService.clearData();
    activeQuestService.clearData();
    geolocationService.clearData();
    screenTimeService.clearData();
    _questTestingService.maybeReset();
    gamificationService.clearData();
  }

  Future logout(
      {bool logOutFromFirebase = true,
      bool doNotClearGuardianReference = false}) async {
    clearServiceData();
    await userService.handleLogoutEvent(
        logOutFromFirebase: logOutFromFirebase,
        doNotClearGuardianReference: doNotClearGuardianReference);
    navigationService.clearStackAndShow(Routes.loginView);
  }

  void setListenedToNewPosition(bool set) {
    if (useSuperUserFeatures) {
      geolocationService.setListenedToNewPosition(set);
    }
  }

  // TODO: Remove concept of "enough guardianship"
  bool hasEnoughGuardianship({required Quest? quest}) {
    if (quest == null) {
      baseModelLog.e(
          "Attempted to check whether guardianship is enough for quest that is null!");
      return false;
    }
    return true;
  }

  bool hasEnoughCredits({required int credits}) {
    return currentUserStats.creditsBalance >= credits;
  }

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

  Future clearStackAndNavigateToHomeView(
      {bool showBewareDialog = false,
      bool showNumberQuestsDialog = false}) async {
    if (isGuardianAccount || isAdminMaster) {
      await navigationService.clearStackAndShow(
        Routes.highlightGuardianHomeView,
      );
    } else {
      await navigationService.clearStackAndShow(
        Routes.wardHomeView,
        arguments: WardHomeViewArguments(
          showBewareDialog: showBewareDialog,
          showNumberQuestsDialog: showNumberQuestsDialog,
        ),
      );
    }
  }

  Future replaceWithHomeView(
      {bool showPermissionView = false,
      bool showBewareDialog = false,
      bool showNumberQuestsDialog = false,
      bool showHightlightGuardianHomeView = false,
      ScreenTimeSession? screenTimeSession}) async {
    baseModelLog.v("Replacing view with home view");
    // ? Request for all necessary permissions
    if (showPermissionView) {
      if (!(await _permissionService.allPermissionsProvided())) {
        await navigationService.navigateTo(Routes.permissionsView);
      }
    }
    if (isGuardianAccount || isAdminMaster) {
      await replaceWithHighlightGuardianHomeView(
          screenTimeSession: screenTimeSession,
          highlightBubbles: showHightlightGuardianHomeView);
    } else {
      await replaceWithWardHomeView(
          showBewareDialog: showBewareDialog,
          showNumberQuestsDialog: showNumberQuestsDialog,
          screenTimeSession: screenTimeSession);
    }
  }

  Future showGenericInternalErrorDialog() async {
    return await dialogService.showDialog(
        title: "Sorry",
        description:
            "An internal error occured on our side. Sorry, please try again later.");
  }

  Future maybeCheatAndCollectNextMarker() async {
    if (useSuperUserFeatures) {
      final admin = await showAdminDialogAndGetResponse();
      if (admin == true) {
        // collect next marker automatically!
        AFKMarker? nextMarker = activeQuestService.getNextMarker();
        await activeQuestService.analyzeMarkerAndUpdateQuest(
            marker: nextMarker);
        final result = MarkerAnalysisResult.marker(marker: nextMarker);
        await handleMarkerAnalysisResult(result);
        baseModelLog.w("Cheated to collect this marker!");
        return true;
      }
    }
    return false;
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
      {required Quest quest,
      AFKMarker? startMarker,
      bool completed = false}) async {
    SheetResponse? sheetResponse = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.questInformation,
      title: quest.name,
      enterBottomSheetDuration: Duration(milliseconds: 300),
      description: quest.description,
      mainButtonTitle: isGuardianAccount ? "Show markers" : "Play",
      secondaryButtonTitle: isGuardianAccount ? "Delete quest" : "Close",
      data: {
        "quest": quest,
        "completed":
            completed && !(quest.repeatable == 1) && !useSuperUserFeatures
      },
    );
    return sheetResponse;
  }

  Future openSuperUserSettingsDialog() async {
    // needed when using this in Custom_dop_down_button
    await Future.delayed(Duration(milliseconds: 10));
    if (isSuperUser) {
      await dialogService.showCustomDialog(
          barrierDismissible: true, variant: DialogType.SuperUserSettings);
      setListenedToNewPosition(false);
      notifyListeners();
    }
  }

  Future showCollectedMarkerDialog() async {
    await dialogService.showCustomDialog(variant: DialogType.CollectedMarker);
  }

  // this is supposed to show the main instructions.
  // For now it's just a simple dialog
  Future showQuestInstructionDialog(QuestType? type) async {
    if (type == QuestType.TreasureLocationSearch) {
      await dialogService.showDialog(
          title: "How it works",
          description: kLocationSearchDescription,
          barrierDismissible: true);
    } else if (type == QuestType.GPSAreaHike) {
      await dialogService.showDialog(
          title: "How it works",
          description: kGPSAreaHikeDescription,
          barrierDismissible: true);
    } else if (type == QuestType.DistanceEstimate) {
      await dialogService.showDialog(
          title: "How it works",
          description: kDistanceEstimateDescription,
          barrierDismissible: true);
    } else {
      showGenericInternalErrorDialog();
    }
  }

  Future setNewUserPropertyToFalse() async {
    baseModelLog.i("Setting 'new user' property to false");
    userService.setNewUserPropertyToFalse(user: currentUser);
  }

  Future setNewAvatarId(int id) async {
    baseModelLog.i("Setting 'avatar id' to $id");
    await userService.setNewAvatarId(id: id, user: currentUser);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
