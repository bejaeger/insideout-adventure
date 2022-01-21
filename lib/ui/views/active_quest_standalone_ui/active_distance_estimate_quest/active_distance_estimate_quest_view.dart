import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/active_quest_drawer/active_quest_drawer_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/active_distance_estimate_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_slide_button.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/not_enough_sponsoring_note.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class ActiveDistanceEstimateQuestView extends StatelessWidget {
  final Quest quest;

  const ActiveDistanceEstimateQuestView({
    Key? key,
    required this.quest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveDistanceEstimateQuestViewModel>.reactive(
      viewModelBuilder: () => locator<ActiveDistanceEstimateQuestViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) {
        model.initialize(quest: quest);
        return;
      },
      builder: (context, model, child) {
        bool activeButton = model.hasActiveQuest;
        print(" ------------------------------------------- REBUILDING");
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
              ),
              endDrawer: SizedBox(
                width: screenWidth(context, percentage: 0.8),
                child: const ActiveQuestDrawerView(),
              ),
              floatingActionButton: !model.questSuccessfullyFinished &&
                      model.hasActiveQuest
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if (model.hasActiveQuest)
                      //   AFKProgressIndicator(linear: true),
                      verticalSpaceMedium,
                      // Text(
                      //     "Instructions: Start the quest and then walk ${model.distanceToTravel.toStringAsFixed(0)} meters (air distance). If you think the distance is correct, check it. You only have $kNumberTriesToRevealDistance of tries!"),
                      Text(
                          "Goal: Walk " +
                              model.distanceToTravel.toStringAsFixed(0) +
                              " Meters",
                          textAlign: TextAlign.center,
                          style: textTheme(context)
                              .headline3!
                              .copyWith(color: kPrimaryColor)),
                      verticalSpaceSmall,
                      if (!model.hasActiveQuest)
                        Image.network(
                            "https://c.tenor.com/PcfXDVatyLEAAAAC/guy-walking.gif",
                            height: 150),
                      verticalSpaceMedium,
                      model.questSuccessfullyFinished
                          ? Column(
                              children: [
                                Text("You are the best, you finished the quest",
                                    textAlign: TextAlign.center,
                                    style: textTheme(context).headline2),
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
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    if (!model.hasActiveQuest)
                                      ElevatedButton(
                                          onPressed: model.showInstructions,
                                          child: Text("Instructions",
                                              style: textTheme(context)
                                                  .headline6!
                                                  .copyWith(
                                                      color: kWhiteTextColor))),
                                    // if (model.hasActiveQuest)
                                    //   Flexible(
                                    //     child: Column(
                                    //       children: [
                                    //         ElevatedButton(
                                    //           onPressed:
                                    //               model.probeDistance,
                                    //           child: (model.isBusy &&
                                    //                   model.hasActiveQuest)
                                    //               ? AFKProgressIndicator(
                                    //                   color:
                                    //                       kWhiteTextColor)
                                    //               : Text("Update Location",
                                    //                   style: textTheme(
                                    //                           context)
                                    //                       .headline6!
                                    //                       .copyWith(
                                    //                           color:
                                    //                               kWhiteTextColor)),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                  ],
                                ),
                                verticalSpaceMedium,
                                if (model.showStartSwipe && !model.isBusy)
                                  AFKSlideButton(
                                    quest: quest,
                                    canStartQuest: model.hasEnoughSponsoring(
                                      quest: quest,
                                    ),
                                    onSubmit: () =>
                                        model.maybeStartQuest(quest: quest),
                                  ),
                                if (!model.hasEnoughSponsoring(quest: quest))
                                  Container(
                                      color: Colors.white,
                                      child: NotEnoughSponsoringNote(
                                          topPadding: 10)),
                                verticalSpaceMedium,
                                AnimatedOpacity(
                                  opacity: !model.startedQuest ? 0.0 : 1.0,
                                  duration: Duration(seconds: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                              child: Text(
                                                  model.distanceTravelled
                                                          .toStringAsFixed(0) +
                                                      " m",
                                                      //maxLines: 1,
                                                  style: textTheme(context)
                                                      .headline2),
                                            ),
                                            Text("Distance on last check",
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: textTheme(context)
                                                    .bodyText2),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                model.numberOfAvailableTries
                                                    .toString(),
                                                style: textTheme(context)
                                                    .headline2),
                                            Text("Available Tries",
                                                textAlign: TextAlign.center,
                                                style: textTheme(context)
                                                    .bodyText2),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                verticalSpaceLarge,
                              ],
                            ),
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
