import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/views/drawer_widget/drawer_widget_view.dart';
import 'package:afkcredits/ui/views/gift_cards/components/gift_cards_section.dart';
import 'package:afkcredits/ui/views/gift_cards/gift_card_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/screen_time_button.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// !!! DEPRECATED

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
          drawer: true,
        ),
        endDrawer: SizedBox(
          width: screenWidth(context, percentage: 0.8),
          child: const DrawerWidgetView(),
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
                        ScreenTimeVoucherList(
                          screenTimeVoucherList:
                              model.getScreenTimeCategories(),
                          onPressed: model.handleScreenTimePurchase,
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
                                      onGiftCardTap:
                                          model.handleGiftCardPurchase),
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

class ScreenTimeVoucherList extends StatelessWidget {
  final double? height;
  final List<ScreenTimeSession> screenTimeVoucherList;
  final Future Function(ScreenTimeSession) onPressed;
  const ScreenTimeVoucherList(
      {Key? key,
      this.height,
      required this.screenTimeVoucherList,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: screenTimeVoucherList.length,
        itemBuilder: (context, index) {
          return ScreenTimeButton(
            title: "${screenTimeVoucherList[index].minutes} minutes",
            credits: centsToAfkCredits(screenTimeVoucherList[index].afkCredits),
            backgroundColor: kDarkTurquoise,
            titleColor: kWhiteTextColor,
            imageUrl: kScreenTimeImageUrl,
            onPressed: () => onPressed(screenTimeVoucherList[index]),
          );
        },
      ),
    );
  }
}
