import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class PurchasedGiftCardsViewModel extends BaseModel {
  final GiftCardService _giftCardService = locator<GiftCardService>();
  List<GiftCardPurchase> get purchasedGiftCards =>
      _giftCardService.purchasedGiftCards;

  Future listenToData() async {
    setBusy(true);
    Completer completerThree = Completer<void>();
    _giftCardService.setupPurchasedGiftCardsListener(
        completer: completerThree,
        uid: currentUser.uid,
        callback: () => notifyListeners());
    await Future.wait([
      completerThree.future,
    ]);
    setBusy(false);
  }

  void onRedeemedPressed(GiftCardPurchase giftCardPurchase) async {
    _giftCardService.switchRedeemStatus(
        giftCardPurchase: giftCardPurchase, uid: currentUser.uid);
  }
}
