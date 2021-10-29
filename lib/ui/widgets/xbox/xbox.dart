import 'package:afkcredits/ui/widgets/xbox/xboxviewmodel.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

Widget xboxWidget(
  BuildContext context,
) {
  return ViewModelBuilder<XboxViewModel>.reactive(
    viewModelBuilder: () => XboxViewModel(),
    onModelReady: (model) => model.loadGiftCards(name: 'Xbox'),
    builder: (context, model, child) => (!model.isBusy &&
            model.getGiftCard!.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                describeEnum(model.getGiftCard![0]!.categoryName!.toString()),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.getGiftCard!.length,
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
                            Expanded(
                              flex: 4,
                              child: Image.network(
                                model.getGiftCard![index]!.imageUrl!,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(formatAmount(
                                          model.getGiftCard![index]!.amount)
                                      .toString()),
                                  horizontalSpaceSmall,
                                  Text(describeEnum(model
                                      .getGiftCard![index]!.categoryName
                                      .toString())),
                                  horizontalSpaceSmall,
                                  Text(formatAmount(
                                          model.getGiftCard![index]!.amount)
                                      .toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        model.setGiftCards(
                            giftcards: model.getGiftCard![index]!);
                        model.displayDialogService();
                        print(model.getGiftCard![index]!);
                      },
                    );
                  },
                ),
              ),
            ],
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
  );
}
