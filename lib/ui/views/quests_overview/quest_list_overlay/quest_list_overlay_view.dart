import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_list_overlay/quest_list_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

// ? This widget currently produces this warning when included
// W/PlatformViewsController(12840): Creating a virtual display of size: [1080, 2256] may result in problems(https://github.com/flutter/flutter/issues/2897).It is larger than the device screen size: [1080, 2176].

class QuestListOverlayView extends StatelessWidget {
  const QuestListOverlayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestListOverlayViewModel>.reactive(
      viewModelBuilder: () => QuestListOverlayViewModel(),
      onModelReady: (model) => model.listenToLayout(),
      builder: (context, model, child) => AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        top: model.isShowingQuestList
            ? kTopHeaderPadding
            : screenHeight(context),
        curve: Curves.easeOutCubic,
        // TODO: TEST repaintboundary functionality
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => null,
          onVerticalDragStart: (_) => model.removeQuestListOverlay(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: screenHeight(context),
              width: screenWidth(context),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [kcGreenWhiter, kcPrimaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.2, 1]),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  SizedBox(height: 4),
                  GrabberLine(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15),
                    child: InsideOutText.headingTwo(
                      "Quest list",
                      align: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => model.initializeQuests(),
                      child: ListView(
                        children: [
                          verticalSpaceSmall,
                          if (model.nearbyQuests.length != 0)
                            SectionHeader(
                              title: "Near You",
                              onButtonTap: () =>
                                  model.initializeQuests(force: true),
                              buttonIcon: model.isBusy
                                  ? AFKProgressIndicator()
                                  : Icon(Icons.refresh_rounded),
                            ),
                          verticalSpaceTiny,
                          if (model.nearbyQuests.length == 0)
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 30),
                              child:
                                  InsideOutText.headingThree("No quests found"),
                            ),
                          if (model.nearbyQuests.length == 0)
                            Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 15),
                                child: InsideOutText.subheading(
                                    "Ask your parents to create some")),
                          ListView(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              ...model.nearbyQuestsTodo
                                  .asMap()
                                  .map((index, quest) {
                                    return MapEntry(
                                      index,
                                      QuestInfoCard(
                                        height: 150,
                                        marginRight: kHorizontalPadding,
                                        width: screenWidth(context,
                                            percentage: 0.8),
                                        quest: quest,
                                        subtitle: quest.description,
                                        onCardPressed: () async => await model
                                            .onQuestInListTapped(quest),
                                      ),
                                    );
                                  })
                                  .values
                                  .toList(),
                            ],
                          ),
                          verticalSpaceMassive,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      //),
    );
  }
}
