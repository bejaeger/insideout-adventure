import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/info_container.dart';
import 'package:afkcredits/ui/widgets/quest_specifications_row.dart';
import 'package:afkcredits/ui/widgets/quest_type_tag.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class CommonQuestDetailsHeader extends StatelessWidget {
  final bool hasActiveQuest;
  final bool hasActiveQuestToBeStarted;
  final void Function()? openSuperUserSettingsDialog;
  final void Function(QuestType?) showInstructionsDialog;
  final Quest? quest;
  final ActivatedQuest? finishedQuest;
  final bool completed;
  final bool isGuardianAccount;
  const CommonQuestDetailsHeader({
    Key? key,
    required this.quest,
    this.hasActiveQuest = false,
    this.openSuperUserSettingsDialog,
    required this.showInstructionsDialog,
    this.finishedQuest,
    this.completed = false,
    this.hasActiveQuestToBeStarted = false,
    required this.isGuardianAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // color gradient
        IgnorePointer(
          ignoring: true,
          child: Container(
            // openSuperUserSettingsDialog only used in ward view!
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

        if (hasActiveQuestToBeStarted) AFKProgressIndicator(),

        if (!hasActiveQuestToBeStarted)
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
                              right: hasActiveQuest ? 50.0 : 0),
                          child: IconButton(
                            icon: Icon(Icons.help_outline,
                                color: Colors.black, size: 30),
                            onPressed: () =>
                                showInstructionsDialog(quest?.type),
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
                        InsideOutText.headingThree("-"),
                        horizontalSpaceSmall,
                        Expanded(
                          child: Text(
                            quest?.name ?? "QUEST",
                            style: heading3Style.copyWith(
                                // decoration: finishedQuest != null
                                //     ? TextDecoration.lineThrough
                                //     : null,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 2,
                          ),
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
                  if (finishedQuest != null || completed)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Completed",
                        style: heading3Style.copyWith(
                            color: kcPrimaryColor,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                    ),
                  if (quest != null &&
                      !completed &&
                      !hasActiveQuest &&
                      finishedQuest == null)
                    verticalSpaceSmall,
                  if (quest != null &&
                      !completed &&
                      !isGuardianAccount &&
                      !hasActiveQuest &&
                      finishedQuest == null)
                    InfoContainer(
                      child: Text.rich(
                        style: bodyStyleSofia,
                        TextSpan(
                          children: [
                            TextSpan(text: "Earn "),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Image.asset(kAFKCreditsLogoPath,
                                  color: kcPrimaryColor, height: 18),
                            ),
                            TextSpan(
                              text: " " + quest!.afkCredits.toStringAsFixed(0),
                              style: TextStyle(
                                  color: kcPrimaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: " by ",
                            ),
                            quest!.type == QuestType.TreasureLocationSearch
                                ? TextSpan(
                                    text: "finding ",
                                  )
                                : TextSpan(
                                    text: "collecting ",
                                  ),
                            TextSpan(
                              text: "all checkpoints",
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (quest != null &&
                      quest!.type == QuestType.TreasureLocationSearch &&
                      isGuardianAccount)
                    InfoContainer(
                        child: InsideOutText.body(
                            "Only the start marker is visible to children.")),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
