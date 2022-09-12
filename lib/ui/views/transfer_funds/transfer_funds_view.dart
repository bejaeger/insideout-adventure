import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_viewmodel.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.form.dart';

@FormView(fields: [
  FormTextField(name: 'amount'),
])
class TransferFundsView extends StatelessWidget with $TransferFundsView {
  final TransferType type;
  final PublicUserInfo senderInfo;
  final PublicUserInfo recipientInfo;
  TransferFundsView(
      {Key? key,
      required this.type,
      required this.senderInfo,
      required this.recipientInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TransferFundsViewModel>.reactive(
      viewModelBuilder: () => TransferFundsViewModel(
          type: type, senderInfo: senderInfo, recipientInfo: recipientInfo),
      onModelReady: (model) {
        listenToFormUpdated(model);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("Add credits to ${recipientInfo.name}")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: ListView(
            children: [
              verticalSpaceMedium,
              AfkCreditsText.subheadingItalic(
                  "How many credits do you want to add to ${recipientInfo.name}?"),
              verticalSpaceMedium,
              Row(
                children: [
                  Container(
                    width: screenWidth(context, percentage: 0.35),
                    child: AfkCreditsInputField(
                      //focusNode: amountFocusNode,
                      controller: amountController,
                      style: heading3Style,
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(kAFKCreditsLogoPath, height: 10),
                      ),
                      autofocus: true,
                      //placeholder: 'Amount',
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      errorText: model.customValidationMessage,
                    ),
                  ),
                  //Container(color: Colors.red),
                  horizontalSpaceSmall,
                  Icon(Icons.arrow_right_alt, size: 26),
                  horizontalSpaceSmall,
                  Expanded(
                    child: SummaryStatsDisplay(
                      title: "Equiv. screen time",
                      icon: Image.asset(kScreenTimeIcon,
                          height: 26, color: kcScreenTimeBlue),
                      unit: "min",
                      stats: model.screenTimeEquivalent == null
                          ? "0"
                          : model.screenTimeEquivalent!.toStringAsFixed(0),
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,
              AfkCreditsButton(
                leading: Icon(Icons.add, color: Colors.white),
                title: "Add Credits",
                onTap: () {
                  amountFocusNode.unfocus();
                  model.showBottomSheetAndProcessPayment();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
