import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/card_overlay_layout.dart';
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
              Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressBar(
                      widthProgressBar: screenWidth(context) - 160,
                      percentage: model.percentageOfNextLevel,
                      height: 20,
                      //currentLevel: "3",
                      nextLevel: "Level " + (model.currentLevel + 1).toString(),
                    ),
                    verticalSpaceSmall,
                    AfkCreditsText.subheading(
                        "${model.creditsToNextLevel} credits until the next level!",
                        align: TextAlign.left),
                  ],
                ),
              ),
              verticalSpaceMedium,
              Divider(),
              verticalSpaceMedium,
              AfkCreditsText.headingFour("Stats"),
              verticalSpaceSmall,
              verticalSpaceTiny,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SummaryStatsDisplay(
                      stats: model.currentUserStats.lifetimeEarnings.toString(),
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
                      stats: model.currentUserStats.totalScreenTime.toString(),
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
            ],
          ),
        ),
      ),
    );
  }
}
