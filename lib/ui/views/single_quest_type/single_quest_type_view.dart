import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_quest_standalone_ui_view.dart';
import 'package:afkcredits/ui/views/single_quest_type/single_quest_type_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class SingleQuestTypeView extends StatelessWidget {
  final Quest? quest;
  final QuestType? questType;
  const SingleQuestTypeView({Key? key, required this.quest, this.questType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleQuestViewModel>.reactive(
      viewModelBuilder: () => SingleQuestViewModel(questType: questType),
      builder: (context, model, child) => (quest == null && questType == null)
          ? Container(
              child: Text(
                  "ERROR! This should never happen. You navigated to a single quest view without providing a quest category. Hopefully you are not a user of the app but a developer. Otherwise please help us and let the developers know immediately"),
            )
          : (model.hasActiveQuest || quest != null)
              ? ActiveQuestStandaloneUIView(quest: quest)
              : Scaffold(
                  appBar: CustomAppBar(
                    title: getStringForCategory(questType),
                    onBackButton: model.navigateBack,
                  ),
                  body:
                      // Add the list of quests here!
                      // Use QuestInfoCard
                      GestureDetector(
                    child: ListView(
                      //itemExtent: 120,
                      children: [
                        // TODO: provide this list sorted w.r.t. user distance!
                        ...model.currentQuests
                            .asMap()
                            .map((index, quest) {
                              return MapEntry(
                                index,
                                UserRole.explorer == model.currentUser.role ||
                                        UserRole.sponsor ==
                                            model.currentUser.role
                                    ? QuestInfoCard(
                                        height: 200,
                                        marginRight: kHorizontalPadding,
                                        marginTop: 20,
                                        quest: quest,
                                        subtitle: quest.description,
                                        onCardPressed: () async => await model
                                            .onQuestInListTapped(quest),
                                      )
                                    : Dismissible(
                                        key: UniqueKey(),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: SvgPicture.asset(
                                                "assets/icons/trash_icon.svg"),
                                          ),
                                        ),
                                        child: QuestInfoCard(
                                          height: 200,
                                          marginRight: kHorizontalPadding,
                                          marginTop: 20,
                                          quest: quest,
                                          subtitle: quest.description,
                                          onCardPressed: () {
                                            //Call The Dismissible Widget.
                                            print(
                                              'You can edit the Quest: ' +
                                                  quest.name.toUpperCase(),
                                            );
                                          },
                                          /*     onCardPressed: () async =>
                                        await model.onQuestInListTapped(quest), */
                                        ),
                                        onDismissed: (direction) {
                                          model.removeQuest(quest: quest);
                                        },
                                      ),
                              );
                            })
                            .values
                            .toList(),
                        verticalSpaceLarge,
                      ],
                    ),
                    onTap: () {
                      print('Am Being Pressed ');
                    },
                  ),
                  // questType == QuestType.DistanceEstimate
                  //     ? DistanceEstimateCard(
                  //         onPressed: () =>
                  //             model.startMinigameQuest(questType!))
                  //     : questType == QuestType.VibrationSearch
                  //         ? VibrationSearchCard(
                  //             onPressed: () =>
                  //                 model.startMinigameQuest(questType!))
                  //         : null,
                ),
    );
  }
}
