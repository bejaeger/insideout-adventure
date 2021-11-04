import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/enums/purchased_gift_card_status.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/purchased_gift_cards_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PurchasedGiftCardsView extends StatelessWidget {
  const PurchasedGiftCardsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PurchasedGiftCardsViewModel>.reactive(
      onModelReady: (model) => model.listenToData(),
      viewModelBuilder: () => PurchasedGiftCardsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: "Your Gift Cards",
        ),
        body: model.isBusy
            ? CircularProgressIndicator()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: PurchasedGiftCardsList(
                  giftCards: model.purchasedGiftCards,
                  onRedeemedPressed: model.onRedeemedPressed,
                )),
      ),
    );
  }
}

class PurchasedGiftCardsList extends StatelessWidget {
  final List<GiftCardPurchase> giftCards;
  final void Function(GiftCardPurchase) onRedeemedPressed;
  PurchasedGiftCardsList({
    Key? key,
    required this.giftCards,
    required this.onRedeemedPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemCount: giftCards.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GiftCardPurchasePreview(
                giftCard: giftCards[index],
                onTap: onRedeemedPressed,
              ),
              verticalSpaceRegular,
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
        ? giftCard.code!
        : "Your order will arrive soon.";
    return ListTile(
      leading: giftCard.giftCardCategory.imageUrl != null
          ? Image.network(
              giftCard.giftCardCategory.imageUrl!,
              fit: BoxFit.fill,
            )
          : CircleAvatar(
              child: Text(describeEnum(giftCard.giftCardCategory.categoryName)
                  .toString()),
            ),
      isThreeLine: true,
      title:
          Text(describeEnum(giftCard.giftCardCategory.categoryName).toString()),
      subtitle: Text(
        "Amount: " +
            formatAmount(giftCard.giftCardCategory.amount) +
            "; Code: " +
            giftCardCodeText,
        maxLines: 2,
      ),
      enabled: giftCard.status != PurchasedGiftCardStatus.redeemed,
      trailing: ToggleButtons(
        children: [Text("redeemed")],
        isSelected: [giftCard.status == PurchasedGiftCardStatus.redeemed],
        onPressed: (int index) => onTap(giftCard),
      ),
    );
  }
}
