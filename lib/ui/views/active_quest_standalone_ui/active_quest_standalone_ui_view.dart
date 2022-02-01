import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/active_distance_estimate_quest_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_qrcode_search/active_qrcode_search_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_quest_standalone_ui_viewmodel.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_view.dart';
import 'package:afkcredits/ui/views/map/map_overview_view.dart';
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
                  quest: currentQuest,
                )
              : currentQuest.type == QuestType.TreasureLocationSearch
                  ? ActiveTreasureLocationSearchQuestView(
                      quest: currentQuest,
                    )
                  : currentQuest.type == QuestType.QRCodeHike
                      ? MapOverviewView()
                      : currentQuest.type == QuestType.QRCodeSearch
                          ? ActiveQrCodeSearchView(quest: currentQuest)
                          : Text(
                              "ERROR! Active quest view requested with unknown type. This should be reported to a developer. Thank you!");
        });
  }
}
