import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/datamodels/giftcards/pre_purchased_gift_cards/pre_purchased_gift_card.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/manage_gift_cards/add_gift_cards/add_gift_cards_viewmodel.dart';
import 'package:afkcredits/utils/snackbars/display_snack_bars.dart';
import 'package:uuid/uuid.dart';

class InsertPrePurchasedGiftCardViewModel extends GiftCardsImageViewModel {
  final logger = getLogger('InsertPrePurchasedGiftCardViewModel');
  final _giftCardService = locator<GiftCardService>();
  final displaySnackBars = DisplaySnackBars();
  List<GiftCardCategory>? _listOfGiftCard = [];
  List<String> listOfGiftCategories = [];

  @override
  void setFormStatus() {
    logger.i('Set the Form With Data: $formValueMap');
  }

  //Upload Image to Firebase.
  Future<bool>? insertPrePurchasedGiftCard(
      {required String? categoryId,
      required String? categoryName,
      required String giftCardCode}) async {
    if ((giftCardCode == "") ||
        (giftCardCode.length != 16) ||
        (categoryName?.toString() == null) ||
        (categoryId?.toString() == null)) {
      emptyTextFields();
    } else {
      var id = Uuid();
      String giftCardId = id.v1().toString().replaceAll('-', '');
      //int _giftCardCode = int.parse(giftCardCode);

      bool checkIsert =
          await _giftCardService.insertPrePurchasedGiftCardCategory(
        prePurchasedGiftCard: PrePurchasedGiftCard(
            categoryId: categoryId!,
            id: giftCardId,
            giftCardCode: giftCardCode,
            categoryName: categoryName!),
      );
      if (checkIsert) {
        displaySnackBars.snackBarInsertedPrePurchasedGC();
        return checkIsert;
      }
    }
    return false;
  }

  List<GiftCardCategory?> get getListOfGiftCard => _listOfGiftCard!;

  Future<void> setListGiftCard() async {
    setBusy(true);
    await loadAllGiftCards();
    _listOfGiftCard = _giftCardService.getListOfGiftCard;
    setBusy(false);
    notifyListeners();
  }

//ADDED HERE
  Future loadAllGiftCards() async {
    //setBusy(true);
    //log.i("Loading gift cards");
    await _giftCardService.fetchAllGiftCards();
    //setBusy(false);
  }

  void emptyTextFields() {
    logger.wtf('You are Proving Empty Fields');
    displaySnackBars.snackBarTextBoxEmpty();
  }
}
