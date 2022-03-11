import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/active_quest_drawer/active_quest_drawer_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/active_distance_estimate_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/live_quest_statistic.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:transparent_image/transparent_image.dart';

class ActiveDistanceEstimateQuestView extends StatelessWidget {
  final Quest quest;

  const ActiveDistanceEstimateQuestView({
    Key? key,
    required this.quest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveDistanceEstimateQuestViewModel>.reactive(
      viewModelBuilder: () => ActiveDistanceEstimateQuestViewModel(),
      onModelReady: (model) {
        model.initialize(quest: quest);
        return;
      },
      builder: (context, model, child) {
        bool activeButton = model.hasActiveQuest;
        return WillPopScope(
          onWillPop: () async {
            if (!model.hasActiveQuest) {
              model.navigateBackFromSingleQuestView();
            }
            return false;
          },
          child: SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: "Estimating Distance",
                onBackButton: model.navigateBackFromSingleQuestView,
                showRedLiveButton: true,
                onAppBarButtonPressed: model.hasActiveQuest
                    ? null
                    : () => model.showInstructions(),
                appBarButtonIcon: Icons.help,
              ),
              endDrawer: SizedBox(
                width: screenWidth(context, percentage: 0.8),
                child: const ActiveQuestDrawerView(),
              ),
              floatingActionButton:
                  !model.questSuccessfullyFinished && model.hasActiveQuest
                      ? AFKFloatingActionButton(
                          backgroundColor: model.hasActiveQuest
                              ? Colors.orange.shade400
                              : Colors.grey[600],
                          width: 100,
                          height: 100,
                          onPressed:
                              !activeButton ? () => null : model.probeDistance,
                          icon: Shimmer.fromColors(
                            baseColor:
                                activeButton ? Colors.black : Colors.grey[200]!,
                            highlightColor: Colors.white,
                            period: const Duration(milliseconds: 1000),
                            enabled: activeButton,
                            child: Column(
                              children: [
                                Image.asset(
                                  kRulerIconPath,
                                  width: 50,
                                ),
                                Text("Measure")
                              ],
                            ),
                          ),
                        )
                      : null,
              body: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // decoration: BoxDecoration(
                        //   boxShadow: [
                        //     BoxShadow(
                        //         offset: Offset(0, 100),
                        //         blurRadius: 4,
                        //         spreadRadius: 2,
                        //         color: kShadowColor)
                        //   ],
                        // ),
                        alignment: Alignment.center,
                        height: 100,
                        child: model.isBusy
                            ? AFKProgressIndicator()
                            : Stack(
                                children: [
                                  AnimatedOpacity(
                                      opacity: model.showStartSwipe ? 1 : 0,
                                      duration: Duration(milliseconds: 50),
                                      child: AFKSlideButton(
                                          //alignment: Alignment(0, 0),
                                          quest: quest,
                                          canStartQuest:
                                              model.hasEnoughSponsoring(
                                                  quest: quest),
                                          onSubmit: () => model.maybeStartQuest(
                                              quest: quest))),
                                  AnimatedOpacity(
                                    opacity: model.hasActiveQuest ? 1 : 0,
                                    duration: Duration(seconds: 1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        LiveQuestStatistic(
                                          title: "Distance on last check",
                                          statistic: model.distanceTravelled
                                                  .toStringAsFixed(0) +
                                              " m",
                                        ),
                                        LiveQuestStatistic(
                                          title: "Available Tries",
                                          statistic: model.hasActiveQuest
                                              ? model.numberOfAvailableTries
                                                  .toString()
                                              : "0",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      verticalSpaceLarge,
                      // Text(
                      //     "Instructions: Start the quest and then walk ${model.distanceToTravel.toStringAsFixed(0)} meters (air distance). If you think the distance is correct, check it. You only have $kNumberTriesToRevealDistance of tries!"),
                      if (!model.questSuccessfullyFinished)
                        Container(
                          height: 180,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 0.1,
                                  offset: Offset(1, 1),
                                  color: kShadowColor)
                            ],
                          ),
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  "https://c.tenor.com/PcfXDVatyLEAAAAC/guy-walking.gif"),
                        ),
                      verticalSpaceMedium,
                      if (!model.questSuccessfullyFinished)
                        Text(
                            "Walk " +
                                model.distanceToTravel.toStringAsFixed(0) +
                                " Meters",
                            textAlign: TextAlign.center,
                            style: textTheme(context).headline5!.copyWith(
                                color: kDarkTurquoise,
                                fontWeight: FontWeight.w600)),
                      verticalSpaceMedium,
                      model.questSuccessfullyFinished
                          ? Column(
                              children: [
                                Text("You are the best, you finished the quest",
                                    textAlign: TextAlign.center,
                                    style: textTheme(context).headline4),
                                verticalSpaceMedium,
                                ElevatedButton(
                                    onPressed: () => model.replaceWithMainView(
                                        index: BottomNavBarIndex.quest),
                                    child: Text("More Quests",
                                        style: textTheme(context)
                                            .headline6!
                                            .copyWith(color: kWhiteTextColor))),
                              ],
                            )
                          : SizedBox(
                              height: 0,
                              width: 0,
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
