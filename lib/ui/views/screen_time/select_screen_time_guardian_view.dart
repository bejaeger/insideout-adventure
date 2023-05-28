import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/ui/views/screen_time/select_screen_time_guardian_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/select_value.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'package:afkcredits/ui/views/screen_time/select_screen_time_guardian_view.form.dart';

@FormView(fields: [
  FormTextField(name: 'amount'),
])
class SelectScreenTimeGuardianView extends StatelessWidget
    with $SelectScreenTimeGuardianView {
  final PublicUserInfo senderInfo;
  final PublicUserInfo recipientInfo;
  final String childId;

  final bool selectScreenTimeMode;
  SelectScreenTimeGuardianView(
      {Key? key,
      required this.senderInfo,
      required this.recipientInfo,
      this.selectScreenTimeMode = false,
      required this.childId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectScreenTimeGuardianViewModel>.reactive(
      viewModelBuilder: () => SelectScreenTimeGuardianViewModel(
          childId: childId,
          senderInfo: senderInfo,
          recipientInfo: recipientInfo),
      onModelReady: (model) {
        listenToFormUpdated(model);
      },
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Select screen time",
            onBackButton: () {
              amountController.clear();
              model.popView();
            }
          ),
          body: SelectValue(
            userPrompt:
                "Choose minutes of screen time for ${recipientInfo.name}",
            inputField: _screenTimeInputField(model.customValidationMessage),
            equivalentValueWidget: _creditsSummaryStats(model.equivalentValue),
            validationMessage: model.customValidationMessage,
            ctaButton: _startScreenTimeButton(
                onTap: model.startScreenTime,
                enabled: model.canStartScreenTime()),
          ),
        ),
      ),
    );
  }

  Widget _creditsSummaryStats(num? value) {
    return SummaryStatsDisplay(
      title: "Equiv. credits",
      icon: Image.asset(kAFKCreditsLogoPath, color: kcPrimaryColor, height: 26),
      stats: value == null ? "0" : value.toStringAsFixed(0),
    );
  }

  Widget _screenTimeInputField(String? validationMessage) {
    return InsideOutInputField(
      focusNode: amountFocusNode,
      controller: amountController,
      style: heading3Style,
      // trailing: InsideOutText.body("min"),
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          kScreenTimeIcon,
          height: 10,
          color: kcScreenTimeBlue,
        ),
      ),
      autofocus: true,
      keyboardType: TextInputType.number,
    );
  }

  Widget _startScreenTimeButton(
      {required Function() onTap, required bool enabled}) {
    return InsideOutButton(
      leading: Icon(Icons.play_arrow, color: Colors.white),
      disabled: !enabled,
      title: "Start screen time",
      onTap: enabled
          ? () async {
              amountFocusNode.unfocus();
              final res = await onTap();
              if (res is bool && res == true) {
                amountController.clear();                
              }
            }
          : null,
    );
  }
}
