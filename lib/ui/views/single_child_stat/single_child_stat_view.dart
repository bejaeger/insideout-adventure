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
                            Align(
                              child: AfkCreditsButton.text(
                                title: "Add Screen Time Credits",
                                onTap: model.navigateToAddFundsView,
                              ),
                            ),
                            verticalSpaceMedium,
                            SectionHeader(
                              title: "Stats Last 7 Days",
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
                                                      .totalChildActivityLastDays
                                                      .toString() +
                                                  " min"),
                                              TrendIcon(
                                                  metric: model
                                                      .totalChildActivityTrend),
                                            ],
                                          ),
                                          AfkCreditsText.caption(
                                              ((model.totalChildActivityTrend ??
                                                              0) >=
                                                          0
                                                      ? "+"
                                                      : "") +
                                                  model.totalChildActivityTrend
                                                      .toString() +
                                                  " min"),
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
                                      Image.asset(kScreenTimeIcon,
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
                                                      .totalChildScreenTimeLastDays
                                                      .toString() +
                                                  " min"),
                                              TrendIcon(
                                                  metric: model
                                                      .totalChildScreenTimeTrend,
                                                  screenTime: true),
                                            ],
                                          ),
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
                                          AfkCreditsText.caption(
                                              "from prev. week"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceMedium,
                            verticalSpaceSmall,
                            SectionHeader(
                              title: "History",
                              horizontalPadding: 0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kcMediumGrey.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(20.0)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
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
                                                name: model.explorerNameFromUid(
                                                    data.uids![0]),
                                                credits: data.afkCreditsEarned,
                                                //minutes: data.afkCreditsEarned,
                                                minutes: (data.timeElapsed / 60)
                                                    .round(),
                                                questType: data.quest.type,
                                              )
                                            : HistoryTile(
                                                showName: false,
                                                showCredits: true,
                                                screenTime: true,
                                                date: data.startedAt.toDate(),
                                                name: model.explorerNameFromUid(
                                                    data.uid),
                                                credits: data.afkCredits,
                                                minutes: data.minutes,
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
                            // SectionHeader(title: "Stats"),
                            // model.isBusy
                            //     ? AFKProgressIndicator()
                            //     : Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: kHorizontalPadding),
                            //         child: Column(
                            //           children: [
                            //             ExpansionTile(
                            //               title: Text(model
                            //                   .stats.numberQuestsCompleted
                            //                   .toString()),
                            //               subtitle: Text("Quests completed"),
                            //               expandedAlignment:
                            //                   Alignment.centerLeft,
                            //               children: [
                            //                 verticalSpaceSmall,
                            //                 Text("Last quest"),
                            //                 Text("01/01/2022"),
                            //                 verticalSpaceSmall,
                            //               ],
                            //             ),
                            //             ExpansionTile(
                            //               title: Text(model
                            //                   .stats.numberGiftCardsPurchased
                            //                   .toString()),
                            //               subtitle: Text("Screen time"),
                            //               expandedAlignment:
                            //                   Alignment.centerLeft,
                            //               children: [
                            //                 verticalSpaceSmall,
                            //                 verticalSpaceSmall,
                            //               ],
                            //             ),
                            // ExpansionTile(
                            //   title: Text(model
                            //       .stats.numberGiftCardsPurchased
                            //       .toString()),
                            //   subtitle:
                            //       Text("Gift cards purchased"),
                            //   expandedAlignment:
                            //       Alignment.centerLeft,
                            //   children: [
                            //     verticalSpaceSmall,
                            //     verticalSpaceSmall,
                            //   ],
                            // ),
                          ],
                        ),
                      ),

////////////////////////////////
//////////////////////////
//// DEPRECATED
                      ///
                      ///
                      //       if (model.explorer.createdByUserWithId != null)
                      //         verticalSpaceSmall,
                      //       if (model.explorer.createdByUserWithId != null)
                      //         TextButton(
                      //           style: TextButton.styleFrom(
                      //             primary: kDarkTurquoise,
                      //             padding: EdgeInsets.zero,
                      //           ),
                      //           onPressed: model.handleSwitchToExplorerEvent,
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(15.0),
                      //               border: Border.all(color: kDarkTurquoise),
                      //             ),
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(12.0),
                      //               child: Text(
                      //                   "Switch to Children Area \u2192"),
                      //             ),
                      //           ),
                      //         ),
                      //       verticalSpaceMedium,
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           Flexible(
                      //             flex: 5,
                      //             child: Column(
                      //               children: [
                      //                 SimpleStatisticsDisplay(
                      //                   title: "Total Earned",
                      //                   statistic: model
                      //                       .stats.lifetimeEarnings
                      //                       .toString(),
                      //                   showCreditsSymbol: true,
                      //                 ),
                      //                 verticalSpaceSmall,
                      //                 Text(
                      //                     "Equivalent to " +
                      //                         formatAFKCreditsToActivityHours(
                      //                             model.stats
                      //                                 .lifetimeEarnings) +
                      //                         " hours of physical activity",
                      //                     style: textTheme(context)
                      //                         .headline6!
                      //                         .copyWith(
                      //                             fontSize: 15,
                      //                             color: kDarkTurquoise,
                      //                             fontStyle:
                      //                                 FontStyle.italic))
                      //               ],
                      //             ),
                      //           ),
                      //           Spacer(),
                      //           Flexible(
                      //             flex: 5,
                      //             child: Column(
                      //               children: [
                      //                 SimpleStatisticsDisplay(
                      //                   title: "Current balance",
                      //                   statistic: model
                      //                       .stats.afkCreditsBalance
                      //                       .toString(),
                      //                   showCreditsSymbol: true,
                      //                 ),
                      //                 verticalSpaceSmall,
                      //                 Text("Last mission done on 02/02/2022",
                      //                     style: textTheme(context)
                      //                         .headline6!
                      //                         .copyWith(
                      //                             fontSize: 15,
                      //                             color: kDarkTurquoise,
                      //                             fontStyle:
                      //                                 FontStyle.italic))
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       verticalSpaceMedium,
                      //       Divider(thickness: 2),
                      //     ],
                      //   ),
                      // ),
                      // SectionHeader(title: "Current Sponsoring"),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: kHorizontalPadding),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           Flexible(
                      //             flex: 5,
                      //             child: SimpleStatisticsDisplay(
                      //               statistic: formatAfkCreditsFromCents(
                      //                   model.stats.availableSponsoring),
                      //               showCreditsSymbol: true,
                      //               dollarValue: formatDollarFromCents(
                      //                   model.stats.availableSponsoring),
                      //             ),
                      //           ),
                      //           Spacer(),
                      //           Flexible(
                      //             flex: 5,
                      //             child: LargeButton(
                      //                 backgroundColor: Colors.transparent,
                      //                 titleColor: kDarkTurquoise,
                      //                 onPressed: model.navigateToAddFundsView,
                      //                 fontSize: 16,
                      //                 withBorder: true,
                      //                 title: "Sponsor Activities"),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // verticalSpaceMedium,
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: kHorizontalPadding),
                      //   child: Divider(thickness: 2),
                      // ),
                      //   ],
                      // ),
                      // ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
