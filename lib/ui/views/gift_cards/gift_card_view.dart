import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/gift_cards/components/gift_cards_section.dart';
import 'package:afkcredits/ui/views/gift_cards/gift_card_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GiftCardView extends StatelessWidget {
  const GiftCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GiftCardViewModel>.reactive(
      viewModelBuilder: () => GiftCardViewModel(),
      onModelReady: (model) => model.loadAllGiftCards(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: 'Gift Card Shop',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: ListView(
            children: [
              (!model.isBusy)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpaceMedium,
                        Center(
                          child: Text(
                            'Time to Spend \n Your Hard-earned Credit.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        verticalSpaceMedium,
                        ...model
                            .getListOfGiftCardsToDisplay()
                            .map(
                              (e) => Column(
                                children: [
                                  GiftCardsSection(
                                      giftCards: e,
                                      onGiftCardTap: model
                                          .displayGiftCardDialogAndProcessPurchase),
                                  verticalSpaceMedium,
                                ],
                              ),
                            )
                            .toList(),
                        verticalSpaceLarge,
                      ],
                    )
                  : AFKProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
