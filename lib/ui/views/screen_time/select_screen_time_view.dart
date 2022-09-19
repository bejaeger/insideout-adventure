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
            // width: 300,
            // height: 400,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 40,
                  bottom: kBottomBackButtonPadding + 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AfkCreditsText.headingOne("Screen time"),
                  if (model.isParentAccount)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          model.popView();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.close, size: 30),
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AfkCreditsText.headingTwo("Select screen time",
                          align: TextAlign.center),
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
                  Lottie.asset(kLottieBigTv,
                      height: screenHeight(context, percentage: 0.22)),
                  //  'https://assets8.lottiefiles.com/packages/lf20_l3jzffol.json',
                  Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AfkCreditsButton.outline(
                              enabled: model.screenTimePreset == 20,
                              title: "20 min",
                              onTap: model.totalAvailableScreenTime >= 20
                                  ? () => model.selectScreenTime(minutes: 20)
                                  : null,
                              color: model.totalAvailableScreenTime >= 20
                                  ? kcScreenTimeBlue
                                  : Colors.grey[500],
                            ),
                          ),
                          horizontalSpaceTiny,
                          Expanded(
                            child: AfkCreditsButton.outline(
                              enabled: model.screenTimePreset == 40,
                              title: "40 min",
                              onTap: model.totalAvailableScreenTime >= 40
                                  ? () => model.selectScreenTime(minutes: 40)
                                  : null,
                              color: model.totalAvailableScreenTime >= 40
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
                              onTap: model.totalAvailableScreenTime >= 60
                                  ? () => model.selectScreenTime(minutes: 60)
                                  : null,
                              color: model.totalAvailableScreenTime >= 60
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
                              onTap: (model.screenTimePreset ==
                                      model.totalAvailableScreenTime)
                                  ? null
                                  : () => model.selectScreenTime(minutes: -1),
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
                      leading:
                          Icon(Icons.play_arrow_rounded, color: Colors.white),
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
