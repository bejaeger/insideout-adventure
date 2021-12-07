import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/active_minigame/active_minigame_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ActiveMiniGameView extends StatelessWidget {
  final QuestType questType;
  const ActiveMiniGameView({Key? key, required this.questType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveMiniGameViewModel>.reactive(
      viewModelBuilder: () => ActiveMiniGameViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: describeEnum(questType.toString().toUpperCase()),
          onBackButton: model.navigateBack,
        ),
        body: questType == QuestType.DistanceEstimate && !model.isBusy
            ? StartDistanceEstimateCard(onPressed: model.revealDistance)
            : !model.isBusy
                ? StartVibrationSearchCard(
                    onPressed: () => null,
                    lastDistance:
                        model.activeQuestNullable?.lastDistanceInMeters,
                    currentDistance:
                        model.activeQuestNullable?.currentDistanceInMeters)
                : CircularProgressIndicator(),
      ),
    );
  }
}

class StartDistanceEstimateCard extends StatelessWidget {
  final void Function() onPressed;
  const StartDistanceEstimateCard({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        verticalSpaceMediumLarge,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 200, height: 200, color: Colors.cyan),
          ],
        ),
        verticalSpaceMediumLarge,
        Text("Walk 500 meters"),
        ElevatedButton(onPressed: onPressed, child: Text("Reveal Distance"))
      ],
    );
  }
}

class StartVibrationSearchCard extends StatelessWidget {
  final void Function() onPressed;
  final double? lastDistance;
  final double? currentDistance;

  const StartVibrationSearchCard({
    Key? key,
    required this.onPressed,
    this.lastDistance,
    this.currentDistance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceMediumLarge,
          verticalSpaceMediumLarge,
          Text("Listen to the vibrations!"),
          verticalSpaceMedium,
          if (currentDistance != null)
            Text("Current Distance: $currentDistance",
                style: textTheme(context).headline6),
          if (lastDistance != null) Text("Last Distance: $lastDistance"),
        ],
      ),
    );
  }
}
