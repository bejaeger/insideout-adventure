import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/ui/views/active_quest_drawer/active_quest_drawer_view.dart';
import 'package:afkcredits/ui/views/parent_home/parent_home_view.dart';
import 'package:afkcredits/ui/views/single_child_stat/drawer/single_child_drawer_view.dart';
import 'package:afkcredits/ui/views/single_child_stat/single_child_stat_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/history_tile.dart';
import 'package:afkcredits/ui/widgets/outline_box.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:afkcredits/ui/widgets/trend_icon.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SingleChildStatView extends StatefulWidget {
  final String uid;
  const SingleChildStatView({Key? key, required this.uid}) : super(key: key);

  @override
  State<SingleChildStatView> createState() => _SingleChildStatViewState();
}

class _SingleChildStatViewState extends State<SingleChildStatView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleChildStatViewModel>.reactive(
      viewModelBuilder: () => SingleChildStatViewModel(explorerUid: widget.uid),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: model.explorer != null
                ? model.explorer!.fullName + '\'s Stats'
                : "Child Statistics",
            onBackButton: model.popView,
            drawer: true,
          ),
          endDrawer: SingleChildDrawerView(explorer: model.explorer),
          floatingActionButton: BottomFloatingActionButtons(
              // titleMain: "Add Credits",
              // onTapMain: model.navigateToAddFundsView,
              titleMain: "Switch Account",
              onTapMain: model.handleSwitchToExplorerEvent),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: RefreshIndicator(
            onRefresh: model.refresh,
            child: model.isBusy
                ? AFKProgressIndicator()
                : ListView(
                    children: [
                      verticalSpaceMedium,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kHorizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpaceSmall,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SummaryStatsDisplay(
                                    title: "Current credits",
                                    icon: Image.asset(kAFKCreditsLogoPath,
                                        color: kcPrimaryColor, height: 22),
                                    stats: model.stats.afkCreditsBalance
                                        .toStringAsFixed(0)),
                                horizontalSpaceSmall,
                                Icon(
                                  Icons.arrow_forward,
                                  size: 30,
                                ),
                                horizontalSpaceSmall,
                                SummaryStatsDisplay(
                                    title: "Equiv. screen time",
                                    icon: Icon(Icons.schedule,
                                        color: kcScreenTimeBlue),
                                    unit: "min",
                                    stats: model.stats.afkCreditsBalance
                                        .toStringAsFixed(0)),
                                horizontalSpaceSmall,
                              ],
                            ),
                            verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AfkCreditsButton.outline(
                                    title: "Add credits",
                                    onTap: model.navigateToAddFundsView,
                                  ),
                                ),
                                horizontalSpaceMedium,
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AfkCreditsButton.outline(
                                        title: "Start screen time",
                                        onTap: model.isScreenTimeActive
                                            ? null
                                            : () =>
                                                model.navToSelectScreenTimeView(
                                                    childId: widget.uid),
                                        color: model.isScreenTimeActive
                                            ? kcMediumGrey
                                            : null,
                                      ),
                                      if (model.isScreenTimeActive)
                                        AfkCreditsText.warn(
                                            "Screen time running"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceMedium,
                            SectionHeader(
                              title: "Stats last 7 days",
                              horizontalPadding: 0,
                            ),
                            verticalSpaceSmall,
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(kActivityIcon,
                                          height: 40,
                                          width: 40,
                                          color: kcActivityIconColor),
                                      horizontalSpaceSmall,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              AfkCreditsText.statsStyle(model
                                                      .totalChildActivityLastDaysString +
                                                  " min"),
                                              TrendIcon(
                                                  metric: model
                                                      .totalChildActivityTrend),
                                            ],
                                          ),
                                          if (model.totalChildActivityTrend !=
                                              null)
                                            AfkCreditsText.caption(
                                                ((model.totalChildActivityTrend ??
                                                                0) >=
                                                            0
                                                        ? "+"
                                                        : "") +
                                                    model
                                                        .totalChildActivityTrend
                                                        .toString() +
                                                    " min"),
                                          if (model.totalChildActivityTrend !=
                                              null)
                                            AfkCreditsText.caption(
                                                "from prev. week"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(kScreenTimeIcon2,
                                          height: 40,
                                          width: 40,
                                          color: kcScreenTimeBlue),
                                      horizontalSpaceSmall,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              AfkCreditsText.statsStyle(model
                                                      .totalChildScreenTimeLastDaysString +
                                                  " min"),
                                              TrendIcon(
                                                  metric: model
                                                      .totalChildScreenTimeTrend,
                                                  screenTime: true),
                                            ],
                                          ),
                                          if (model.totalChildScreenTimeTrend !=
                                              null)
                                            AfkCreditsText.caption(
                                                ((model.totalChildScreenTimeTrend ??
                                                                0) >=
                                                            0
                                                        ? "+"
                                                        : "") +
                                                    model
                                                        .totalChildScreenTimeTrend
                                                        .toString() +
                                                    " min"),
                                          if (model.totalChildScreenTimeTrend !=
                                              null)
                                            AfkCreditsText.caption(
                                                "from prev. week"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (model.sortedHistory.length > 0)
                              verticalSpaceMedium,
                            if (model.sortedHistory.length > 0)
                              verticalSpaceSmall,
                            if (model.sortedHistory.length > 0)
                              SectionHeader(
                                title: "History",
                                horizontalPadding: 0,
                              ),
                            if (model.sortedHistory.length > 0)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: kcMediumGrey.withOpacity(0.5)),
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: model.sortedHistory.length,
                                    itemBuilder: (context, index) {
                                      final data = model.sortedHistory[index];
                                      return Column(
                                        children: [
                                          data is ActivatedQuest
                                              ? HistoryTile(
                                                  showName: false,
                                                  showCredits: true,
                                                  screenTime: false,
                                                  date: data.createdAt.toDate(),
                                                  name:
                                                      model.explorerNameFromUid(
                                                          data.uids![0]),
                                                  credits:
                                                      data.afkCreditsEarned,
                                                  //minutes: data.afkCreditsEarned,
                                                  minutes:
                                                      (data.timeElapsed / 60)
                                                          .round(),
                                                  questType: data.quest.type,
                                                )
                                              : HistoryTile(
                                                  showName: false,
                                                  showCredits: true,
                                                  screenTime: true,
                                                  date: data.startedAt.toDate(),
                                                  name:
                                                      model.explorerNameFromUid(
                                                          data.uid),
                                                  credits:
                                                      data.afkCreditsUsed ??
                                                          data.afkCredits,
                                                  minutes: data.minutesUsed ??
                                                      data.minutes,
                                                ),
                                          if (index !=
                                              model.sortedHistory.length - 1)
                                            Divider(),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            verticalSpaceMassive,
                          ],
                        ),
                      ),
                      if (model.stats.lifetimeEarnings == 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding),
                          child: AfkCreditsText.headingTwoLight(
                              "Switch account and let " +
                                  model.explorer!.fullName +
                                  " earn credits",
                              align: TextAlign.center),
                        ),
                      if (model.stats.lifetimeEarnings == 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Icon(Icons.arrow_downward_rounded,
                              size: 40, color: kcPrimaryColor),
                        ),
                      // Image.asset(
                      //   kIllustrationActivity,
                      //   fit: BoxFit.contain,
                      //   height: 100,
                      //   width: 300,
                      //   alignment: Alignment.center,
                      // ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}