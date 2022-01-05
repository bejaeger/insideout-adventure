import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/position_retrieval.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'dart:async';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_view.dart';

class ExplorerHomeViewModel extends SwitchAccountsViewModel {
  final GiftCardService _giftCardService = locator<GiftCardService>();

  String get currentDistance => geolocationService.getCurrentDistancesToGoal();
  String get liveDistance => geolocationService.getLiveDistancesToGoal();
  String get lastKnownDistance =>
      geolocationService.getLastKnownDistancesToGoal();
  List<PositionEntry> get allPositions => geolocationService.allPositions;

  late final String name;
  ExplorerHomeViewModel() : super(explorerUid: "") {
    // have to do that otherwise we get a null error when
    // switching account to the sponsor account
    this.name = currentUser.fullName;
  }

  List<ActivatedQuest> get activatedQuestsHistory =>
      questService.activatedQuestsHistory;
  List<GiftCardPurchase> get purchasedGiftCards =>
      _giftCardService.purchasedGiftCards;
  bool addingPositionToNotionDB = false;
  bool pushedToNotion = false;

  final log = getLogger("ExplorerHomeViewModel");

  Future listenToData() async {
    setBusy(true);
    Completer completer = Completer<void>();
    Completer completerTwo = Completer<void>();
    userService.setupUserDataListeners(
        completer: completer, callback: () => notifyListeners());
    questService.setupPastQuestsListener(
        completer: completerTwo,
        uid: currentUser.uid,
        callback: () => notifyListeners());
    await Future.wait([
      completer.future,
      completerTwo.future,
    ]);
    setBusy(false);
    if (isSuperUser) {
      geolocationService.listenToPosition();
    }
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

    // navigationService.replaceWith(Routes.bottomBarLayoutTemplateView,
    //     arguments: BottomBarLayoutTemplateViewArguments(
    //         userRole: currentUser.role,
    //         initialBottomNavBarIndex: BottomNavBarIndex.quest));
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

  Future navigateToGiftCardsView() async {
    await navigationService.navigateTo(Routes.purchasedGiftCardsView);
  }

  //-----------------------------------------
  // Some R & D
  Future pushAllPositionsToNotion() async {
    addingPositionToNotionDB = true;
    notifyListeners();
    bool ok = await geolocationService.pushAllPositionsToNotion();
    showResponseInfo(ok);
    pushedToNotion = true;
    addingPositionToNotionDB = false;
    notifyListeners();
  }

  Future addPositionEntryManual({bool onlyLastKnownPosition = false}) async {
    addingPositionToNotionDB = true;
    notifyListeners();

    final ok = await geolocationService.addPositionEntry(
        trigger: onlyLastKnownPosition
            ? LocationRetrievalTrigger.onlyLastKnown
            : LocationRetrievalTrigger.manualAll);
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
          title: "Failure",
          message: "Could not add position entry to notion db");
    }
  }
}
