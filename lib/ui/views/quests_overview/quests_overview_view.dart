import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuestsOverviewView extends StatelessWidget {
  const QuestsOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestsOverviewViewModel>.reactive(
      viewModelBuilder: () => QuestsOverviewViewModel(),
      builder: (context, model, child) => Scaffold(
          appBar: CustomAppBar(
            title: "Quests Overview",
          ),
          body: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                QuestCategoryCard(
                  onPressed: model.navigateToSingleQuestView,
                  category: QuestType.DistanceEstimate,
                  backgroundColor: Colors.blue,
                ),
                QuestCategoryCard(
                  onPressed: model.navigateToMapView,
                  category: QuestType.Hike,
                  backgroundColor: Colors.red,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuestCategoryCard(
                  onPressed: model.navigateToVibrationSearchView,
                  category: QuestType.VibrationSearch,
                  backgroundColor: Colors.orange,
                ),
              ],
            )
          ])),
    );
  }
}

class QuestCategoryCard extends StatelessWidget {
  final void Function() onPressed;
  final QuestType category;
  final Color? backgroundColor;
  const QuestCategoryCard({
    Key? key,
    required this.onPressed,
    required this.category,
    this.backgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            width: 180,
            height: 180,
            color: backgroundColor,
            child: Center(
                child: Text(describeEnum(category.toString()),
                    style: textTheme(context)
                        .headline5!
                        .copyWith(color: Colors.grey[200])))));
  }
}
