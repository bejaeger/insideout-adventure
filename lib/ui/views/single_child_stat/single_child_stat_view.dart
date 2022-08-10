import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/ui/views/single_child_stat/single_child_stat_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/history_tile.dart';
import 'package:afkcredits/ui/widgets/outline_box.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
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
          appBar: AppBar(
            title: Text("Child Statistics"),
          ),
          floatingActionButton: Container(
            width: screenWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //verticalSpaceSmall,
                OutlineBox(
                  width: screenWidth(context, percentage: 0.4),
                  height: 60,
                  borderWidth: 0,
                  text: "Add Screen Time Credits",
                  onPressed: model.navigateToAddFundsView,
                  color: kDarkTurquoise,
                  textColor: Colors.white,
                ),
                if (!model.isBusy && model.explorer.createdByUserWithId != null)
                  OutlineBox(
                    width: screenWidth(context, percentage: 0.4),
                    height: 60,
                    borderWidth: 0,
                    text: "Switch to Child",
                    onPressed: model.handleSwitchToExplorerEvent,
                    color: kDarkTurquoise,
                    textColor: Colors.white,
                  ),
                //verticalSpaceSmall,
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // CircleAvatar(
                                //   radius: 25,
                                //   backgroundColor: kDarkTurquoise,
                                //   child: Text(
                                //       getInitialsFromName(
                                //           model.explorer.fullName),
                                //       style: TextStyle(
                                //           color: Colors.white, fontSize: 26)),
                                // ),
                                // horizontalSpaceMedium,
                                Text(model.explorer.fullName,
                                    style: textTheme(context).headline4),
                              ],
                            ),
                            verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      AfkCreditsText.body("QUESTS COMPLETED"),
                                      AfkCreditsText.label(model
                                          .stats.numberQuestsCompleted
                                          .toString()),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Column(
                                //     children: [
                                //       AfkCreditsText.body("SCREEN TIME"),
                                //       AfkCreditsText.label("unknown"),
                                //     ],
                                //   ),
                                // ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      AfkCreditsText.body("CREDITS"),
                                      // CreditsAmount(
                                      //     amount: model.stats.afkCreditsBalance,
                                      //     height: 22)
                                      AfkCreditsText.label(model
                                          .stats.afkCreditsBalance
                                          .toString()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceSmall,
                            Divider(),
                            verticalSpaceSmall,
                            SectionHeader(
                              title: "Trends from last week",
                              horizontalPadding: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    AfkCreditsText.body("ACTIVITY"),
                                    Text(model.totalChildActivityLastDays
                                            .toString() +
                                        " min"),
                                    Text(
                                        ((model.totalChildActivityTrend ?? 0) >=
                                                    0
                                                ? "+"
                                                : "") +
                                            model.totalChildActivityTrend
                                                .toString() +
                                            " min"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    AfkCreditsText.body("SCREEN TIME"),
                                    Text(model.totalChildScreenTimeLastDays
                                            .toString() +
                                        " min"),
                                    Text(((model.totalChildScreenTimeTrend ??
                                                    0) >=
                                                0
                                            ? "+"
                                            : "") +
                                        model.totalChildScreenTimeTrend
                                            .toString() +
                                        " min"),
                                  ],
                                ),
                              ],
                            ),
                            verticalSpaceMedium,
                            SectionHeader(
                              title: "History",
                              horizontalPadding: 0,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: model.sortedHistory.length,
                              itemBuilder: (context, index) {
                                final data = model.sortedHistory[index];
                                if (data is ActivatedQuest) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0, vertical: 4.0),
                                    child: HistoryTile(
                                      showCredits: true,
                                      screenTime: false,
                                      date: data.createdAt.toDate(),
                                      name: model
                                          .explorerNameFromUid(data.uids![0]),
                                      credits: data.afkCreditsEarned,
                                      //minutes: data.afkCreditsEarned,
                                      minutes: (data.timeElapsed / 60).round(),
                                      questType: data.quest.type,
                                    ),
                                  );
                                } else {
                                  // ScreenTimeSession
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0, vertical: 4.0),
                                    child: HistoryTile(
                                      showCredits: true,
                                      screenTime: true,
                                      date: data.startedAt.toDate(),
                                      name: model.explorerNameFromUid(data.uid),
                                      credits: data.afkCredits,
                                      minutes: data.minutes,
                                    ),
                                  );
                                }
                              },
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
