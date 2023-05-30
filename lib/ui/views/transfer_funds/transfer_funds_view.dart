import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.form.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/select_value.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(fields: [
  FormTextField(name: 'amount'),
])
class TransferFundsView extends StatelessWidget with $TransferFundsView {
  final PublicUserInfo senderInfo;
  final PublicUserInfo recipientInfo;
  final bool selectScreenTimeMode;
  TransferFundsView(
      {Key? key,
      required this.senderInfo,
      required this.recipientInfo,
      this.selectScreenTimeMode = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TransferFundsViewModel>.reactive(
      viewModelBuilder: () => TransferFundsViewModel(
          senderInfo: senderInfo, recipientInfo: recipientInfo),
      onModelReady: (model) {
        listenToFormUpdated(model);
      },
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
              title: "Reward ${recipientInfo.name}",
              onBackButton: () {
                amountController.clear();
                model.popView();
              }),
          body: Container(
            height: screenHeight(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SelectValue(
                  userPrompt:
                      "How many credits do you want to add to ${recipientInfo.name}'s account?",
                  inputField: _creditsInputField(),
                  validationMessage: model.customValidationMessage,
                  equivalentValueWidget:
                      _screenTimeSummaryStats(model.equivalentValue),
                  ctaButton: _transferCreditsButton(
                      onTap: model.showBottomSheetAndProcessTransfer,
                      enabled: model.canTransferCredits()),
                ),
                verticalSpaceMedium,
                Container(
                  width: screenWidth(context, percentage: 0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InsideOutText.body(
                          "Why ${recipientInfo.name} might have earned credits"),
                      verticalSpaceTiny,
                      InsideOutText.body("""
\u2022 for helping in the kitchen
\u2022 as a birthday gift
\u2022 for being active
\u2022 for reading a book
\u2022 for mowing the lawn
\u2022 for helping in the household
\u2022 ...
                          """),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _screenTimeSummaryStats(num? value) {
    return SummaryStatsDisplay(
      title: "Equiv. screen time",
      icon: Image.asset(kScreenTimeIcon, height: 26, color: kcScreenTimeBlue),
      unit: "min",
      stats: value == null ? "0" : value.toStringAsFixed(0),
    );
  }

  Widget _creditsInputField() {
    return InsideOutInputField(
      focusNode: amountFocusNode,
      controller: amountController,
      style: heading3Style,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(kInsideOutLogoPath, height: 10),
      ),
      autofocus: true,
      keyboardType: TextInputType.number,
    );
  }

  Widget _transferCreditsButton(
      {required Function() onTap, required bool enabled}) {
    return InsideOutButton(
      leading: Icon(Icons.add, color: Colors.white),
      title: "Reward credits",
      disabled: !enabled,
      onTap: () async {
        amountFocusNode.unfocus();
        final res = await onTap();
        if (res is bool && res == true) {
          amountController.clear();
        }
      },
    );
  }
}
