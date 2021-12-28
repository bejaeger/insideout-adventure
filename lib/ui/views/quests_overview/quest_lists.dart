import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/quest_category_card.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class QuestLists extends StatelessWidget {
  final QuestsOverviewViewModel model;
  const QuestLists({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Actually I meant this one should be the quest Categories.
    return RefreshIndicator(
      onRefresh: () async => model.initialize(force: true),
      child: ListView(
        children: [
          verticalSpaceMedium,
          SectionHeader(title: "Near You"),
          Container(
            height: 220,
            child: ListView(
              //itemExtent: 120,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                ...model.nearbyQuests
                    .asMap()
                    .map((index, quest) {
                      return MapEntry(
                        index,
                        QuestInfoCard(
                          height: 200,
                          marginRight: 5,
                          width: screenWidth(context, percentage: 0.8),
                          quest: quest,
                          subtitle: quest.description,
                          onCardPressed: () async =>
                              await model.onQuestInListTapped(quest),
                        ),
                      );
                    })
                    .values
                    .toList(),
                verticalSpaceLarge,
              ],
            ),
          ),
          verticalSpaceSmall,
          SectionHeader(title: "Types"),
          Container(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics:
                  NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              children: [
                ...model.questTypes
                    .map(
                      (e) => QuestCategoryCard(
                        onPressed: model.navigateToQuestsOfSpecificTypeView,
                        category: e,
                        backgroundColor: getColorOfType(e),
                      ),
                    )
                    .toList(),
                // QuestCategoryCard(
                //     onPressed: model.navigateToQuestsOfSpecificTypeView,
                //     category: QuestType.DistanceEstimate)
              ],
            ),
          ),
          verticalSpaceMassive,
        ],
      ),
    );
  }
}
