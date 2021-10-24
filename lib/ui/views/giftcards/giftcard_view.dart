import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/ps/ps.dart';
import 'package:afkcredits/ui/widgets/steam/steam.dart';
import 'package:afkcredits/ui/widgets/xbox/xbox.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'gift_cart_viewmodel.dart';

class GiftCardView extends StatelessWidget {
  const GiftCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GiftCardViewModel>.reactive(
      viewModelBuilder: () => GiftCardViewModel(),
      onModelReady: (model) => model.initilized(),
      builder: (context, model, child) => model.getGiftCard != null
          ? Scaffold(
              appBar: CustomAppBar(
                title: 'Gift Card List',
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 90.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpaceSmall,
                        Text(
                          model.getGiftCard![0]!.categoryName!.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceSmall,
                        steamWidget(context,
                            length: model.getGiftCard!.length,
                            getGiftCard: model.getGiftCard),
                        verticalSpaceSmall,
                        Text(model.getGiftCard![0]!.categoryName!.toString()),
                        verticalSpaceSmall,
                        psWidget(context,
                            length: model.getGiftCard!.length,
                            getGiftCard: model.getGiftCard),
                        verticalSpaceSmall,
                        Text(model.getGiftCard![0]!.categoryName!.toString()),
                        verticalSpaceSmall,
                        xboxWidget(context,
                            length: model.getGiftCard!.length,
                            getGiftCard: model.getGiftCard),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
    );
  }
}
