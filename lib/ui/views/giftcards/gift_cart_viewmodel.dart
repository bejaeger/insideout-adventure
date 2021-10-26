import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/giftcards.dart';
import 'package:afkcredits/services/giftcard/giftcard_services.dart';
import 'package:stacked/stacked.dart';

abstract class GiftCardViewModel extends BaseViewModel {
  final _giftCardServices = locator<GiftCardService>();
  List<Giftcards?>? _giftcards;
  final _logger = getLogger('GiftCardViewModel');

  List<Giftcards?>? get getGiftCard => _giftcards!;

  Future<void>? initilized() async {
    setBusy(true);
    // _giftcards = await _giftCardServices.getGiftCards();
    _giftcards = await _giftCardServices.getGiftCards();
    _logger.i('This is the Value of GiftCards Within ViewModel $_giftcards');
    setBusy(false);
    notifyListeners();
  }
}
