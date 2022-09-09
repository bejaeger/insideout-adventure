import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/card_overlay_layout.dart';
import 'package:afkcredits/ui/views/explorer_account/explorer_account_viewmodel.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/avatar_view.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ExplorerAccountView extends StatelessWidget {
  const ExplorerAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("==>> Rebuild ExplorerAccountView");
    return ViewModelBuilder<ExplorerAccountViewModel>.reactive(
      viewModelBuilder: () => ExplorerAccountViewModel(),
      onModelReady: (model) => model.listenToLayout(),
      builder: (context, model, child) => AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        top: model.isShowingExplorerAccount ? 0 : -screenHeight(context),
        curve: Curves.easeOutCubic,
        left: 0,
        right: 0,
        child: CardOverlayLayout(
          onBack: model.removeExplorerAccountOverlay,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AfkCreditsText.headingThree(model.currentUser.fullName),
              SizedBox(height: 2),
              AfkCreditsText.body(
                  "Level ${model.currentLevel}: ${model.currentLevelName}"),
              verticalSpaceMedium,
              //AfkCreditsText.headingFour("Stats"),
              // verticalSpaceSmall,
              // verticalSpaceTiny,
              Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AfkCreditsText.subheadingItalic("Earn",
                            align: TextAlign.left),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0, right: 2.0),
                          child: Image.asset(
                            kAFKCreditsLogoPath,
                            color: kcPrimaryColor,
                            height: 18.0,
                          ),
                        ),
                        AfkCreditsText.subheadingItalic(
                            "${model.creditsToNextLevel} to reach the next level!",
                            align: TextAlign.left),
                      ],
                    ),
                    verticalSpaceSmall,
                    ProgressBar(
                      widthProgressBar: screenWidth(context) - 80,
                      percentage: model.percentageOfNextLevel,
                      height: 25,
                      //currentLevel: "3",
                      //nextLevel: "Level " + (model.currentLevel + 1).toString(),
                    ),
                    verticalSpaceTiny,
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: screenWidth(context) - 80),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(kAFKCreditsLogoSmallPathColored,
                              color: kcPrimaryColor, height: 25),
                          horizontalSpaceSmall,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              horizontalSpaceTiny,
                              AfkCreditsText.statsStyleBlack(model
                                  .currentUserStats.lifetimeEarnings
                                  .toString()),
                              AfkCreditsText.caption("Total collected"),

                              // horizontalSpaceLarge,
                              // horizontalSpaceLarge,
                              // horizontalSpaceMedium,
                              // horizontalSpaceSmall,
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AfkCreditsText.statsStyle(
                                  model.creditsForNextLevel.toString()),
                              AfkCreditsText.caption("Next level"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceMedium,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expanded(
                  //   child: SummaryStatsDisplay(
                  //     stats: model.currentUserStats.lifetimeEarnings.toString(),
                  //     title: "Total collected",
                  //     icon: Image.asset(
                  //       kAFKCreditsLogoPath,
                  //       color: kcPrimaryColor,
                  //       width: 20,
                  //     ),
                  //   ),
                  // ),
                  // horizontalSpaceSmall,
                  Row(
                    children: [
                      Image.asset(kActivityIcon,
                          color: kcActivityIconColor, height: 25),
                      horizontalSpaceSmall,
                      SummaryStatsDisplay(
                        stats: model.currentUserStats.numberQuestsCompleted
                            .toString(),
                        title: "Completed quests",
                      ),
                    ],
                  ),
                  horizontalSpaceSmall,
                  verticalSpaceMedium,
                  Row(
                    children: [
                      Image.asset(kScreenTimeIcon,
                          color: kcScreenTimeBlue, height: 25),
                      horizontalSpaceSmall,
                      SummaryStatsDisplay(
                        stats:
                            model.currentUserStats.totalScreenTime.toString(),
                        title: "Total screen time",
                        unit: "min",
                      ),
                    ],
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
