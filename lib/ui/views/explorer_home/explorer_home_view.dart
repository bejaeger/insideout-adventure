import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/enums/stats_type.dart';
import 'package:afkcredits/ui/views/drawer_widget/drawer_widget_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/activated_quest_panel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/nav_button_widget.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:afkcredits/constants/layout.dart';

class ExplorerHomeView extends StatelessWidget {
  const ExplorerHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorerHomeViewModel>.reactive(
      viewModelBuilder: () => ExplorerHomeViewModel(),
      onModelReady: (model) => model.listenToData(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: "Hi Explorer ${model.name}!",
          drawer: true,
        ),
        endDrawer: SizedBox(
          width: screenWidth(context, percentage: 0.8),
          child: const DrawerWidgetView(),
        ),
        body: model.isBusy
            ? AFKProgressIndicator()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: RefreshIndicator(
                  onRefresh: () async => model.notifyListeners(),
                  child: ListView(
                    children: [
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 10,
                            child: StatsCard(
                                onCardPressed:
                                    model.showToEarnExplanationDialog,
                                statsType: StatsType.lockedCredits,
                                height: 150,
                                statistic:
                                    // availableSponsoring IN CENTS!!!!!!
                                    formatAfkCreditsFromCents(model
                                        .currentUserStats.availableSponsoring),
                                title: kCreditsToEarnDescription),
                          ),
                          Spacer(),
                          Flexible(
                            flex: 10,
                            child: StatsCard(
                                onCardPressed:
                                    model.showEarnedExplanationDialog,
                                statsType: StatsType.unlockedCredits,
                                height: 150,
                                statistic: model
                                    .currentUserStats.afkCreditsBalance
                                    .toString(),
                                title: kCurrentAFKCreditsDescription),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Row(
                        children: [
                          // Flexible(
                          //   flex: 10,
                          //   child: NavButtonWidget(
                          //     color: Colors.blue,
                          //     title: 'ASK FOR CREDITS',
                          //     titleColor: kWhiteTextColor,
                          //     icon: Icon(
                          //       Icons.arrow_downward_rounded,
                          //       color: kGreyTextColor.withOpacity(0.9),
                          //       size: 70,
                          //     ),
                          //     onTap: model.showNotImplementedSnackbar,
                          //   ),
                          // ),
                          // Spacer(),
                          Expanded(
                            flex: 10,
                            child: GestureDetector(
                              onTap: model.navigateToGiftCardsView,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Colors.green,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.card_giftcard_outlined,
                                      color: kWhiteTextColor.withOpacity(0.8),
                                      size: 70,
                                    ),
                                    Spacer(),
                                    Text(
                                      'CLAIM REWARDS',
                                      style: textTheme(context)
                                          .headline6!
                                          .copyWith(color: kWhiteTextColor),
                                    ),
                                    Spacer(),
                                    Icon(Icons.arrow_forward_ios,
                                        color: kWhiteTextColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: NavButtonWidget(
                      //         padding: 0,
                      //         title: 'ACHIEVEMENTS',
                      //         icon: const Icon(
                      //           Icons.badge_rounded,
                      //           color: kDarkTurquoise,
                      //           size: 70,
                      //         ),
                      //         onTap: model.showNotImplementedSnackbar,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      verticalSpaceSmall,
                      SectionHeader(
                        horizontalPadding: 0,
                        title: "Achievements",
                      ),
                      if (model.activatedQuestsHistory.length > 0)
                        AchievementsGrid(
                          achievements: model.achievements,
                          onPressed: () => null,
                        ),
                      verticalSpaceSmall,
                      SectionHeader(
                        horizontalPadding: 0,
                        title: "Quest History",
                      ),
                      verticalSpaceSmall,
                      if (model.activatedQuestsHistory.length > 0)
                        QuestsGrid(
                          activatedQuests: model.activatedQuestsHistory,
                          onPressed: () => null,
                        ),
                      // verticalSpaceLarge,
                      //SectionHeader(title: "Achievements"),
                      verticalSpaceLarge,
                      if (model.useSuperUserFeatures)
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Length positions"),
                                  Text(model.allPositions.length.toString()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Currently Listening?"),
                                  Text(model.isListeningToLocation.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      verticalSpaceMedium,
                      if (model.useSuperUserFeatures)
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text("current distance"),
                                  Text(model.currentDistance),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("live distance"),
                                  Text(model.liveDistance),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("last known distance"),
                                  Text(model.lastKnownDistance),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (model.useSuperUserFeatures) verticalSpaceMedium,
                      if (model.useSuperUserFeatures)
                        model.addingPositionToNotionDB
                            ? AFKProgressIndicator()
                            : Wrap(
                                alignment: WrapAlignment.spaceAround,
                                runAlignment: WrapAlignment.spaceAround,
                                children: [
                                  // SmallButton(onPressed: () => model.pushAllPositionsToNotion(), title: "Push to notion"),
                                  SmallButton(
                                      onPressed: () =>
                                          model.addPositionEntryManual(),
                                      title: "Fetch current Position"),
                                  SmallButton(
                                      onPressed: () =>
                                          model.addPositionEntryManual(
                                              onlyLastKnownPosition: true),
                                      title: "Fetch Last known Pos"),
                                  if (!model.pushedToNotion)
                                    SmallButton(
                                        onPressed: () =>
                                            model.pushAllPositionsToNotion(),
                                        title: "Push to notion"),
                                  SmallButton(
                                      onPressed: model.isListeningToLocation
                                          ? model.cancelLocationListener
                                          : model.addLocationListener,
                                      title: model.isListeningToLocation
                                          ? "Cancel position listener"
                                          : "Start position listener"),
                                ],
                              ),
                      verticalSpaceMassive,
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class ExplorerCreditStats extends StatelessWidget {
  final UserStatistics userStats;
  const ExplorerCreditStats({Key? key, required this.userStats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 5,
              child: StatsCard(
                  statsType: StatsType.lockedCredits,
                  height: 150,
                  statistic:
                      // availableSponsoring IN CENTS!!!!!!
                      formatAfkCreditsFromCents(userStats.availableSponsoring),
                  title: kCreditsToEarnDescription),
            ),
            Spacer(),
            Flexible(
              flex: 5,
              child: StatsCard(
                  statsType: StatsType.unlockedCredits,
                  height: 150,
                  statistic: userStats.afkCreditsBalance.toString(),
                  title: kCurrentAFKCreditsDescription),
            ),
          ],
        ),
        verticalSpaceMedium,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Flexible(
        //       child: StatsCard(
        //           height: 80,
        //           statistic: userStats.lifetimeEarnings.toString(),
        //           subtitle: kLifetimeEarningsDescription),
        //     ),
        //     Flexible(
        //       child: StatsCard(
        //           height: 80,
        //           statistic: userStats.numberQuestsCompleted.toString(),
        //           subtitle: kNumberCompletedQuestsDescription),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class QuestsGrid extends StatelessWidget {
  final List<ActivatedQuest> activatedQuests;
  final void Function() onPressed;
  const QuestsGrid({
    Key? key,
    required this.activatedQuests,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
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

class AchievementsGrid extends StatelessWidget {
  final List<Achievement> achievements;
  final void Function() onPressed;
  const AchievementsGrid({
    Key? key,
    required this.achievements,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
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

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  const AchievementCard({Key? key, required this.achievement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Flexible(
                      //heightFactor: 0.6,
                      child: Icon(Icons.trip_origin_sharp,
                          size: 50, color: Colors.orange.shade400)),
                  verticalSpaceSmall,
                  Text(achievement.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            if (!achievement.completed)
              Container(
                color: Colors.grey.withOpacity(0.5),
              ),
            achievement.completed
                ? Banner(
                    message: "SUCCESS",
                    location: BannerLocation.topStart,
                    color: Colors.green)
                : Banner(message: "LOCKED", location: BannerLocation.topStart),
          ],
        ),
      ),
    );
  }
}

class FinishedQuestCard extends StatelessWidget {
  final ActivatedQuest quest;
  final void Function()? onTap;

  FinishedQuestCard({required this.quest, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          //width: screenWidthPercentage(context, percentage: 0.8),
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (quest.quest.networkImagePath != null)
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.transparent,
                          Colors.orange.withOpacity(0.5)
                        ],
                      ),
                      image: DecorationImage(
                        image: NetworkImage(quest.quest.networkImagePath!),
                        fit: BoxFit.cover,
                      )),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    //stops: [0.0, 1.0],
                    colors: [
                      Colors.white,
                      //kPrimaryColor.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: SizedBox(
                    width: screenWidth(context, percentage: 0.8),
                    child: Text(
                      quest.quest.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme(context).headline6,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: kPrimaryColor.withOpacity(0.8),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        horizontalSpaceSmall,
                        Text("Earned Credits: ",
                            style: textTheme(context)
                                .bodyText1!
                                .copyWith(color: kWhiteTextColor)),
                        Text(quest.afkCreditsEarned.toString(),
                            style: textTheme(context)
                                .bodyText1!
                                .copyWith(color: kWhiteTextColor)),
                        horizontalSpaceSmall,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
