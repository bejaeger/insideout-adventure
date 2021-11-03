import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/ui/widgets/gift_cards/gift_cards_list.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GiftCardsSection extends StatelessWidget {
  final List<GiftCardCategory> giftCards;
  final Future Function(GiftCardCategory) onGiftCardTap;
  final checkGiftCard = true;

  const GiftCardsSection(
      {Key? key, required this.giftCards, required this.onGiftCardTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return giftCards.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: describeEnum(giftCards[0].categoryName).toString(),
              ),
              GiftCardsList(
                  giftCardList: giftCards, onGiftCardTap: onGiftCardTap),
            ],
          )
        : const SizedBox.shrink();
  }
}
