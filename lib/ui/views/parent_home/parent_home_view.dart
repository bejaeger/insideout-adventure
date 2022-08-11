import 'dart:math';

import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/parent_drawer_view/parent_drawer_view.dart';
import 'package:afkcredits/ui/views/parent_home/parent_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/child_stats_card.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/history_tile.dart';
import 'package:afkcredits/ui/widgets/money_transfer_list_tile.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ParentHomeView extends StatelessWidget {
  const ParentHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ParentHomeViewModel>.reactive(
      viewModelBuilder: () => ParentHomeViewModel(),
      onModelReady: (model) => model.listenToData(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title: "Home", drawer: true),
          endDrawer: const ParentDrawerView(),
          // floatingActionButton: Container(
          //   width: screenWidth(context),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       //verticalSpaceSmall,
          //       OutlineBox(
          //         width: screenWidth(context, percentage: 0.4),
          //         height: 60,
          //         borderWidth: 0,
          //         text: "Create Quest",
          //         onPressed: model.navToCreateQuest,
          //         color: kDarkTurquoise,
          //         textColor: Colors.white,
          //       ),
          //       OutlineBox(
          //         width: screenWidth(context, percentage: 0.4),
          //         height: 60,
          //         borderWidth: 0,
          //         text: "Switch to Child",
          //         onPressed: model.showNotImplementedSnackbar,
          //         color: kDarkTurquoise,
          //         textColor: Colors.white,
          //       ),
          //       //verticalSpaceSmall,
          //     ],
          //   ),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
          body: RefreshIndicator(
            onRefresh: () => model.listenToData(),
            child: ListView(
              //physics: ScrollPhysics(),
              children: [
                verticalSpaceSmall,
                if (model.childScreenTimeSessionsActive.isNotEmpty)
                  AfkCreditsText.alertThree("Active Screen Time"),
                if (model.childScreenTimeSessionsActive.isNotEmpty)
                  AfkCreditsText.body(model.explorerNameFromUid(
                          model.childScreenTimeSessionsActive[0].uid) +
                      ", Minutes: " +
                      model.childScreenTimeSessionsActive[0].minutes
                          .toString() +
                      ", started at: " +
                      formatDateDetails(model
                          .childScreenTimeSessionsActive[0].startedAt
                          .toDate())),

                SectionHeader(
                  title: "Children",
                  onButtonTap: model.showAddExplorerBottomSheet,
                  buttonIcon: Icon(Icons.add_circle_outline_rounded,
                      size: 28, color: kDarkTurquoise),
                ),
                if (model.supportedExplorers.length == 0)
                  model.isBusy
                      ? AFKProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            onPressed: model.showAddExplorerBottomSheet,
                            child: Text("Add Explorer"),
                            //imagePath: ImagePath.peopleHoldingHands,
                          ),
                        ),
                if (model.supportedExplorers.length > 0)
                  ChildrenStatsList(
                    screenTimeLastWeek: model.totalChildScreenTimeLastDays,
                    activityTimeLastWeek: model.totalChildActivityLastDays,
                    screenTimeTrend: model.totalChildScreenTimeTrend,
                    activityTimeTrend: model.totalChildActivityTrend,
                    explorersStats: model.childStats,
                    explorers: model.supportedExplorers,
                    onChildCardPressed: model.navigateToSingleExplorerView,
                    // onAddNewExplorerPressed:
                    //     model.showAddExplorerBottomSheet
                  ),

                //RecentHistory(),
                verticalSpaceSmall,
                SectionHeader(
                  title: "History",
                  //onButtonTap: model.navigateToTransferHistoryView,
                ),
                Container(
                  //height: screenHeight(context, percentage: 0.5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: min(model.sortedHistory.length, 10),
                    itemBuilder: (context, index) {
                      dynamic data = model.sortedHistory[index];
                      if (data is ActivatedQuest) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 4.0),
                          child: HistoryTile(
                            screenTime: false,
                            date: data.createdAt.toDate(),
                            name: model.explorerNameFromUid(data.uids![0]),
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
                              horizontal: 15.0, vertical: 4.0),
                          child: HistoryTile(
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

class ChildrenStatsList extends StatelessWidget {
  final List<User> explorers;
  final Map<String, UserStatistics>? explorersStats;
  final Map<String, int> screenTimeLastWeek;
  final Map<String, int> activityTimeLastWeek;
  final Map<String, int> screenTimeTrend;
  final Map<String, int> activityTimeTrend;
  // final void Function() onAddNewExplorerPressed;
  final void Function({required String uid}) onChildCardPressed;

  const ChildrenStatsList({
    Key? key,
    required this.screenTimeLastWeek,
    required this.activityTimeLastWeek,
    required this.screenTimeTrend,
    required this.activityTimeTrend,
    required this.explorers,
    required this.explorersStats,
    // required this.onAddNewExplorerPressed,
    required this.onChildCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        itemCount: explorers.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              if (index == 0) SizedBox(width: 20),
              GestureDetector(
                onTap: () => onChildCardPressed(uid: explorers[index].uid),
                child: ChildStatsCard(
                    screenTimeLastWeek:
                        screenTimeLastWeek[explorers[index].uid],
                    activityTimeLastWeek:
                        activityTimeLastWeek[explorers[index].uid],
                    screenTimeTrend: screenTimeTrend[explorers[index].uid],
                    activityTimeTrend: activityTimeTrend[explorers[index].uid],
                    user: explorers[index],
                    childrenStats: explorersStats),
              ),
              if (index == explorers.length - 1) SizedBox(width: 20),
            ],
          );
        },
      ),
    );
  }
}

class LatestTransfersList extends StatelessWidget {
  final List<MoneyTransfer> transfers;
  final void Function(MoneyTransfer)? onTilePressed;
  const LatestTransfersList({
    Key? key,
    required this.transfers,
    this.onTilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: transfers.length > 3 ? 3 : transfers.length,
          itemBuilder: (context, index) {
            var data = transfers[index];
            return TransferListTile(
              onTap: onTilePressed == null ? null : () => onTilePressed!(data),
              dense: true,
              showBottomDivider: index < 2 && transfers.length > 2,
              showTopDivider: false,
              transaction: data,
              amount: data.transferDetails.amount,
            );
          },
        ),
      ),
    );
  }
}
