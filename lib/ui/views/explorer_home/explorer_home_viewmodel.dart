import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'dart:async';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';

class ExplorerHomeViewModel extends SwitchAccountsViewModel {
  final GiftCardService _giftCardService = locator<GiftCardService>();
  
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
  }

  Future navigateToGiftCardsView() async {
    setShowBottomNavBar(false);
    await navigationService.navigateTo(Routes.purchasedGiftCardsView);
    setShowBottomNavBar(true);
  }

}
