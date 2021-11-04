import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GiftCardsList extends StatelessWidget {
  final double? height;
  final List<GiftCardCategory> giftCardList;
  final Future Function(GiftCardCategory) onGiftCardTap;
  const GiftCardsList(
      {Key? key,
      this.height,
      required this.giftCardList,
      required this.onGiftCardTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? screenHeight(context) / 4,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: giftCardList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (giftCardList[index].imageUrl != null)
                    Expanded(
                      flex: 4,
                      child: Image.network(
                        giftCardList[index].imageUrl!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(formatAmount(giftCardList[index].amount)
                            .toString()),
                        horizontalSpaceSmall,
                        Text(
                          describeEnum(
                              giftCardList[index].categoryName.toString()),
                        ),
                        horizontalSpaceSmall,
                        Text(centsToAfkCredits(giftCardList[index].amount)
                                .toString() +
                            " AFKC"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              onGiftCardTap(giftCardList[index]);
            },
          );
        },
      ),
    );
  }
}
