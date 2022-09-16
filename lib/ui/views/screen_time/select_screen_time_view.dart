import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/screen_time/select_screen_time_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:stacked/stacked.dart';

class SelectScreenTimeView extends StatelessWidget {
  // childId needs to be provided when accessing this view from the parents account
  final String? childId;
  const SelectScreenTimeView({Key? key, this.childId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectScreenTimeViewModel>.reactive(
      viewModelBuilder: () => SelectScreenTimeViewModel(childId: childId),
      builder: (context, model, child) {
        return MainPage(
          showBackButton: !model.isParentAccount,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 40,
                  bottom: kBottomBackButtonPadding + 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // AfkCreditsText.headingOne("Screen time"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (model.isParentAccount)
                        GestureDetector(
                          onTap: () {
                            model.popView();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.close, size: 30),
                          ),
                        ),
                      Expanded(
                        child: AfkCreditsText.headingTwo("Select screen time",
                            align: TextAlign.center),
                      ),
                    ],
                  ),

                  verticalSpaceMedium,
                  verticalSpaceSmall,
                  AfkCreditsText.subheading("Total available"),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hero(
                      //   tag: "CREDITS",
                      //   child: Image.asset(kAFKCreditsLogoPath,
                      //       height: 30, color: kcPrimaryColor),
                      // ),
                      Image.asset(kAFKCreditsLogoPath,
                          height: 30, color: kcPrimaryColor),
                      horizontalSpaceSmall,
                      AfkCreditsText.headingThree(
                          model.afkCreditsBalance.toStringAsFixed(0)),
                      horizontalSpaceSmall,
                      Icon(Icons.arrow_forward, size: 25),
                      horizontalSpaceSmall,
                      //Icon(Icons.schedule, color: kcScreenTimeBlue, size: 35),
                      Image.asset(kScreenTimeIcon,
                          height: 30, color: kcScreenTimeBlue),
                      horizontalSpaceSmall,
                      // Lottie.network(
                      //     'https://assets8.lottiefiles.com/packages/lf20_wTfKKa.json',
                      //     height: 40),
                      AfkCreditsText.headingThree(
                          model.totalAvailableScreenTime.toString() + " min"),
                    ],
                  ),
                  //Icon(Icons.arrow_downward_rounded, size: 40),
                  Spacer(),
                  Lottie.asset(kLottieBigTv, height: 160),
                  //  'https://assets8.lottiefiles.com/packages/lf20_l3jzffol.json',
                  Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AfkCreditsButton.outline(
                              enabled: model.screenTimePreset == 15,
                              title: "15 min",
                              onTap: model.totalAvailableScreenTime > 15
                                  ? () => model.selectScreenTime(minutes: 15)
                                  : null,
                              color: model.totalAvailableScreenTime > 15
                                  ? kcScreenTimeBlue
                                  : Colors.grey[500],
                            ),
                          ),
                          horizontalSpaceTiny,
                          Expanded(
                            child: AfkCreditsButton.outline(
                              enabled: model.screenTimePreset == 30,
                              title: "30 min",
                              onTap: model.totalAvailableScreenTime > 30
                                  ? () => model.selectScreenTime(minutes: 30)
                                  : null,
                              color: model.totalAvailableScreenTime > 30
                                  ? kcScreenTimeBlue
                                  : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceTiny,
                      Row(
                        children: [
                          Expanded(
                            child: AfkCreditsButton.outline(
                              enabled: model.screenTimePreset == 60,
                              title: "60 min",
                              onTap: model.totalAvailableScreenTime > 60
                                  ? () => model.selectScreenTime(minutes: 60)
                                  : null,
                              color: model.totalAvailableScreenTime > 60
                                  ? kcScreenTimeBlue
                                  : Colors.grey[500],
                            ),
                          ),
                          horizontalSpaceTiny,
                          Expanded(
                            child: AfkCreditsButton.outline(
                              enabled: model.screenTimePreset ==
                                  model.totalAvailableScreenTime,
                              title: "Maximum",
                              onTap: () => model.selectScreenTime(minutes: -1),
                              color: kcScreenTimeBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 70),
                  //   child: Divider(thickness: 2),
                  // ),
                  // verticalSpaceMedium,
                  Spacer(),
                  AfkCreditsButton(
                      onTap: model.afkCreditsBalance == 0
                          ? null
                          : model.startScreenTime,
                      disabled: model.afkCreditsBalance == 0,
                      color: kcScreenTimeBlue,
                      title: model.afkCreditsBalance == 0
                          ? "Not enough credits"
                          : model.screenTimePreset != -1
                              ? "Start ${model.screenTimePreset} min screen time"
                              : "Start maximum screen time"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
