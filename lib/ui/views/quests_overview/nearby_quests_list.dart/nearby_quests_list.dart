import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class NearbyQuestsList extends StatelessWidget {
  final QuestsOverviewViewModel model;
  const NearbyQuestsList({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => model.initialize(force: true),
      child: ListView(
        //itemExtent: 120,
        //shrinkWrap: true,
        children: [
          ...model.nearbyQuests
              .asMap()
              .map((index, quest) {
                return MapEntry(
                    index,
                    QuestInfoCard(
                        height: 140,
                        quest: quest,
                        subtitle: quest.description,
                        onCardPressed: () async =>
                            await model.onQuestInListTapped(quest)));
              })
              .values
              .toList(),
          verticalSpaceLarge,
        ],
      ),
    );
  }
}
