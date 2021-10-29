import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category.dart';
import 'package:afkcredits/services/giftcard/giftcard_services.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class RaisedPurchasedDialogViewModel extends BaseModel {
  final log = getLogger('RaisedPurchasedDialogViewModel');
  final _giftCardService = locator<GiftCardService>();

  GiftCardCategory get getGiftCards => _giftCardService.getPurchasedGiftCard!;
}
