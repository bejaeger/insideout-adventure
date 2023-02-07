import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/screen_time/select_screen_time_viewmodel.dart';
import 'package:insideout_ui/insideout_ui.dart';
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
          resizeToAvoidBottomInset: false,
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 40,
                bottom: model.isParentAccount ? 20 : kBottomBackButtonPadding,
              ),
              child: Container(
                height: 1000 + screenHeight(context, percentage: 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                        InsideOutText.headingTwo(
                            model.isParentAccount
                                ? "Choose time for " +
                                    model.userService
                                        .explorerNameFromUid(childId!)
                                : "Get your well-deserved screen time",
                            align: TextAlign.center),
                      ],
                    ),
                    verticalSpaceMedium,
                    Spacer(),
                    if (model.isParentAccount)
                      InsideOutText.body("Total available"),
                    if (model.isParentAccount) verticalSpaceTiny,
                    if (model.isParentAccount)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(kAFKCreditsLogoPath,
                              height: 18, color: kcPrimaryColor),
                          horizontalSpaceTiny,
                          InsideOutText.headingFourLight(
                              model.afkCreditsBalance.toStringAsFixed(0)),
                          horizontalSpaceSmall,
                          Icon(Icons.arrow_right_alt, size: 20),
                          horizontalSpaceSmall,
                          Image.asset(kScreenTimeIcon,
                              height: 18, color: kcScreenTimeBlue),
                          horizontalSpaceTiny,
                          InsideOutText.headingFourLight(
                              model.totalAvailableScreenTime.toString() +
                                  " min"),
                        ],
                      ),
                    if (!model.isParentAccount)
                      Lottie.asset(kLottieBigTv, height: 130),
                    Spacer(),
                    InsideOutText.body("Selected"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InsideOutText(
                            text: model.screenTimePreset.toString() + " min",
                            style: heading1Style.copyWith(
                                fontWeight: FontWeight.w800)),
                        horizontalSpaceSmall,
                        InsideOutText.headingFourLight("="),
                        horizontalSpaceSmall,
                        Image.asset(kAFKCreditsLogoPath,
                            height: 18, color: kcPrimaryColor),
                        horizontalSpaceTiny,
                        InsideOutText.headingFourLight(
                            HerculesWorldCreditSystem.screenTimeToCredits(
                                    model.screenTimePreset)
                                .toString()),
                      ],
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => model.selectCustomScreenTime(),
                        child: Container(
                          width: 180,
                          padding: const EdgeInsets.only(
                              top: 25, bottom: 25, left: 20, right: 20),
                          alignment: Alignment.center,
                          child: InsideOutText.bodyBold(
                            "Custom",
                            color: kcScreenTimeBlue,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InsideOutButton.outline(
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
                              child: InsideOutButton.outline(
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
                              child: InsideOutButton.outline(
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
                    InsideOutButton(
                        height: 50,
                        leading:
                            Icon(Icons.play_arrow_rounded, color: Colors.white),
                        onTap: model.afkCreditsBalance == 0 ||
                                model.screenTimePreset >
                                    model.totalAvailableScreenTime
                            ? null
                            : model.startScreenTime,
                        disabled: model.afkCreditsBalance == 0 ||
                            model.screenTimePreset >
                                model.totalAvailableScreenTime,
                        color: kcScreenTimeBlue,
                        title: model.afkCreditsBalance == 0 ||
                                model.screenTimePreset >
                                    model.totalAvailableScreenTime
                            ? "Not enough credits"
                            : "Start screen time"),
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
