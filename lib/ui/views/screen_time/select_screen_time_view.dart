import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/screen_time/select_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/main_long_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:stacked/stacked.dart';

class SelectScreenTimeView extends StatelessWidget {
  const SelectScreenTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectScreenTimeViewModel>.reactive(
      viewModelBuilder: () => SelectScreenTimeViewModel(),
      builder: (context, model, child) {
        return MainPage(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 40, bottom: 90),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: AfkCreditsText.headingOne("Screen time")),
                  verticalSpaceMedium,
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AfkCreditsText.subheading("8:08 PM"),
                        verticalSpaceTiny,
                        Expanded(
                          child: AfkCreditsText.body(
                              "10 min screen time cost 10 credits at this time."),
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
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
                          model.currentUserStats.afkCreditsBalance.toString()),
                      horizontalSpaceSmall,
                      Icon(Icons.arrow_right_alt_rounded, size: 25),
                      verticalSpaceMedium,
                      horizontalSpaceTiny,
                      Lottie.network(
                          'https://assets8.lottiefiles.com/packages/lf20_wTfKKa.json',
                          height: 40),
                      AfkCreditsText.headingThree(
                          model.totalAvailableScreenTime.toString() + " min"),
                    ],
                  ),
                  //Icon(Icons.arrow_downward_rounded, size: 40),
                  verticalSpaceSmall,
                  Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_l3jzffol.json',
                      height: 120),
                  verticalSpaceMedium,
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
                                  ? null
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
                                  ? null
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
                                  ? null
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
                      onTap: model.startScreenTime,
                      title: model.screenTimePreset != -1
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
