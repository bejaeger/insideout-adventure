import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/quest_details_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/not_close_to_quest_note.dart';
import 'package:afkcredits/ui/widgets/quest_completed_note.dart';
import 'package:afkcredits/ui/widgets/quest_success_card.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class CommonQuestDetailsFooter extends StatelessWidget {
  final QuestDetailsOverlayViewModel model;
  final Quest quest;
  const CommonQuestDetailsFooter({
    Key? key,
    required this.quest,
    required this.model,
    //required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              : model.isNearStartMarker ||
                      model.previouslyFinishedQuest !=
                          null // specicif quest UI will show the start slider
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
