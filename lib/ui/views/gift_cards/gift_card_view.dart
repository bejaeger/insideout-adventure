import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/gift_cards/components/gift_cards_section.dart';
import 'package:afkcredits/ui/views/gift_cards/gift_card_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/large_button.dart';
import 'package:afkcredits/ui/widgets/screen_time_button.dart';
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
          title: 'Get Your Rewards',
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
                        Text("SCREEN TIME",
                            style: textTheme(context)
                                .headline4!
                                .copyWith(fontSize: 26)),
                        verticalSpaceSmall,
                        Row(
                          children: [
                            ScreenTimeButton(
                              onPressed: model.showNotImplementedSnackbar,
                              title: "1 hour",
                              credits: 50,
                              backgroundColor: kDarkTurquoise,
                              titleColor: kWhiteTextColor,
                              imageUrl: kScreenTimeImageUrl,
                            ),
                            ScreenTimeButton(
                              onPressed: model.showNotImplementedSnackbar,
                              title: "2 hours",
                              credits: 100,
                              backgroundColor: kDarkTurquoise,
                              titleColor: kWhiteTextColor,
                              imageUrl: kScreenTimeImageUrl,
                            ),
                          ],
                        ),
                        verticalSpaceLarge,
                        Text("GIFT CARDS",
                            style: textTheme(context)
                                .headline4!
                                .copyWith(fontSize: 26)),
                        ...model
                            .getListOfGiftCardsToDisplay()
                            .map(
                              (e) => Column(
                                children: [
                                  GiftCardsSection(
                                      giftCards: e,
                                      onGiftCardTap: model
                                          .displayGiftCardDialogAndProcessPurchase),
                                  verticalSpaceSmall,
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
