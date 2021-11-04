import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'dart:async';

class ExplorerHomeViewModel extends BaseModel {
  final GiftCardService _giftCardService = locator<GiftCardService>();
  List<ActivatedQuest> get activatedQuestsHistory =>
      questService.activatedQuestsHistory;
  List<GiftCardPurchase> get purchasedGiftCards =>
      _giftCardService.purchasedGiftCards;

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

  void navigateToGiftCardsView() {
    navigationService.navigateTo(Routes.purchasedGiftCardsView);
  }
}
