import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/giftcards.dart';

class GiftCardService {
  final _firestoreApi = locator<FirestoreApi>();
  final logger = getLogger('GiftCardService');
  Future<List<Giftcards?>?> getGiftCards() async {
    return await _firestoreApi.getGiftCards();
  }
}
