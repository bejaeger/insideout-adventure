import 'package:afkcredits/app/app.locator.dart';
//import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/giftcards.dart';
import 'package:afkcredits/services/giftcard/giftcard_services.dart';
import 'package:afkcredits/ui/views/giftcards/gift_cart_viewmodel.dart';

class PSViewModel extends GiftCardViewModel {
  final _giftCardServices = locator<GiftCardService>();
  List<Giftcards?>? _giftcards;
  //final _logger = getLogger('PSViewModel');

  List<Giftcards?>? get getGiftCard => _giftcards!;

  Future<void>? initilizedPs() async {
    setBusy(true);
    // _giftcards = await _giftCardServices.getGiftCards();
    _giftcards = await _giftCardServices.getGiftCards(name: "Playstation");
    setBusy(false);
    notifyListeners();
  }
}
