import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/ui/widgets/verify_network_connection/verify_network_connection.dart';
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
      builder: (context, model, child) => VerifyNetworkConnection(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Hi Explorer ${model.name}!",
          ),
          body: model.isBusy
              ? AFKProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: ListView(
                    children: [
                      verticalSpaceLarge,
                      ExplorerCreditStats(
                        userStats: model.currentUserStats,
                      ),
                      verticalSpaceLarge,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 5),
                        // onPressed: model.navigateToExplorerHomeView,
                        onPressed: model.navigateToGiftCardsView,
                        //child: Text("Go to explorer home/map")),
                        child: Text("See Your Gift Cards -> "),
                      ),
                      verticalSpaceMedium,
                      SectionHeader(
                        horizontalPadding: 0,
                        title: "Your Achievements",
                      ),
                      verticalSpaceSmall,
                      model.activatedQuestsHistory.length == 0
                          ? Text("Complete your first quest first ->")
                          : QuestsGrid(
                              activatedQuests: model.activatedQuestsHistory,
                              onPressed: () => null,
                            ),
                      verticalSpaceLarge,
                      ElevatedButton(
                        // onPressed: model.navigateToExplorerHomeView,
                        onPressed: model.logout,
                        //child: Text("Go to explorer home/map")),
                        child: Text("Logout  "),
                      ),
                      verticalSpaceMedium,
                      if (model.currentUser.createdByUserWithId != null)
                        ElevatedButton(
                          // onPressed: model.navigateToExplorerHomeView,
                          onPressed: model.handleSwitchToSponsorEvent,
                          //child: Text("Go to explorer home/map")),
                          child: Text("Switch To Sponsor  "),
                        ),
                      verticalSpaceLarge,
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
              child: StatsCard(
                  height: 80,
                  statistic:
                      // availableSponsoring IN CENTS!!!!!!
                      formatAfkCreditsFromCents(userStats.availableSponsoring),
                  subtitle: kCreditsToEarnDescription),
            ),
            Flexible(
              child: StatsCard(
                  height: 80,
                  statistic: userStats.afkCreditsBalance.toString(),
                  subtitle: kCurrentAFKCreditsDescription),
            ),
          ],
        ),
        verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: StatsCard(
                  height: 80,
                  statistic: userStats.lifetimeEarnings.toString(),
                  subtitle: kLifetimeEarningsDescription),
            ),
            Flexible(
              child: StatsCard(
                  height: 80,
                  statistic: userStats.numberQuestsCompleted.toString(),
                  subtitle: kNumberCompletedQuestsDescription),
            ),
          ],
        ),
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
      height: 200,
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

class FinishedQuestCard extends StatelessWidget {
  final ActivatedQuest quest;
  final void Function()? onTap;

  FinishedQuestCard({required this.quest, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
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
                          Colors.black87.withOpacity(0.5)
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
                      Colors.black54.withOpacity(0.4),
                      Colors.transparent,
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
                      style: textTheme(context).headline5,
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
                              style: textTheme(context).bodyText1),
                          Text(quest.afkCreditsEarned.toString(),
                              style: textTheme(context).bodyText1),
                          horizontalSpaceSmall,
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
