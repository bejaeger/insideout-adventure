import 'package:afkcredits/enums/gift_card_category.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'gift_cart_viewmodel.dart';

class GiftCardView extends StatelessWidget {
  const GiftCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GiftCardViewModel>.reactive(
      onModelReady: (model) => model.initilized(),
      builder: (context, model, child) => model.getGiftCard != null
          ? Scaffold(
              body: SingleChildScrollView(
                child: ListView.builder(
                    itemCount: model.getGiftCard!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (GiftCardCategory.playstation ==
                              model.getGiftCard![index]!.categoryName)
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Text(
                                      model.getGiftCard![index]!.categoryName!),
                                  Image.network(
                                      model.getGiftCard![index]!.imageUrl!),
                                  Text(model.getGiftCard![index]!.amount
                                      .toString())
                                ],
                              ),
                            ),
                          if (GiftCardCategory.xbox ==
                              model.getGiftCard![index]!.categoryName)
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: <Widget>[
                                  Text(
                                      model.getGiftCard![index]!.categoryName!),
                                  Image.network(
                                      model.getGiftCard![index]!.imageUrl!),
                                  Text(model.getGiftCard![index]!.amount
                                      .toString())
                                ],
                              ),
                            ),
                          if (GiftCardCategory.steam ==
                              model.getGiftCard![index]!.categoryName)
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Text(
                                      model.getGiftCard![index]!.categoryName!),
                                  Image.network(
                                      model.getGiftCard![index]!.imageUrl!),
                                  Text(model.getGiftCard![index]!.amount
                                      .toString())
                                ],
                              ),
                            ),
                        ],
                      );
                    }),
              ),
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
      viewModelBuilder: () => GiftCardViewModel(),
    );
  }
}
