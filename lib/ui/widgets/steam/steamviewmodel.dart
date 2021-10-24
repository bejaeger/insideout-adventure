import 'package:afkcredits/app/app.locator.dart';
//import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/giftcards.dart';
import 'package:afkcredits/services/giftcard/giftcard_services.dart';
import 'package:afkcredits/ui/views/giftcards/gift_cart_viewmodel.dart';

class SteamViewModel extends GiftCardViewModel {
  final _giftCardServices = locator<GiftCardService>();
  List<Giftcards?>? _giftcards;
  List<Giftcards?>? get getGiftCard => _giftcards!;
  @override
  Future<void>? initilized({String? name}) async {
    setBusy(true);
    _giftcards = await _giftCardServices.getGiftCards(name: name);
    setBusy(false);
    notifyListeners();
  }
}
