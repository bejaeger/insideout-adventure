import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/helpers/quest_data_point.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'dart:async';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_view.dart';
import 'package:geolocator/geolocator.dart';

class ExplorerHomeViewModel extends SwitchAccountsViewModel
    with MapStateControlMixin {
  //-------------------------------------------------------
  // services
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();
  final AppConfigProvider flavorConfigProvider = locator<AppConfigProvider>();

  // --------------------------------------------------
  // getters
  bool get isListeningToLocation => geolocationService.isListeningToLocation;
  String get currentDistance => geolocationService.getCurrentDistancesToGoal();
  String get liveDistance => geolocationService.getLiveDistancesToGoal();
  String get lastKnownDistance =>
      geolocationService.getLastKnownDistancesToGoal();
  List<QuestDataPoint> get allPositions =>
      _questTestingService.allQuestDataPoints;
  List<ActivatedQuest> get activatedQuestsHistory =>
      questService.activatedQuestsHistory;
  List<Achievement> get achievements => gamificationService.achievements;
  Position? get userLocation => geolocationService.getUserLivePositionNullable;

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

  bool showLoadingScreen = true;
  bool showFullLoadingScreen = true;
  final log = getLogger("ExplorerHomeViewModel");

  Future initialize() async {
    setBusy(true);
    await listenToData();
    await initializeQuests();
    listenToLayout();
    setBusy(false);

    // fade loading screen out process
    await Future.delayed(Duration(milliseconds: 500));
    showFullLoadingScreen = false;
    notifyListeners();
    // ? should to be in line with the fade out time in Loading Overlay widget
    await Future.delayed(Duration(milliseconds: 500));
    showLoadingScreen = false;
    notifyListeners();
  }

  Future listenToData() async {
    Completer completer = Completer<void>();
    Completer completerTwo = Completer<void>();
    Completer completerThree = Completer<void>();
    userService.setupUserDataListeners(
      completer: completer,
      callback: () => notifyListeners(),
    );
    questService.setupPastQuestsListener(
      completer: completerTwo,
      uid: currentUser.uid,
      callback: () => notifyListeners(),
    );
    gamificationService.setupAchievementsListener(
      completer: completerThree,
      uid: currentUser.uid,
      callback: () => notifyListeners(),
    );
    addLocationListener();
    await Future.wait([
      completer.future,
      completerTwo.future,
      completerThree.future,
      getLocation(forceAwait: true, forceGettingNewPosition: false),
    ]);
  }

  Future initializeQuests({bool? force}) async {
    try {
      if (questService.sortedNearbyQuests == false || force == true) {
        await questService.loadNearbyQuests(force: true);
        await questService.sortNearbyQuests();
        questService.extractAllQuestTypes();
      }
    } catch (e) {
      log.wtf("Error when loading quests, this should never happen. Error: $e");
      await showGenericInternalErrorDialog();
    }
  }

  void addLocationListener() async {
    await geolocationService.listenToPositionMain(
      distanceFilter: kDefaultGeolocationDistanceFilter,
      onData: (Position position) {
        setNewLatLon(lat: position.latitude, lon: position.longitude);
        animateOnNewLocation();
        log.v("New position event fired from location listener!");
      },
    );
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
        if (flavorConfigProvider.enableGPSVerification) {
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

  Future askForLocationPermission() async {
    final locationPermission =
        await geolocationService.askForLocationPermission();
    snackbarService.showSnackbar(
        message: "Granted location: $locationPermission");
  }

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

  // ----------------------------------------------------------------
  // listeners for layout changes!

  StreamSubscription? _isShowingARViewStream;
  StreamSubscription? _isShowingQuestListStream;
  StreamSubscription? _selectedQuestStream;
  StreamSubscription? _isFadingOutQuestDetailsSubjectStream;
  void listenToLayout() {
    if (_isShowingARViewStream == null) {
      _isShowingARViewStream =
          layoutService.isShowingARViewSubject.listen((show) {
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
          activeQuestService.selectedQuestSubject.listen((show) {
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
    _isShowingARViewStream?.cancel();
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
