import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/card_overlay_layout.dart';
import 'package:afkcredits/ui/views/explorer_account/explorer_account_viewmodel.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/avatar_overlay.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:insideout_ui/insideout_ui.dart';
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
          child: model.currentUserNullable == null
              ? SizedBox(height: 0, width: 0)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: model.showAndHandleAvatarSelection,
                          child: Stack(
                            children: [
                              Container(
                                height: 75,
                                width: 50,
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 7),
                                  CircleAvatar(
                                    maxRadius: 32,
                                    backgroundColor: Colors.grey[200],
                                    child: Image.asset(
                                        model.avatarIdx == 1
                                            ? kLottieChillDudeHeadPng
                                            : kLottieWalkingGirlPng,
                                        height: 40),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(height: 51),
                                    Row(
                                      children: [
                                        SizedBox(width: 42),
                                        Icon(
                                          Icons.edit,
                                          color: kcPrimaryColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        horizontalSpaceRegular,
                        Expanded(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InsideOutText.headingTwo(
                                  model.currentUserNullable?.fullName ?? ""),
                              SizedBox(height: 2),
                              InsideOutText.body(
                                  "Level ${model.currentLevel()}: ${model.currentLevelName}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium,
                    verticalSpaceSmall,
                    //InsideOutText.headingFour("Stats"),
                    // verticalSpaceSmall,
                    // verticalSpaceTiny,
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: screenWidth(context) - 80),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              horizontalSpaceTiny,
                              SummaryStatsDisplay(
                                icon: Image.asset(
                                    kAFKCreditsLogoSmallPathColored,
                                    color: kcPrimaryColor,
                                    height: 25),
                                stats: model.currentUserStats.lifetimeEarnings
                                    .toString(),
                                title: "Total collected",
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SummaryStatsDisplay(
                                  icon: Image.asset(
                                      kAFKCreditsLogoSmallPathColored,
                                      color: kcPrimaryColor.withOpacity(0.7),
                                      height: 25),
                                  stats: model.creditsForNextLevel.toString(),
                                  statsStyle: statsStyle,
                                  title: "Next level",
                                  titleStyle: captionStyle.copyWith(
                                      color: kcGreyTextColor.withOpacity(0.7))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceTiny,
                    Align(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProgressBar(
                            widthProgressBar: screenWidth(context) - 80,
                            percentage: model.percentageOfNextLevel,
                            height: 25,
                          ),
                          verticalSpaceSmall,
                          Wrap(
                            children: [
                              InsideOutText.headingFourLight("Earn",
                                  align: TextAlign.left),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0, right: 2.0),
                                child: Image.asset(
                                  kAFKCreditsLogoPath,
                                  color: kcPrimaryColor,
                                  height: 20.0,
                                ),
                              ),
                              InsideOutText.headingFourLight(
                                  "${model.creditsToNextLevel} ",
                                  align: TextAlign.left),
                              Text("to reach the next level!",
                                  style: heading4LightStyle.copyWith(),
                                  textAlign: TextAlign.left,
                                  maxLines: 2),
                            ],
                          ),
                          verticalSpaceTiny,
                        ],
                      ),
                    ),
                    verticalSpaceMedium,
                    verticalSpaceSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        horizontalSpaceSmall,
                        SummaryStatsDisplay(
                          icon: Image.asset(kActivityIcon,
                              color: kcActivityIconColor, height: 25),
                          stats: model.currentUserStats.numberQuestsCompleted
                              .toString(),
                          title: "Completed quests",
                        ),
                        horizontalSpaceSmall,
                        verticalSpaceMedium,
                        horizontalSpaceSmall,
                        SummaryStatsDisplay(
                          icon: Image.asset(kScreenTimeIcon,
                              color: kcScreenTimeBlue, height: 25),
                          stats:
                              model.currentUserStats.totalScreenTime.toString(),
                          title: "Total screen time",
                          unit: "min",
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
