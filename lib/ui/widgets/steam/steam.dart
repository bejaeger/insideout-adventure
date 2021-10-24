import 'package:afkcredits/datamodels/giftcards/giftcards.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

Widget steamWidget(BuildContext context,
    {int? length, List<Giftcards?>? getGiftCard}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height / 4,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: Image.network(
                  getGiftCard![index]!.imageUrl!,
                  fit: BoxFit.fill,
                  //height: 120,
                  //width: 120,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(formatAmount(getGiftCard[index]!.amount).toString()),
                    horizontalSpaceSmall,
                    Text(getGiftCard[index]!.name.toString()),
                    horizontalSpaceSmall,
                    Text(formatAmount(getGiftCard[index]!.amount).toString()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
