import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/active_distance_estimate_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ActiveDistanceEstimateQuestView extends StatelessWidget {
  final Quest? quest;

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
          print(" ------------------------------------------- REBUILDING");
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: "Estimating Distance",
                onBackButton: model.navigateBack,
              ),
              body: model.isBusy
                  ? AFKProgressIndicator()
                  : Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kHorizontalPadding),
                        child: ListView(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // if (model.hasActiveQuest)
                                //   AFKProgressIndicator(linear: true),
                                verticalSpaceMedium,
                                // Text(
                                //     "Instructions: Start the quest and then walk ${model.distanceToTravel.toStringAsFixed(0)} meters (air distance). If you think the distance is correct, check it. You only have $kNumberTriesToRevealDistance of tries!"),
                                Text(
                                    "Goal: Walk " +
                                        model.distanceToTravel
                                            .toStringAsFixed(0) +
                                        " Meters",
                                    style: textTheme(context)
                                        .headline6!
                                        .copyWith(color: kPrimaryColor)),
                                verticalSpaceSmall,
                                Image.network(
                                    "https://c.tenor.com/PcfXDVatyLEAAAAC/guy-walking.gif",
                                    height: 150),
                                verticalSpaceMedium,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: model.showInstructions,
                                        child: Text("Instructions",
                                            style: textTheme(context)
                                                .headline6!
                                                .copyWith(
                                                    color: kWhiteTextColor))),
                                    !model.hasActiveQuest
                                        ? Flexible(
                                            child: Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: model
                                                          .hasEnoughSponsoring(
                                                              quest: quest)
                                                      ? () =>
                                                          model.maybeStartQuest(
                                                              quest: quest)
                                                      : null,
                                                  child: Text("Start Quest",
                                                      style: textTheme(context)
                                                          .headline6!
                                                          .copyWith(
                                                              color:
                                                                  kWhiteTextColor)),
                                                ),
                                                if (!model.hasEnoughSponsoring(
                                                    quest: quest))
                                                  Text(
                                                      "You don't have enough sponsoring to start the quest",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                              ],
                                            ),
                                          )
                                        : Flexible(
                                            child: Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed:
                                                      model.revealDistance,
                                                  child: Text("Check Distance",
                                                      style: textTheme(context)
                                                          .headline6!
                                                          .copyWith(
                                                              color:
                                                                  kWhiteTextColor)),
                                                ),
                                                // Text(
                                                //  "Your start position has been tagged"),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                                verticalSpaceMedium,

                                AnimatedOpacity(
                                  opacity: !model.startedQuest ? 0.0 : 1.0,
                                  duration: Duration(seconds: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Text("Distance on last check",
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: textTheme(context)
                                                    .headline6),
                                            Text(
                                                model.distanceTravelled
                                                        .toStringAsFixed(0) +
                                                    " meters",
                                                style: textTheme(context)
                                                    .headline4),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text("Available Tries",
                                                textAlign: TextAlign.center,
                                                style: textTheme(context)
                                                    .headline6),
                                            Text(
                                                model.numberOfAvailableTries
                                                    .toString(),
                                                style: textTheme(context)
                                                    .headline3),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                verticalSpaceMedium,

                                if (model.userIsAdmin &&
                                    model.currentSpeed != null)
                                  Text("Current Speed",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: textTheme(context).headline6),
                                if (model.userIsAdmin &&
                                    model.currentSpeed != null)
                                  Text(
                                      model.currentSpeed!.toStringAsFixed(1) +
                                          "m",
                                      style: textTheme(context).headline4),
                                if (model.userIsAdmin &&
                                    model.currentAccuracy != null)
                                  Text("Current Accuracy",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: textTheme(context).headline6),
                                if (model.userIsAdmin &&
                                    model.currentAccuracy != null)
                                  Text(
                                      model.currentAccuracy!
                                              .toStringAsFixed(1) +
                                          "m",
                                      style: textTheme(context).headline4),
                                verticalSpaceLarge,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        });
  }
}
