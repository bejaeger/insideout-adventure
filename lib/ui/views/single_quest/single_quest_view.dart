import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/active_minigame/active_minigame_view.dart';
import 'package:afkcredits/ui/views/single_quest/single_quest_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SingleQuestView extends StatelessWidget {
  final QuestType? questType;
  const SingleQuestView({Key? key, required this.questType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleQuestViewModel>.reactive(
      viewModelBuilder: () => SingleQuestViewModel(),
      builder: (context, model, child) => questType == null
          ? Container(
              child: Text(
                  "ERROR! This should never happen. You navigated to a single quest view without providing a quest category. Hopefully you are not a user of the app but a developer. Otherwise please help us and let the developers know immediately"),
            )
          : model.hasActiveQuest
              ? ActiveMiniGameView(questType: questType!)
              : Scaffold(
                  appBar: CustomAppBar(
                    title: describeEnum(questType.toString().toUpperCase()),
                    onBackButton: model.navigateBack,
                  ),
                  body: questType == QuestType.DistanceEstimate
                      ? DistanceEstimateCard(
                          onPressed: () => model.startMinigameQuest(questType!))
                      : questType == QuestType.VibrationSearch
                          ? VibrationSearchCard(
                              onPressed: () =>
                                  model.startMinigameQuest(questType!))
                          : null,
                ),
    );
  }
}

class DistanceEstimateCard extends StatelessWidget {
  final void Function() onPressed;
  const DistanceEstimateCard({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.cyan,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Estimate 500 Meters",
                      style: textTheme(context)
                          .headline5!
                          .copyWith(color: Colors.grey[200])),
                  ElevatedButton(
                      onPressed: onPressed, child: Text("Start quest")),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class VibrationSearchCard extends StatelessWidget {
  final void Function() onPressed;

  const VibrationSearchCard({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              color: Colors.cyan,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Listen to the vibrations!",
                      style: textTheme(context)
                          .headline5!
                          .copyWith(color: Colors.grey[200])),
                  ElevatedButton(
                      onPressed: onPressed, child: Text("Start quest")),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
