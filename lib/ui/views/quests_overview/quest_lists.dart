import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/enums/user_role.dart';
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
    return RefreshIndicator(
      onRefresh: () async => model.initializeQuests(force: true),
      child: ListView(
        children: [
          verticalSpaceMedium,
          if (model.currentUser.role != UserRole.adminMaster)
            SectionHeader(title: "Near You"),
          if (model.currentUser.role == UserRole.adminMaster)
            SectionHeader(title: "Create "),
          Container(
            height: 220,
            child: model.currentUser.role != UserRole.adminMaster
                ? ListView(
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
                  )
                //:Todo Code To be Removed
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: assetsQuestImages.length,
                      itemBuilder: (BuildContext context, index) {
                        return GestureDetector(
                          onTap: () {
                            model.NavigateToQuestViews(index: index);

                            print('Clikced By Felix ${index.toString()}');
                          },
                          child: Container(
                            height: 250,
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.asset(assetsQuestImages[index]
                                  //fit: BoxFit.fill,
                                  ),
                              elevation: 5,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          verticalSpaceSmall,
          if (model.currentUser.role != UserRole.adminMaster)
            SectionHeader(title: "Types"),
          if (model.currentUser.role == UserRole.adminMaster)
            SectionHeader(title: "Edit or Delete "),
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
