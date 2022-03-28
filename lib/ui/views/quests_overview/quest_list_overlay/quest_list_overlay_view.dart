import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// ? This widget currently produces this warning when included
// W/PlatformViewsController(12840): Creating a virtual display of size: [1080, 2256] may result in problems(https://github.com/flutter/flutter/issues/2897).It is larger than the device screen size: [1080, 2176].

class QuestListOverlayView extends StatelessWidget {
  const QuestListOverlayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("==>> Rebuild QuestListOverlay");
    return ViewModelBuilder<QuestListOverlayViewModel>.reactive(
      viewModelBuilder: () => QuestListOverlayViewModel(),
      onModelReady: (model) => model.listenToLayout(),
      builder: (context, model, child) => AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        // bottom: show ? 500 : screenHeight(context),
        top: model.isShowingQuestList ? 0 : screenHeight(context),
        curve: Curves.easeOutCubic,
        // TODO: TEST repaintboundary functionality
        left: 0,
        right: 0,
        child: Container(
          height: screenHeight(context),
          width: screenWidth(context) - 10,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            gradient: LinearGradient(
              colors: [kPrimaryColor.withOpacity(0.2), Colors.grey[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            children: [
              verticalSpaceMedium,
              AfkCreditsText.headingOne(
                "Quest List",
                align: TextAlign.center,
              ),
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
                          (e) => AfkCreditsCategoryCard(
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
        ),
      ),
      //),
    );
  }
}
