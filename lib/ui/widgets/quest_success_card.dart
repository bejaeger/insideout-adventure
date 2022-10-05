import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class QuestSuccessCard extends StatelessWidget {
  final void Function() onContinuePressed;
  final ActivatedQuest? finishedQuest;
  const QuestSuccessCard({
    Key? key,
    required this.onContinuePressed,
    this.finishedQuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: kcGreenWhiter,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.3,
            spreadRadius: 0.4,
            offset: Offset(1, 1),
            color: kcShadowColor,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AfkCreditsText.headingFour(
            "You mastered this mission!", // "You are the best, you successfully finished the quest",
          ),
          verticalSpaceMedium,
          AfkCreditsButton(
            onTap: onContinuePressed,
            title: "Continue",
          ),
        ],
      ),
    );
  }
}
