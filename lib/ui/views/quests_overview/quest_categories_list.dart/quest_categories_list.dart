import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/quest_category_card.dart';
import 'package:flutter/material.dart';

class QuestsCategoryList extends StatelessWidget {
  final QuestsOverviewViewModel model;
  const QuestsCategoryList({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: RefreshIndicator(
        onRefresh: () async => model.initialize(force: true),
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
    );
  }

  Color getColorOfType(QuestType type) {
    if (type == QuestType.TreasureLocationSearch)
      return Colors.orange;
    else if (type == QuestType.Hike) {
      return Colors.red;
    } else if (type == QuestType.DistanceEstimate) {
      return Colors.blue;
    } else {
      return Colors.cyan;
    }
  }
}
