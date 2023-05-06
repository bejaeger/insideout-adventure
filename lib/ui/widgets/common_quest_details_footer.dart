import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/quest_details_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits/ui/widgets/quest_completed_note.dart';
import 'package:afkcredits/ui/widgets/quest_success_card.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';

class CommonQuestDetailsFooter extends StatelessWidget {
  final QuestDetailsOverlayViewModel model;
  final Quest quest;
  const CommonQuestDetailsFooter({
    Key? key,
    required this.quest,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showNotCloseToQuest =
        (model.isNearStartMarker || model.previouslyFinishedQuest != null) &&
            (!model.hasActivatedQuestToBeStarted && !model.hasActiveQuest);
    return Stack(
      children: [
        // TODO: Here we have the option to show a statistics display cause the
        // TODO: quest is finished but we still have the previouslyFinishedQuest
        if (model.previouslyFinishedQuest != null && !model.isBusy)
          aboveBottomBackButton(
            child: QuestSuccessCard(
                onContinuePressed: model.popQuestDetails,
                finishedQuest: model.previouslyFinishedQuest),
          ),
        aboveBottomBackButton(
          child: model.showCompletedQuestNote()
              ? QuestCompletedNote(
                  onTap: model.switchRedoQuestAndRebuildUI,
                  repeatable:
                      (quest.repeatable == 1 || model.useSuperUserFeatures))
              : !showNotCloseToQuest // specicif quest UI will show the start slider
                  ? SizedBox(height: 0, width: 0)
                  : NotCloseToQuestNote(
                      animateCameraToQuestMarkers:
                          model.animateCameraToQuestMarkers,
                      animateCameraToUserPosition:
                          model.animateCameraToUserPosition,
                    ),
        ),
      ],
    );
  }
}
