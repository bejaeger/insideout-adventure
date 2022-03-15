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
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'dart:async';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_view.dart';
import 'package:geolocator/geolocator.dart';

class ExplorerHomeViewModel extends SwitchAccountsViewModel {
  //-------------------------------------------------------
  // services
  final GiftCardService _giftCardService = locator<GiftCardService>();
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();
  final FlavorConfigProvider flavorConfigProvider =
      locator<FlavorConfigProvider>();

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
  List<GiftCardPurchase> get purchasedGiftCards =>
      _giftCardService.purchasedGiftCards;
  List<Achievement> get achievements => gamificationService.achievements;

  // ---------------------------------------
  // state
  late final String name;
  final void Function(Position position) animateToPosition;
  ExplorerHomeViewModel({required this.animateToPosition})
      : super(explorerUid: "") {
    // have to do that otherwise we get a null error when
    // switching account to the sponsor account
    this.name = currentUser.fullName;
  }

  bool addingPositionToNotionDB = false;
  bool pushedToNotion = false;

  final log = getLogger("ExplorerHomeViewModel");

  Future initialize() async {
    setBusy(true);
    await listenToData();
    await initializeQuests();
    setBusy(false);
  }

  Future listenToData() async {
    setBusy(true);
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
    await geolocationService.listenToPosition(
      distanceFilter: kDefaultGeolocationDistanceFilter,
      onData: (Position position) {
        animateToPosition(position);
        log.v("New position event fired from location listener!");
      },
    );
  }

  void cancelLocationListener() {
    if (useSuperUserFeatures) {
      activeQuestService.cancelPositionListener();
      notifyListeners();
    }
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
}
