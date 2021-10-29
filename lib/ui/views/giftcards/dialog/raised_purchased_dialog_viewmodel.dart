import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/giftcards.dart';
import 'package:afkcredits/services/giftcard/giftcard_services.dart';
import 'package:stacked/stacked.dart';

class RaisedPurchasedDialogViewModel extends BaseViewModel {
  final log = getLogger('RaisedPurchasedDialogViewModel');
  final _giftCardService = locator<GiftCardService>();

  Giftcards get getGiftCards => _giftCardService.getPurchasedGiftCard!;
}
