import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/active_distance_estimate_quest_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_quest_standalone_ui_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_vibration_search_quest/active_vibration_search_quest_view.dart';
import 'package:afkcredits/ui/views/map/map_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ActiveQuestStandaloneUIView extends StatelessWidget {
  final Quest? quest;
  const ActiveQuestStandaloneUIView({Key? key, required this.quest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveQuestStandaloneUIViewModel>.reactive(
        viewModelBuilder: () => ActiveQuestStandaloneUIViewModel(),
        builder: (context, model, child) {
          final currentQuest = quest ?? model.activeQuest.quest;
          return currentQuest.type == QuestType.DistanceEstimate
              ? ActiveDistanceEstimateQuestView(
                  quest: quest,
                )
              : currentQuest.type == QuestType.VibrationSearch
                  ? ActiveVibrationSearchQuestView(
                      quest: quest,
                      onPressed: () => null,
                      lastDistance:
                          model.activeQuestNullable?.lastDistanceInMeters,
                      currentDistance:
                          model.activeQuestNullable?.currentDistanceInMeters)
                  : currentQuest.type == QuestType.Hike
                      ? MapView()
                      : Text(
                          "ERROR! Active quest view requested with unknown type. This should be reported to a developer. Thank you!");
        });
  }
}
