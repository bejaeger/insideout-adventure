import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category.dart';

class GiftCardService {
  final _firestoreApi = locator<FirestoreApi>();
  final logger = getLogger('GiftCardService');
  GiftCardCategory? _purchaseGiftCard;

  void setGiftCard({GiftCardCategory? purchaseGiftCard}) {
    _purchaseGiftCard = purchaseGiftCard;
  }

  Future<List<GiftCardCategory?>?> getGiftCards({String? name}) async {
    return await _firestoreApi.getGiftCards(name: name);
  }

  GiftCardCategory? get getPurchasedGiftCard => _purchaseGiftCard;
}
