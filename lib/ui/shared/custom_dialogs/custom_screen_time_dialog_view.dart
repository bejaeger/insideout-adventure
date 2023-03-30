import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/custom_screen_time_dialog_view.form.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/custom_screen_time_dialog_viewmodel.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@FormView(
  fields: [
    FormTextField(name: 'time'),
  ],
)
class CustomScreenTimeDialogView extends StatelessWidget
    with $CustomScreenTimeDialogView {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  CustomScreenTimeDialogView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CustomScreenTimeDialogViewModel>.reactive(
      viewModelBuilder: () => CustomScreenTimeDialogViewModel(),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
        child: Container(
          padding: const EdgeInsets.only(
            top: 32,
            left: 16,
            right: 16,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceSmall,
              Text('Select screen time',
                  textAlign: TextAlign.left,
                  style: textTheme(context)
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w800)),
              verticalSpaceMedium,
              Row(
                children: [
                  Container(
                    width: screenWidth(context, percentage: 0.35),
                    child: InsideOutInputField(
                      focusNode: timeFocusNode,
                      controller: timeController,
                      style: heading3Style,
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(kScreenTimeIcon,
                            height: 10, color: kcScreenTimeBlue),
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  //Container(color: Colors.red),
                  horizontalSpaceSmall,
                  Icon(Icons.arrow_right_alt, size: 26),
                  horizontalSpaceSmall,
                  Expanded(
                    child: SummaryStatsDisplay(
                      //title: "Amount credits",
                      icon: Image.asset(kAFKCreditsLogoPath,
                          height: 26, color: kcPrimaryColor),
                      //unit: "min",
                      stats: model.creditsEquivalent == null
                          ? "0"
                          : model.creditsEquivalent!.toStringAsFixed(0),
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InsideOutButton.text(
                      title: 'Close',
                      onTap: () {
                        timeController.clear();
                        completer(
                          DialogResponse(confirmed: false),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: InsideOutButton(
                      title: 'Select',
                      onTap: () {
                        timeController.clear();
                        completer(
                          DialogResponse(confirmed: true, data: model.minutes),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
