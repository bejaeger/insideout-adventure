import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/enums/purchased_gift_card_status.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/purchased_gift_cards_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PurchasedGiftCardsView extends StatelessWidget {
  const PurchasedGiftCardsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PurchasedGiftCardsViewModel>.reactive(
      onModelReady: (model) => model.listenToData(),
      viewModelBuilder: () => PurchasedGiftCardsViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Your Gift Cards",
            onBackButton: model.navigateBack,
          ),
          body: model.isBusy
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: PurchasedGiftCardsList(
                    onBuyGiftCardPressed: model.navigateToGiftCardsView,
                    giftCards: model.purchasedGiftCards,
                    onRedeemedPressed: model.onRedeemedPressed,
                  )),
        ),
      ),
    );
  }
}

class PurchasedGiftCardsList extends StatelessWidget {
  final List<GiftCardPurchase> giftCards;
  final void Function(GiftCardPurchase) onRedeemedPressed;
  final void Function() onBuyGiftCardPressed;
  PurchasedGiftCardsList({
    Key? key,
    required this.giftCards,
    required this.onRedeemedPressed,
    required this.onBuyGiftCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return giftCards.length == 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpaceMediumLarge,
              EmptyNote(
                  title: "You don't have any gift cards yet.",
                  buttonTitle: "Buy Gift Card",
                  onMoreButtonPressed: onBuyGiftCardPressed),
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            itemCount: giftCards.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceRegular,
                  GiftCardPurchasePreview(
                    giftCard: giftCards[index],
                    onTap: onRedeemedPressed,
                  ),
                ],
              );
            });
  }
}

class GiftCardPurchasePreview extends StatelessWidget {
  final GiftCardPurchase giftCard;
  final void Function(GiftCardPurchase) onTap;

  const GiftCardPurchasePreview(
      {Key? key, required this.giftCard, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String giftCardCodeText = (giftCard.code == null ||
            (giftCard.code != null && giftCard.code!.isEmpty))
        ? "Your order will arrive soon."
        : giftCard.code!;
    bool isSelected = giftCard.status == PurchasedGiftCardStatus.redeemed;
    String titleSuffix = giftCard.status == PurchasedGiftCardStatus.available
        ? ", Redeem Now"
        : "";
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
            width: 1.0,
            color: giftCard.status == PurchasedGiftCardStatus.available
                ? kPrimaryColor
                : isSelected
                    ? Colors.grey[400]!
                    : Colors.grey[800]!),
      ),
      leading: giftCard.giftCardCategory.imageUrl != null
          ? Opacity(
              opacity: isSelected ? 0.5 : 1,
              child: Image.network(
                giftCard.giftCardCategory.imageUrl!,
                fit: BoxFit.fill,
              ),
            )
          : CircleAvatar(
              child: Text(giftCard.giftCardCategory.categoryName.toString()),
            ),
      isThreeLine: true,
      title:
          Text(giftCard.giftCardCategory.categoryName.toString() + titleSuffix),
      subtitle: Text(
        "" +
            formatAmount(giftCard.giftCardCategory.amount) +
            "; Code: " +
            giftCardCodeText,
        maxLines: 2,
      ),
      enabled: giftCard.status != PurchasedGiftCardStatus.redeemed,
      trailing: ToggleButtons(
        borderRadius: BorderRadius.circular(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(giftCard.status == PurchasedGiftCardStatus.available
                ? "used"
                : giftCard.status == PurchasedGiftCardStatus.redeemed
                    ? "used"
                    : "pending"),
          )
        ],
        isSelected: [isSelected],
        onPressed: giftCard.status != PurchasedGiftCardStatus.pending
            ? (int index) => onTap(giftCard)
            : null,
      ),
    );
  }
}
