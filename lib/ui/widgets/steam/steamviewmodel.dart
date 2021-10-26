import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/giftcards/giftcards.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/services/giftcard/giftcard_services.dart';
import 'package:afkcredits/ui/views/giftcards/gift_cart_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class SteamViewModel extends GiftCardViewModel {
  final _giftCardServices = locator<GiftCardService>();
  final _dialogService = locator<DialogService>();

  List<Giftcards?>? _giftcards;

  List<Giftcards?>? get getGiftCard => _giftcards!;

  @override
  Future<void>? initilized({String? name}) async {
    setBusy(true);
    _giftcards = await _giftCardServices.getGiftCards(name: name);
    setBusy(false);
    notifyListeners();
  }

  void setGiftCards({Giftcards? giftcards}) {
    _giftCardServices.setGiftCard(purchaseGiftCard: giftcards);
  }

  Future displayDialogService() async {
    DialogResponse? dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.purchaseGiftCards,
        mainButtonTitle: 'Purchase',
        secondaryButtonTitle: 'Cancel');
    if (dialogResponse?.confirmed == true) {
      //Validate If the User Has enough Credit to Purchase Gift Cards.
    }
  }
}
