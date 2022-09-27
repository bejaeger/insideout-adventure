import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/helpers/quest_data_point.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'dart:async';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/notifications/notification_controller.dart';
import 'package:afkcredits/notifications/notifications.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_view.dart';
import 'package:geolocator/geolocator.dart';

import '../../../datamodels/quests/quest.dart';

class ExplorerHomeViewModel extends SwitchAccountsViewModel
    with MapStateControlMixin {
  //-------------------------------------------------------
  // services
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final log = getLogger("ExplorerHomeViewModel");

  // Stateful Data
  // ignore: close_sinks

  // --------------------------------------------------
  // getters
  bool get isListeningToLocation => geolocationService.isListeningToLocation;
  String get currentDistance => geolocationService.getCurrentDistancesToGoal();
  String get liveDistance => geolocationService
      .getLiveDistancesToGoal(); // ----------------------------------
  bool get showReloadQuestButton => questService.showReloadQuestButton;
  bool get isReloadingQuests => questService.isReloadingQuests;
  String get lastKnownDistance =>
      geolocationService.getLastKnownDistancesToGoal();
  List<QuestDataPoint> get allPositions =>
      _questTestingService.allQuestDataPoints;
  List<ActivatedQuest> get activatedQuestsHistory =>
      questService.activatedQuestsHistory;
  List<Achievement> get achievements => gamificationService.achievements;
  Position? get userLocation => geolocationService.getUserLivePositionNullable;
  bool get isDevFlavor => appConfigProvider.isDevFlavor;

  // ---------------------------------------
  // state
  late final String name;
  ExplorerHomeViewModel() : super(explorerUid: "") {
    // have to do that otherwise we get a null error when
    // switching account to the sponsor account
    this.name = currentUser.fullName;
    //_reactToServices(reactiveServices);
  }

  bool addingPositionToNotionDB = false;
  bool pushedToNotion = false;

  bool showQuestLoadingScreen = true;
  bool showFullLoadingScreen = true;

  ScreenTimeSession? get currentScreenTimeSession =>
      _screenTimeService.getActiveScreenTimeInMemory(uid: currentUser.uid);
  Future initialize({
    bool showBewareDialog = false,
    ScreenTimeSession? screenTimeSession,
  }) async {
    setBusy(true);
    await listenToData();
    listenToLayout();

    // make sure the tilt is set correctly. Might not be the case when using parent map before
    // TODO: Might want to treat that in a cleaner way in a general reset method.
    mapViewModel.changeCameraTilt(kInitialTilt);

    // makes sure that screen time subject is listened to in case one is active!
    // ! This is duplicated in parent_home_viewmodel.dart
    if (screenTimeSession != null) {
      await screenTimeService.listenToPotentialScreenTimes(
          callback: notifyListeners);
      ScreenTimeSession? session =
          await screenTimeService.getSpecificScreenTime(
        uid: screenTimeSession.uid,
        sessionId: screenTimeSession.sessionId,
      );
      if (session != null) {
        await navToActiveScreenTimeView(session: session);
      } else {
        log.wtf(
            "NO screen time session found. This should never be the case. ");
      }
    } else {
      // no need to await for it when we don't navigate to it
      screenTimeService.listenToPotentialScreenTimes(callback: notifyListeners);
    }

    setBusy(false);
    // fade loading screen out process
    await Future.delayed(
      Duration(milliseconds: 500),
    );
    final result = await initializeQuests();
    mapViewModel.extractStartMarkersAndAddToMap();

    // remove full screen loading screen
    showFullLoadingScreen = false;
    notifyListeners();

    // if no quests are found.
    // Give some UI element that shows how many quests were found in the
    // neighborhood
    if (result is void Function()) {
      await Future.delayed(Duration(milliseconds: 1500));
      result();
    } else {
      if (showBewareDialog) {
        dialogService.showCustomDialog(
            variant: DialogType.BewareOfSurroundings);
        // snackbarService.showSnackbar(
        //     title: "Found ${questService.getNearByQuest.length} quests nearby",
        //     message: "Look around to play them");
      }
    }
    showQuestLoadingScreen = false;
    notifyListeners();
  }

  Future listenToData() async {
    Completer completer = Completer<void>();
    // Completer completerTwo = Completer<void>();
    // Completer completerThree = Completer<void>();
    userService.setupUserDataListeners(
      completer: completer,
      callback: () => notifyListeners(),
    );
    // not used atm!
    // questService.setupPastQuestsListener(
    //   completer: completerTwo,
    //   uid: currentUser.uid,
    //   callback: () => notifyListeners(),
    // );
    // not used atm!
    // gamificationService.setupAchievementsListener(
    //   completer: completerThree,
    //   uid: currentUser.uid,
    //   callback: () => notifyListeners(),
    // );
    activeQuestService.addMainLocationListener();
    await Future.wait(
      [
        completer.future,
        //completerTwo.future,
        //completerThree.future,
        getLocation(forceAwait: true, forceGettingNewPosition: false),
        // checkIsUsingScreenTime(),
        // adds listener to screen time collection!
        // needed e.g. when child creates screen time session but parent removes it
        userService.addExplorerScreenTimeListener(
            explorerId: currentUser.uid, callback: () => notifyListeners()),
      ],
    );
  }

  Future initializeQuests(
      {bool? force,
      double? lat,
      double? lon,
      bool loadNewQuests = false}) async {
    try {
      if (questService.sortedNearbyQuests == false || force == true) {
        await questService.loadNearbyQuests(
          force: true,
          sponsorIds: currentUser.sponsorIds,
          lat: lat,
          lon: lon,
          addQuestsToExisting: loadNewQuests,
        );
        await questService.sortNearbyQuests();
        questService.extractAllQuestTypes();
      }
    } catch (e) {
      log.wtf(
          "Error when loading quests, this could happen when the quests collection is flawed. Error: $e");
      if (e is QuestServiceException) {
        if (e.message == WarningNoQuestsDownloaded) {
          return () async {
            await dialogService.showDialog(
                title: "No quests", description: e.prettyDetails ?? e.message);
          };
        } else {
          await dialogService.showDialog(
              title: "Oops...", description: e.prettyDetails ?? e.message);
        }
      } else {
        log.wtf(
            "Error when loading quests, this should never happen. Error: $e");
        await showGenericInternalErrorDialog();
      }
    }
  }

  Future loadNewQuests() async {
    log.i("Loading new quests");
    questService.isReloadingQuests = true;
    notifyListeners();
    await initializeQuests(
        force: true,
        lat: mapStateService.currentLat,
        lon: mapStateService.currentLon,
        loadNewQuests: true);
    questService.showReloadQuestButton = false;
    questService.isReloadingQuests = false;
    mapViewModel.extractStartMarkersAndAddToMap();
    notifyListeners();
  }

  Future getLocation(
      {bool forceAwait = false, bool forceGettingNewPosition = true}) async {
    try {
      if (geolocationService.getUserLivePositionNullable == null) {
        await geolocationService.getAndSetCurrentLocation(
            forceGettingNewPosition: forceGettingNewPosition);
      } else {
        if (forceAwait) {
          await geolocationService.getAndSetCurrentLocation(
              forceGettingNewPosition: forceGettingNewPosition);
        } else {
          geolocationService.getAndSetCurrentLocation(
              forceGettingNewPosition: forceGettingNewPosition);
        }
      }
    } catch (e) {
      if (e is GeolocationServiceException) {
        if (appConfigProvider.enableGPSVerification) {
          await dialogService.showDialog(
              title: "Sorry", description: e.prettyDetails);
        } else {
          if (!shownDummyModeDialog) {
            await dialogService.showDialog(
                title: "Dummy mode active",
                description:
                    "GPS connection not available, you can still try out the quests by tapping on the markers");
            shownDummyModeDialog = true;
          }
        }
      } else {
        log.wtf("Could not get location of user");
        await showGenericInternalErrorDialog();
      }
    }
  }

  // Future<ScreenTimeSession?> checkIsUsingScreenTime() async {
  //   final String? id = await _localStorageService.getFromDisk(
  //       key: kLocalStorageScreenTimeSessionKey);
  //   if (id != null) {
  //     final session = await screenTimeService.checkForActiveScreenTimeSession(
  //         uid: currentUser.uid, sessionId: id);
  //     if (session != null) {
  //       notifyListeners();
  //       return session;
  //     }
  //   }
  //   notifyListeners();
  //   return null;
  // }

  void navigateToQuests() {
    // navigationService.replaceWithTransition(QuestsOverviewView(),
    //     transition: 'righttoleft', duration: Duration(seconds: 1));
    navigationService.replaceWithTransition(
        BottomBarLayoutTemplateView(
            userRole: currentUser.role,
            initialBottomNavBarIndex: BottomNavBarIndex.quest),
        transition: 'righttoleft',
        duration: Duration(milliseconds: 400));
  }

  Future showToEarnExplanationDialog() async {
    dialogService.showDialog(
        title: "Sponsored Credits",
        description:
            "Succeed in Quests to unlock these credits. If you don't have credits to earn, ask for funding!");
  }

  Future showEarnedExplanationDialog() async {
    dialogService.showDialog(
        title: "Your Earned Credits",
        description:
            "This is the amount you successfully earned already! You can spend credits on gift cards!");
  }

  Future navigateToRewardsView() async {
    await navigationService.replaceWith(Routes.bottomBarLayoutTemplateView,
        arguments: BottomBarLayoutTemplateViewArguments(
            userRole: currentUser.role,
            initialBottomNavBarIndex: BottomNavBarIndex.giftcard));
  }

  void navigateToAchievementsView() {
    navigationService.navigateTo(Routes.historyAndAchievementsView,
        arguments: HistoryAndAchievementsViewArguments(initialIndex: 1));
  }

  void navigateToQuestHistoryView() {
    navigationService.navigateTo(Routes.historyAndAchievementsView,
        arguments: HistoryAndAchievementsViewArguments(initialIndex: 0));
  }

  //-----------------------------------------
  // Some R & D
  // TO BE DEPRECATED!

  Future pushAllPositionsToNotion() async {
    addingPositionToNotionDB = true;
    notifyListeners();
    if (_questTestingService.isAllQuestDataPointsPushed()) {
      snackbarService.showSnackbar(
          title: "Done",
          message: "All locations were already pushed to notion");
      pushedToNotion = true;
      return;
    }
    bool ok = await _questTestingService.pushAllPositionsToNotion();
    showResponseInfo(ok);
    if (ok == true) {
      pushedToNotion = true;
    }
    addingPositionToNotionDB = false;
    notifyListeners();
  }

  Future addPositionEntryManual({bool onlyLastKnownPosition = false}) async {
    addingPositionToNotionDB = true;
    notifyListeners();
    final ok = await _questTestingService.maybeRecordData(
      trigger: onlyLastKnownPosition
          ? QuestDataPointTrigger.onlyLastKnownLocationFetchingEvent
          : QuestDataPointTrigger.manualLocationFetchingEvent,
      pushToNotion: false,
    );
    showResponseInfo(ok);
    addingPositionToNotionDB = false;
    notifyListeners();
  }

  void showResponseInfo(bool ok) {
    if (ok) {
      snackbarService.showSnackbar(
          title: "Success", message: "Added position entry to notion db");
    } else {
      snackbarService.showSnackbar(
          title: "Failure", message: "Connect to a network and try again");
    }
  }
  //------------------------
  // cleanup

  int? notId;
  int? notScheduledId;
  void createTestNotification() async {
    notId = await Notifications().createPermanentNotification(
      title: "SCREEN TIME STARTED",
      message: "Hi",
    );
    notScheduledId = await Notifications().createScheduledNotification(
      title: "EXPIRED",
      message: "Hi",
      date: DateTime.now().add(Duration(seconds: 7)),
      session: ScreenTimeSession(
          sessionId: "sessionId",
          uid: "uid",
          userName: "Bernd",
          createdByUid: "hi",
          minutes: 10,
          status: ScreenTimeSessionStatus.active,
          afkCredits: 10),
    );
    notifyListeners();
  }

  void dismissTestNotification() {
    if (notId != null) {
      NotificationController().dismissNotifications(id: notId);
      notId = null;
    }
    if (notScheduledId != null) {
      NotificationController().dismissNotifications(id: notScheduledId);
      notScheduledId = null;
    }
    notifyListeners();
  }

  // ----------------------------------------------------------------
  // listeners for layout changes!

  StreamSubscription? _isFadingOutOverlayStream;
  StreamSubscription? _isShowingQuestListStream;
  StreamSubscription? _selectedQuestStream;
  StreamSubscription? _isFadingOutQuestDetailsSubjectStream;
  void listenToLayout() {
    if (_isFadingOutOverlayStream == null) {
      _isFadingOutOverlayStream =
          layoutService.isFadingOutOverlaySubject.listen((show) {
        notifyListeners();
      });
    }
    if (_isShowingQuestListStream == null) {
      _isShowingQuestListStream =
          layoutService.isShowingQuestListSubject.listen((show) {
        notifyListeners();
      });
    }
    if (_selectedQuestStream == null) {
      _selectedQuestStream =
          activeQuestService.selectedQuestSubject.listen((quest) {
        notifyListeners();
      });
    }
    if (_isFadingOutQuestDetailsSubjectStream == null) {
      _isFadingOutQuestDetailsSubjectStream =
          layoutService.isFadingOutQuestDetailsSubject.listen((show) {
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _isFadingOutOverlayStream?.cancel();
    _isShowingQuestListStream?.cancel();
    _selectedQuestStream?.cancel();
    _isFadingOutQuestDetailsSubjectStream?.cancel();
    super.dispose();
  }

  //------------------------------------------------------------
  // Reactive Service Mixin Functionality from stacked ReactiveViewModel!
  // late List<ReactiveServiceMixin> _reactiveServices;
  // List<ReactiveServiceMixin> get reactiveServices =>
  //     [layoutService]; // _reactiveServices;
  // void _reactToServices(List<ReactiveServiceMixin> reactiveServices) {
  //   _reactiveServices = reactiveServices;
  //   for (var reactiveService in _reactiveServices) {
  //     reactiveService.addListener(_indicateChange);
  //   }
  // }

  // @override
  // void dispose() {
  //   for (var reactiveService in _reactiveServices) {
  //     reactiveService.removeListener(_indicateChange);
  //   }
  //   super.dispose();
  // }

  // void _indicateChange() {
  //   notifyListeners();
  // }
}
