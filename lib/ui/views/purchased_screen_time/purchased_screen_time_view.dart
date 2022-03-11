import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/ui/views/purchased_screen_time/purchased_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/empty_note.dart';
import 'package:afkcredits/ui/widgets/screen_time_voucher.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
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
                    onTap: model.onActivatePressed,
                    onSeeVoucherTap: model.onVoucherTap,
                  ),
                ),
        ),
      ),
    );
  }
}

class ScreenTimeCardsList extends StatelessWidget {
  final List<ScreenTimePurchase> screenTimeVouchers;
  final Future Function(ScreenTimePurchase, bool) onTap;
  final void Function() onBuyScreenTimePressed;
  final void Function(ScreenTimePurchase) onSeeVoucherTap;

  ScreenTimeCardsList(
      {Key? key,
      required this.screenTimeVouchers,
      required this.onTap,
      required this.onBuyScreenTimePressed,
      required this.onSeeVoucherTap})
      : super(key: key);

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
                  ScreenTimeVoucher(
                    screenTimeVoucher: screenTimeVouchers[index],
                    onTap: onTap,
                    onSeeVoucherTap: onSeeVoucherTap,
                  ),
                ],
              );
            },
          );
  }
}
