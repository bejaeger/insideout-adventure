import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/datamodels/giftcards/pre_purchased_gift_cards/pre_purchased_gift_card.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/manage_gift_cards/add_gift_cards/add_gift_cards_viewmodel.dart';
import 'package:afkcredits/utils/snackbars/display_snack_bars.dart';

class InsertPrePurchasedGiftCardViewModel extends GiftCardsImageViewModel {
  final logger = getLogger('ManageQuestViewModel');
  final _giftCardService = locator<GiftCardService>();
  final displaySnackBars = DisplaySnackBars();
  List<GiftCardCategory>? _listOfGiftCard = [];
  List<String> listOfGiftCategories = [];

  //bool checkPurchasedGiftCard = false;

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
  //Upload Image to Firebase.
  Future<bool>? insertPrePurchasedGiftCard(
      {required PrePurchasedGiftCard prePurchasedGiftCard}) async {
    if (prePurchasedGiftCard.categoryId.isNotEmpty) {
      bool checkIsert =
          await _giftCardService.insertPrePurchasedGiftCardCategory(
              prePurchasedGiftCard: prePurchasedGiftCard);
      if (checkIsert) {
        displaySnackBars.snackBarInsertedPrePurchasedGC();
        await Future.delayed(
          const Duration(seconds: 4),
          () {
            this.navBackToPreviousView();
          },
        );

        return checkIsert;
      }
    }
    return false;
  }

  List<GiftCardCategory> get getListOfGiftCard => _listOfGiftCard!;

  void setListGiftCard() {
    setBusy(true);
    _listOfGiftCard = _giftCardService.getListOfGiftCard;
    setBusy(false);
    notifyListeners();
  }

  void emptyTextFields() {
    displaySnackBars.snackBarTextBoxEmpty();
  }
}
