import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

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
        color: kcWhiteTextColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(),
        boxShadow: [
          BoxShadow(
              blurRadius: 2,
              spreadRadius: 0.5,
              offset: Offset(1, 1),
              color: kcShadowColor),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Emojis.smile_partying_face, style: TextStyle(fontSize: 50)),
          verticalSpaceMedium,
          InsideOutText.headingFour(
            "You just earned", // "You are the best, you successfully finished the quest",
          ),
          verticalSpaceSmall,
          if (finishedQuest != null && finishedQuest!.afkCreditsEarned != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(kAFKCreditsLogoPath,
                    height: 24, color: kcPrimaryColor),
                horizontalSpaceTiny,
                InsideOutText.headingThree(
                    finishedQuest!.afkCreditsEarned.toString()),
                horizontalSpaceSmall,
                Icon(Icons.arrow_right_alt, size: 24),
                horizontalSpaceSmall,
                //Icon(Icons.schedule, color: kcScreenTimeBlue, size: 35),
                Image.asset(kScreenTimeIcon,
                    height: 24, color: kcScreenTimeBlue),
                horizontalSpaceTiny,
                InsideOutText.headingThree(
                    HerculesWorldCreditSystem.creditsToScreenTime(
                                finishedQuest!.afkCreditsEarned!)
                            .toString() +
                        " min"),
              ],
            ),
          verticalSpaceMedium,
          InsideOutButton(
            onTap: onContinuePressed,
            title: "Great",
            trailing: Icon(Icons.arrow_forward, size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
