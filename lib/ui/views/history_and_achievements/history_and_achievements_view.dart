import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/ui/views/history_and_achievements/history_and_achievements_viewmodel.dart';
import 'package:afkcredits/ui/widgets/achievement_card.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/finished_quest_card.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HistoryAndAchievementsView extends StatefulWidget {
  final int initialIndex;
  const HistoryAndAchievementsView({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  State<HistoryAndAchievementsView> createState() =>
      _HistoryAndAchievementsViewState();
}

class _HistoryAndAchievementsViewState extends State<HistoryAndAchievementsView>
// In my opnion, This view should be called quest_categories
    with
        TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HistoryAndAchievementsViewModel>.reactive(
      viewModelBuilder: () => HistoryAndAchievementsViewModel(),
      onModelReady: (model) {
        //model.initializeQuests();
        _tabController = TabController(
          initialIndex: widget.initialIndex,
          length: 2,
          vsync: this,
        );
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Activity",
            style:
                textTheme(context).headline5!.copyWith(color: kWhiteTextColor),
          ),
          // backgroundColor: kPrimaryColor,
          // elevation: 0,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(12.0),
          //     bottomRight: Radius.circular(12.0),
          //   ),
          // ),
          bottom: PreferredSize(
            preferredSize:
                Size(_tabbar.preferredSize.width, _tabbar.preferredSize.height),
            child: Container(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 5.0, bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  color: kPrimaryColor,
                ),
                child: _tabbar),
          ),
        ),
        body: TabBarView(
          //physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            model.isBusy
                ? AFKProgressIndicator()
                : QuestHistoryOverview(model: model),
            // Icon(Icons.apps),
            model.isBusy
                ? AFKProgressIndicator()
                : AchievementsOverview(model: model),
            // model.isBusy
            //     ? AFKProgressIndicator()
            //     : QuestsCategoryList(model: model),
          ],
        ),
      ),
    );
  }

  TabBar get _tabbar => TabBar(
        // isScrollable: true,
        controller: _tabController,
        unselectedLabelColor: Colors.white70,
        labelColor: kWhiteTextColor,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
            gradient: LinearGradient(colors: [kDarkTurquoise, kDarkTurquoise]),
            borderRadius: BorderRadius.circular(50),
            color: kPrimaryColor),
        tabs: [
          Tab(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.history, size: 30),
                  ),
                  Text(
                    "History",
                  ),
                ],
              ),
            ),
          ),
          Tab(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trip_origin_sharp, size: 30),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Achievements",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class QuestHistoryOverview extends StatelessWidget {
  final HistoryAndAchievementsViewModel model;
  const QuestHistoryOverview({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kHorizontalPadding),
      child: AllQuestsGrid(
        activatedQuests: model.activatedQuestsHistory,
      ),
    );
  }
}

class AchievementsOverview extends StatelessWidget {
  final HistoryAndAchievementsViewModel model;
  const AchievementsOverview({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        kHorizontalPadding,
      ),
      child: AllAchievementsGrid(
        achievements: model.achievements,
      ),
    );
  }
}

class AllQuestsGrid extends StatelessWidget {
  final List<ActivatedQuest> activatedQuests;
  //final void Function() onPressed;
  const AllQuestsGrid({
    Key? key,
    required this.activatedQuests,
    //required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemCount: activatedQuests.length,
        itemBuilder: (context, index) {
          final ActivatedQuest data = activatedQuests[index];
          return FinishedQuestCard(
            quest: data,
            onTap: () => null,
          );
        },
      ),
    );
  }
}

class AllAchievementsGrid extends StatelessWidget {
  final List<Achievement> achievements;
  // final void Function() onPressed;
  const AllAchievementsGrid({
    Key? key,
    required this.achievements,
    //required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final Achievement data = achievements[index];
          return AchievementCard(
            achievement: data,
            //onTap: () => null,
          );
        },
      ),
    );
  }
}
