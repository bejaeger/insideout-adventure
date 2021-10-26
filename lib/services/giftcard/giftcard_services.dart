import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/giftcards.dart';

class GiftCardService {
  final _firestoreApi = locator<FirestoreApi>();
  final logger = getLogger('GiftCardService');
  Giftcards? _purchaseGiftCard;

  void setGiftCard({Giftcards? purchaseGiftCard}) {
    _purchaseGiftCard = purchaseGiftCard;
  }

  Future<List<Giftcards?>?> getGiftCards({String? name}) async {
    return await _firestoreApi.getGiftCards(name: name);
  }

  Giftcards? get getPurchasedGiftCard => _purchaseGiftCard;
}
