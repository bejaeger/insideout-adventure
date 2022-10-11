import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/screen_time/select_screen_time_viewmodel.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

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
          resizeToAvoidBottomInset: false,
          //backButtonColor: kcCultured,
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: Padding(
          //   padding: EdgeInsets.only(
          //       bottom: model.isParentAccount ? 20 : kBottomBackButtonPadding,
          //       left: 20.0,
          //       right: 20.0),
          //   child: AfkCreditsButton(
          //     height: 50,
          //     //width: 100,
          //     leading: Icon(Icons.play_arrow_rounded, color: Colors.white),
          //     onTap:
          //         model.afkCreditsBalance == 0 ? null : model.startScreenTime,
          //     color: model.afkCreditsBalance == 0
          //         ? kcMediumGrey
          //         : kcScreenTimeBlue,
          //     title: model.afkCreditsBalance == 0
          //         ? "Not enough credits"
          //         : "Start screen time",
          //   ),
          // ),
          child: Container(
            // width: 300,
            // height: 400,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 40,
                bottom: model.isParentAccount ? 20 : kBottomBackButtonPadding,
              ),
              //bottom:
              //  !model.isParentAccount ? (kBottomBackButtonPadding) : 30),
              child: Container(
                height: 1000 + screenHeight(context, percentage: 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // AfkCreditsText.headingOne("Screen time"),
                    if (model.isParentAccount)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: model.popView,
                            icon: Icon(Icons.arrow_back_ios, size: 26),
                          ),
                        ),
                      ),
                    verticalSpaceSmall,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AfkCreditsText.headingTwo(
                            model.isParentAccount
                                ? "Choose time for " +
                                    model.userService
                                        .explorerNameFromUid(childId!)
                                : "Get your well-deserved screen time",
                            align: TextAlign.center),
                      ],
                    ),
                    verticalSpaceMedium,
                    // if (screenHeight(context) > 660)
                    //   Center(
                    //     child: Lottie.asset(kLottieBigTv,
                    //         height: screenHeight(context, percentage: 0.15)),
                    //   ),
                    //  'https://assets8.lottiefiles.com/packages/lf20_l3jzffol.json',
                    Spacer(),
                    AfkCreditsText.body("Total available"),
                    verticalSpaceTiny,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hero(
                        //   tag: "CREDITS",
                        //   child: Image.asset(kAFKCreditsLogoPath,
                        //       height: 30, color: kcPrimaryColor),
                        // ),
                        Image.asset(kAFKCreditsLogoPath,
                            height: 18, color: kcPrimaryColor),
                        horizontalSpaceTiny,
                        AfkCreditsText.headingFourLight(
                            model.afkCreditsBalance.toStringAsFixed(0)),
                        horizontalSpaceSmall,
                        Icon(Icons.arrow_right_alt, size: 20),
                        horizontalSpaceSmall,
                        //Icon(Icons.schedule, color: kcScreenTimeBlue, size: 35),
                        Image.asset(kScreenTimeIcon,
                            height: 18, color: kcScreenTimeBlue),
                        horizontalSpaceTiny,
                        // Lottie.network(
                        //     'https://assets8.lottiefiles.com/packages/lf20_wTfKKa.json',
                        //     height: 40),
                        AfkCreditsText.headingFourLight(
                            model.totalAvailableScreenTime.toString() + " min"),
                      ],
                    ),
                    verticalSpaceMedium,
                    //Icon(Icons.arrow_downward_rounded, size: 40),
                    AfkCreditsText.body("Selected"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AfkCreditsText(
                            text: model.screenTimePreset.toString() + " min",
                            style: heading1Style.copyWith(
                                fontWeight: FontWeight.w800)),
                        // Icon(Icons.arrow_forward, size: 22),
                        horizontalSpaceSmall,
                        AfkCreditsText.headingFourLight("="),
                        //Icon(Icons.arrow_right_alt, size: 20),
                        // //Icon(Icons.schedule, color: kcScreenTimeBlue, size: 35),
                        horizontalSpaceSmall,
                        Image.asset(kAFKCreditsLogoPath,
                            height: 18, color: kcPrimaryColor),
                        horizontalSpaceTiny,
                        AfkCreditsText.headingFourLight(
                            screenTimeToCredits(model.screenTimePreset)
                                .toString()),
                        //verticalSpaceTiny,
                        // Lottie.network(
                        //     'https://assets8.lottiefiles.com/packages/lf20_wTfKKa.json',
                        //     height: 40),
                      ],
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => model.selectCustomScreenTime(),
                        child: Container(
                          //color: Colors.red,
                          width: 180,
                          padding: const EdgeInsets.only(
                              top: 25, bottom: 25, left: 20, right: 20),
                          alignment: Alignment.center,
                          child: AfkCreditsText.bodyBold(
                            "Custom",
                            //onTap: () => model.selectCustomScreenTime(),
                            color: kcScreenTimeBlue,
                          ),
                        ),
                      ),
                    ),
                    //verticalSpaceSmall,
                    // verticalSpaceLarge,
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AfkCreditsButton.outline(
                                height: 60,
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
                                height: 60,
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
                            horizontalSpaceTiny,
                            Expanded(
                              child: AfkCreditsButton.outline(
                                height: 60,
                                enabled: model.screenTimePreset ==
                                    model.totalAvailableScreenTime,
                                title: "Max",
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
                    Spacer(),
                    AfkCreditsButton(
                        height: 50,
                        leading:
                            Icon(Icons.play_arrow_rounded, color: Colors.white),
                        onTap: model.afkCreditsBalance == 0
                            ? null
                            : model.startScreenTime,
                        disabled: model.afkCreditsBalance == 0,
                        color: kcScreenTimeBlue,
                        title: model.afkCreditsBalance == 0
                            ? "Not enough credits"
                            : "Start screen time"),
                    //verticalSpaceLarge,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
