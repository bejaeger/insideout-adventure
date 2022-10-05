import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/quest_specifications_row.dart';
import 'package:afkcredits/ui/widgets/quest_type_tag.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class CommonQuestDetailsHeader extends StatelessWidget {
  final bool hasActiveQuest;
  final void Function()? openSuperUserSettingsDialog;
  final void Function(QuestType?) showInstructionsDialog;
  final Quest? quest;
  const CommonQuestDetailsHeader({
    Key? key,
    required this.quest,
    this.hasActiveQuest = false,
    this.openSuperUserSettingsDialog,
    required this.showInstructionsDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // color gradient
        IgnorePointer(
          ignoring: true,
          child: Container(
            // openSuperUserSettingsDialog only used in explorer view!
            height: openSuperUserSettingsDialog != null ? 400 : 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.7),
                ],
                stops: [0.0, 1.0],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),

        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: openSuperUserSettingsDialog != null
                          ? () => openSuperUserSettingsDialog!()
                          : null,
                      child: QuestTypeTag(quest: quest),
                    ),
                    if (quest != null)
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: hasActiveQuest ? 4.0 : 0,
                            right: hasActiveQuest ? 45.0 : 0),
                        child: GestureDetector(
                          onTap: () => showInstructionsDialog(quest?.type),
                          //title: "Tutorial",
                          //color: kPrimaryColor.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.help_outline,
                                color: Colors.black, size: 30),
                          ),
                        ),
                      ),
                  ],
                ),
                verticalSpaceTiny,
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CreditsAmount(
                        amount: quest?.afkCredits ?? -1,
                        height: 24,
                        textColor: kcPrimaryColor,
                      ),
                      horizontalSpaceSmall,
                      AfkCreditsText.headingThree("-"),
                      horizontalSpaceSmall,
                      Expanded(
                        child: Text(quest?.name ?? "QUEST",
                            style: heading3Style.copyWith(
                                overflow: TextOverflow.ellipsis),
                            maxLines: 2),
                      ),
                    ],
                  ),
                ),
                verticalSpaceSmall,
                if (!hasActiveQuest)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: QuestSpecificationsRow(quest: quest),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
