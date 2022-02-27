import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/ui/views/purchased_screen_time/purchased_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PurchasedScreenTimeView extends StatelessWidget {
  const PurchasedScreenTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PurchasedScreenTimeViewModel>.reactive(
      onModelReady: (model) => model.listenToData(),
      disposeViewModel: false,
      viewModelBuilder: () => PurchasedScreenTimeViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Your Screen Time",
            onBackButton: model.navigateBack,
          ),
          body: model.isBusy
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: ScreenTimeCardsList(
                    onBuyScreenTimePressed: model.navigateToScreenTimeView,
                    screenTimeVouchers: model.purchasedScreenTime,
                    onRedeemedPressed: model.onRedeemedPressed,
                  ),
                ),
        ),
      ),
    );
  }
}

class ScreenTimeCardsList extends StatelessWidget {
  final List<ScreenTimePurchase> screenTimeVouchers;
  final void Function(ScreenTimePurchase) onRedeemedPressed;
  final void Function() onBuyScreenTimePressed;
  ScreenTimeCardsList({
    Key? key,
    required this.screenTimeVouchers,
    required this.onRedeemedPressed,
    required this.onBuyScreenTimePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return screenTimeVouchers.length == 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpaceMediumLarge,
              EmptyNote(
                  title: "You don't have any screen time yet.",
                  buttonTitle: "Buy Screen Time",
                  onMoreButtonPressed: onBuyScreenTimePressed),
            ],
          )
        : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            itemCount: screenTimeVouchers.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  verticalSpaceRegular,
                  ScreenTimePurchasePreview(
                    screenTimeVoucher: screenTimeVouchers[index],
                    onTap: onRedeemedPressed,
                  ),
                ],
              );
            },
          );
  }
}

class ScreenTimePurchasePreview extends StatelessWidget {
  final ScreenTimePurchase screenTimeVoucher;
  final void Function(ScreenTimePurchase) onTap;

  const ScreenTimePurchasePreview(
      {Key? key, required this.screenTimeVoucher, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: screenWidth(context, percentage: 0.8),
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You have"),
            Text(screenTimeVoucher.hours.toString(),
                style: textTheme(context).headline4),
            Text("hours of screen time"),
          ],
        ),
      ),
    );
  }
}
