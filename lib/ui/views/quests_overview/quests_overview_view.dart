import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
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
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: "Quests Overview",
        ),
        body: model.isBusy
            ? CircularProgressIndicator()
            : ListView(
                children: [
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: model.scanQrCode,
                          child: Text("Scan Marker",
                              style: textTheme(context)
                                  .headline5!
                                  .copyWith(color: kWhiteTextColor))),
                      ElevatedButton(
                          onPressed: model.navigateToMapView,
                          child: Text("Show Map",
                              style: textTheme(context)
                                  .headline5!
                                  .copyWith(color: kWhiteTextColor))),
                    ],
                  ),
                  verticalSpaceLarge,
                  SectionHeader(title: "Quest Categories"),
                  verticalSpaceSmall,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kHorizontalPadding),
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
                                onPressed:
                                    model.navigateToQuestsOfSpecificTypeView,
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
                ],
              ),
      ),
    );
  }

  Color getColorOfType(QuestType type) {
    if (type == QuestType.VibrationSearch)
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

class QuestCategoryCard extends StatelessWidget {
  final void Function(QuestType) onPressed;
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
        onTap: () => onPressed(category),
        child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            // width: 180,
            // height: 180,
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: FittedBox(
              fit: BoxFit.contain,
              child: Text(describeEnum(category.toString()),
                  style: textTheme(context)
                      .headline6!
                      .copyWith(color: Colors.grey[200])),
            ))));
  }
}
