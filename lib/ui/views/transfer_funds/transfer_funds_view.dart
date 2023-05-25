import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.form.dart';

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
        builder: (context, model, child) => selectScreenTimeMode == false
            ? SelectValueView(
                title: "Add credits to ${recipientInfo.name}",
                userPrompt:
                    "How many credits do you want to add to ${recipientInfo.name}'s account?",
                inputField: _creditsInputField(),
                equivalentValueWidget:
                    _screenTimeSummaryStats(model.equivalentValue),
                ctaButton: _transferCreditsButton(
                    onTap: model.showBottomSheetAndProcessPayment))
            : SelectValueView(
                title: "Select screen time",
                userPrompt: "Choose screen time for ${recipientInfo.name}",
                inputField: _screenTimeInputField(),
                equivalentValueWidget:
                    _creditsSummaryStats(model.equivalentValue),
                ctaButton: _transferCreditsButton(
                    onTap: model.showBottomSheetAndProcessPayment)));
  }

  Widget _creditsSummaryStats(num? value) {
    return SummaryStatsDisplay(
      title: "Equiv. credits",
      icon: Image.asset(kAFKCreditsLogoPath, color: kcPrimaryColor, height: 26),
      stats: value == null ? "0" : value.toStringAsFixed(0),
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
      trailing: InsideOutText.body("min"),
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(kAFKCreditsLogoPath, height: 10),
      ),
      autofocus: true,
      keyboardType: TextInputType.number,
    );
  }

  Widget _screenTimeInputField() {
    return InsideOutInputField(
      focusNode: amountFocusNode,
      controller: amountController,
      style: heading3Style,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(kScreenTimeIcon, height: 10),
      ),
      autofocus: true,
      keyboardType: TextInputType.number,
    );
  }

  Widget _transferCreditsButton({required Function() onTap}) {
    return InsideOutButton(
      leading: Icon(Icons.add, color: Colors.white),
      title: "Reward credits",
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

class SelectValueView extends StatelessWidget {
  final String title;
  final String userPrompt;
  final Widget inputField;
  final Widget equivalentValueWidget;
  final String? validationMessage;
  final Widget ctaButton;
  const SelectValueView(
      {Key? key,
      required this.title,
      required this.userPrompt,
      required this.inputField,
      required this.equivalentValueWidget,
      this.validationMessage,
      required this.ctaButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: ListView(
          children: [
            verticalSpaceMedium,
            InsideOutText.bodyItalic(userPrompt),
            verticalSpaceMedium,
            Row(
              children: [
                Container(
                    width: screenWidth(context, percentage: 0.35),
                    child: inputField),
                //Container(color: Colors.red),
                horizontalSpaceSmall,
                Icon(Icons.arrow_right_alt, size: 26),
                horizontalSpaceSmall,
                Expanded(child: equivalentValueWidget)
              ],
            ),
            if (validationMessage != null)
              Expanded(child: InsideOutText.warn(validationMessage!)),
            verticalSpaceMedium,
            ctaButton,
          ],
        ),
      ),
    );
  }
}
