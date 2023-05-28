import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/credits_system.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/screen_time/select_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class SelectScreenTimeView extends StatelessWidget {
  // wardId needs to be provided when accessing this view from the guardian account
  final String? wardId;
  const SelectScreenTimeView({Key? key, this.wardId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectScreenTimeViewModel>.reactive(
      viewModelBuilder: () => SelectScreenTimeViewModel(wardId: wardId),
      builder: (context, model, child) {
        return MainPage(
          showBackButton: !model.isGuardianAccount,
          resizeToAvoidBottomInset: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              title: "Choose time",
              onBackButton: model
                  .popView, //!model.isGuadriannAccount ? null : model.popView,
            ),
            floatingActionButton: model.isGuardianAccount
                ? BottomFloatingActionButtons(
                    // titleMain: "Add Credits",
                    // onTapMain: model.navigateToAddFundsView,
                    color: model.creditsBalance == 0 ||
                            model.screenTimePreset >
                                model.totalAvailableScreenTime
                        ? kcGreyTextColor
                        : kcPrimaryColor,
                    leadingMain:
                        Icon(Icons.play_arrow_rounded, color: Colors.white),
                    titleMain: model.creditsBalance == 0 ||
                            model.screenTimePreset >
                                model.totalAvailableScreenTime
                        ? "Not enough credits"
                        : "Start screen time",
                    onTapMain: model.creditsBalance == 0 ||
                            model.screenTimePreset >
                                model.totalAvailableScreenTime
                        ? null
                        : model.startScreenTime,
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: klHorizontalPadding),
              height: 1000 + screenHeight(context, percentage: 0.15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  verticalSpaceMedium,
                  Spacer(),
                  if (model.isGuardianAccount)
                    InsideOutText.body("Total available"),
                  if (model.isGuardianAccount) verticalSpaceTiny,
                  if (model.isGuardianAccount)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(kInsideOutLogoPath,
                            height: 18, color: kcPrimaryColor),
                        horizontalSpaceTiny,
                        InsideOutText.headingFourLight(
                            model.creditsBalance.toStringAsFixed(0)),
                        horizontalSpaceSmall,
                        Icon(Icons.arrow_right_alt, size: 20),
                        horizontalSpaceSmall,
                        Image.asset(kScreenTimeIcon,
                            height: 18, color: kcScreenTimeBlue),
                        horizontalSpaceTiny,
                        InsideOutText.headingFourLight(
                            model.totalAvailableScreenTime.toString() + " min"),
                      ],
                    ),
                  if (!model.isGuardianAccount)
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
                      Image.asset(kInsideOutLogoPath,
                          height: 18, color: kcPrimaryColor),
                      horizontalSpaceTiny,
                      InsideOutText.headingFourLight(
                          CreditsSystem.screenTimeToCredits(
                                  model.screenTimePreset)
                              .toString()),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        child: InsideOutButton.outline(
                          height: 60,
                          enabled: false,
                          title: "Custom",
                          onTap: () => model.selectCustomScreenTime(),
                          color: kcGreen,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  verticalSpaceTiny,
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
                                  ? kcGreen
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
                                  ? kcGreen
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
                              color: kcGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(height: model.isGuardianAccount ? 100 : 20),
                  if (!model.isGuardianAccount)
                    InsideOutButton(
                      leading:
                          Icon(Icons.play_arrow_rounded, color: Colors.white),
                      title: model.creditsBalance == 0 ||
                              model.screenTimePreset >
                                  model.totalAvailableScreenTime
                          ? "Not enough credits"
                          : "Start screen time",
                      onTap: model.creditsBalance == 0 ||
                              model.screenTimePreset >
                                  model.totalAvailableScreenTime
                          ? null
                          : model.startScreenTime,
                      busy: false,
                      color: model.creditsBalance == 0 ||
                              model.screenTimePreset >
                                  model.totalAvailableScreenTime
                          ? kcGreyTextColor
                          : kcPrimaryColor,
                    ),
                  if (!model.isGuardianAccount) Container(height: 75),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
