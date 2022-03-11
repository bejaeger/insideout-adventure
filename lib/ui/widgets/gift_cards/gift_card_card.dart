import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/ui/widgets/cach_network_image/cached_network_image_wrapper.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class GiftCardCard extends StatelessWidget {
  final GiftCardCategory giftCardCategory;
  final void Function() onPressed;
  const GiftCardCard(
      {Key? key, required this.giftCardCategory, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            // color: Colors.grey[200],
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.grey[350]!, Colors.grey[100]!])),
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (giftCardCategory.imageUrl != null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImageWrapper(
                        imageUrl: giftCardCategory.imageUrl!,
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                        formatAmount(giftCardCategory.amount).toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                verticalSpaceSmall,
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AFKCreditsIcon(height: 25),
                      Text(
                          centsToAfkCredits(giftCardCategory.amount).toString(),
                          style: TextStyle(color: kPrimaryColor)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: onPressed);
  }
}
