import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/services/giftcard/giftcard_services.dart';
import 'package:afkcredits/ui/views/giftcards/gift_card_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class SteamViewModel extends GiftCardViewModel {
  final _giftCardServices = locator<GiftCardService>();
  final _dialogService = locator<DialogService>();

  //final _logger = getLogger('SteamViewModel');
  final _snackBarService = locator<SnackbarService>();

  List<GiftCardCategory?>? _giftcards;
  List<GiftCardCategory?>? get getGiftCard => _giftcards!;

  @override
  Future<void>? loadGiftCards({String? name}) async {
    setBusy(true);
    _giftcards = await _giftCardServices.getGiftCards(name: name);
    setBusy(false);
  }

  void setGiftCards({GiftCardCategory? giftcards}) {
    _giftCardServices.setGiftCard(purchaseGiftCard: giftcards);
  }

  Future displayDialogService() async {
    DialogResponse? dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.PurchaseGiftCards,
        mainButtonTitle: 'Purchase',
        secondaryButtonTitle: 'Cancel');
    if (dialogResponse?.confirmed == true) {
      showNotImplementedSnackbar();
      //Validate If the User Has enough Credit to Purchase Gift Cards.

    }
  }

  void showNotImplementedSnackbar() {
    _snackBarService.showSnackbar(
        title: "Not yet implemented.",
        message: "I know... it's sad",
        duration: Duration(seconds: 2));
  }
}
