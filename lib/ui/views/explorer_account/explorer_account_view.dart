import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/views/explorer_account/explorer_account_viewmodel.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/avatar_view.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ExplorerAccountView extends StatelessWidget {
  const ExplorerAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double height = 400;
    const double offset = 80;
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
        child: Stack(
          children: [
            // to dismiss the dialog when tapped outside
            Container(
              height: screenHeight(context),
              width: screenWidth(context),
              child: GestureDetector(
                onTap: model.removeExplorerAccountOverlay,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: offset),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 5.0),
                height: height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        //colors: [Colors.white, kcPrimaryColor],
                        colors: [Colors.white, kcYellow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.2, 1]),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0.5,
                        spreadRadius: 0.6,
                        //offset: Offset(1, 1),
                        color: kcShadowColor,
                      )
                    ],
                    //color: kcCultured,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AfkCreditsText.headingThree(model.currentUser.fullName),
                    AfkCreditsText.body(
                        "Level ${model.currentLevel}: ${model.currentLevelName}"),
                    verticalSpaceSmall,
                    Align(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProgressBar(
                            widthProgressBar: screenWidth(context) - 160,
                            percentage: model.percentageOfNextLevel,
                            height: 20,
                            //currentLevel: "3",
                            nextLevel:
                                "Level " + (model.currentLevel + 1).toString(),
                          ),
                          verticalSpaceSmall,
                          AfkCreditsText.bodyItalic(
                              "Earn ${model.creditsToNextLevel} more credits to get to the next level"),
                        ],
                      ),
                    ),
                    verticalSpaceSmall,
                    Divider(),
                    verticalSpaceSmall,
                    AfkCreditsText.headingFour("Stats"),
                    verticalSpaceSmall,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SummaryStatsDisplay(
                            stats: model.currentUserStats.lifetimeEarnings
                                .toString(),
                            title: "Total collected",
                            icon: Image.asset(
                              kAFKCreditsLogoPath,
                              color: kcPrimaryColor,
                              width: 20,
                            ),
                          ),
                        ),
                        horizontalSpaceSmall,
                        Expanded(
                          child: SummaryStatsDisplay(
                            stats: model.currentUserStats.totalScreenTime
                                .toString(),
                            title: "Total screen time",
                            unit: "min",
                          ),
                        ),
                        horizontalSpaceSmall,
                        Expanded(
                          child: SummaryStatsDisplay(
                            stats: model.currentUserStats.numberQuestsCompleted
                                .toString(),
                            title: "Completed quests",
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    AfkCreditsButton.text(
                      title: "Back",
                      onTap: model.removeExplorerAccountOverlay,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
