import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/users/public_user_info.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_viewmodel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
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
        appBar: AppBar(title: Text("Sponsor ${recipientInfo.name}")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: ListView(
            children: [
              verticalSpaceMedium,
              Text("Add funds to ${recipientInfo.name}"),
              verticalSpaceMedium,
              TextField(
                cursorColor: kBlackHeadlineColor,
                focusNode: amountFocusNode,
                controller: amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: textTheme(context)
                    .bodyText2!
                    .copyWith(fontSize: 35, color: kBlackHeadlineColor),
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: kBlackHeadlineColor, width: 0.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: kBlackHeadlineColor, width: 0.0),
                  ),
                ),
              ),
              verticalSpaceMedium,
              ElevatedButton(
                  onPressed: () {
                    amountFocusNode.unfocus();
                    model.showBottomSheetAndProcessPayment();
                  },
                  child: Text("Checkout")),
            ],
          ),
        ),
      ),
    );
  }
}
