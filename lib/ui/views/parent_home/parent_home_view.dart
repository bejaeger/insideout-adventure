import 'dart:math';

import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/parent_drawer_view/parent_drawer_view.dart';
import 'package:afkcredits/ui/views/parent_home/parent_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/child_stats_card.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/history_tile.dart';
import 'package:afkcredits/ui/widgets/money_transfer_list_tile.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
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
          appBar: CustomAppBar(
            showLogo: true,
            title: " ",
            drawer: true,
            showRedLiveButton: model.isScreenTimeActive,
          ),
          endDrawer: const ParentDrawerView(),
          floatingActionButton: BottomFloatingActionButtons(
            swapButtons: true,
            titleSecondary: "Create Quest",
            titleMain: "Quest List",
            onTapSecondary: model.navToCreateQuest,
            onTapMain: model.showNotImplementedSnackbar,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: RefreshIndicator(
            onRefresh: () => model.listenToData(),
            child: ListView(
              // physics: BouncingScrollPhysics(),
              children: [
                verticalSpaceMedium,
                // if (model.childScreenTimeSessionsActive.isNotEmpty)
                //   AfkCreditsText.alertThree("Active Screen Time"),
                // if (model.childScreenTimeSessionsActive.isNotEmpty)
                //   AfkCreditsText.body(model.explorerNameFromUid(
                //           model.childScreenTimeSessionsActive[0].uid) +
                //       ", Minutes: " +
                //       model.childScreenTimeSessionsActive[0].minutes
                //           .toString() +
                //       ", started at: " +
                //       formatDateDetails(model
                //           .childScreenTimeSessionsActive[0].startedAt
                //           .toDate())),
                Center(child: AfkCreditsText.headingOne("Parent Area")),
                verticalSpaceSmall,
                SectionHeader(
                  title: "Children",
                  onButtonTap: model.showAddExplorerBottomSheet,
                  buttonIcon: Icon(Icons.add_circle_outline_rounded,
                      size: 28, color: kcPrimaryColor),
                ),
                if (model.supportedExplorers.length == 0)
                  model.isBusy
                      ? AFKProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: AfkCreditsButton(
                            onTap: model.showAddExplorerBottomSheet,
                            title: "Create Child Account",
                            height: 80,
                            //imagePath: ImagePath.peopleHoldingHands,
                          ),
                        ),
                if (model.supportedExplorers.length > 0)
                  ChildrenStatsList(
                    viewModel: model,
                    // usingScreenTime: model.usingScreenTime(uid: model.),
                    // onAddNewExplorerPressed:
                    //     model.showAddExplorerBottomSheet
                  ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Divider(),
                ),
                verticalSpaceMedium,
                AfkCreditsText.headingFour(
                  "How can we improve?",
                  align: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding * 1.2),
                  child: AfkCreditsText.body(
                    "Let's work together",
                    align: TextAlign.center,
                  ),
                ),
                //verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: AfkCreditsButton.text(
                    title: "Provide Feedback",
                    onTap: model.showNotImplementedSnackbar,
                  ),
                ),
                // if (model.sortedHistory.length != 0)
                //   SectionHeader(
                //     title: "Children Activity",
                //     //onButtonTap: model.navigateToTransferHistoryView,
                //   ),
                // if (model.sortedHistory.length != 0) verticalSpaceTiny,
                // if (model.sortedHistory.length != 0)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: kHorizontalPadding),
                //     child: Container(
                //       decoration: BoxDecoration(
                //           border:
                //               Border.all(color: kcMediumGrey.withOpacity(0.5)),
                //           borderRadius: BorderRadius.circular(20.0)),
                //       padding: const EdgeInsets.symmetric(vertical: 10.0),
                //       child: ListView.builder(
                //         shrinkWrap: true,
                //         physics: ScrollPhysics(),
                //         itemCount: min(model.sortedHistory.length, 3),
                //         itemBuilder: (context, index) {
                //           dynamic data =
                //               model.sortedHistory[index]; // ScreenTimeSession
                //           return Padding(
                //             padding: const EdgeInsets.symmetric(
                //                 horizontal: 10.0, vertical: 0.0),
                //             child: Column(
                //               children: [
                //                 data is ActivatedQuest
                //                     ? HistoryTile(
                //                         screenTime: false,
                //                         date: data.createdAt.toDate(),
                //                         name: model
                //                             .explorerNameFromUid(data.uids![0]),
                //                         credits: data.afkCreditsEarned,
                //                         //minutes: data.afkCreditsEarned,
                //                         minutes:
                //                             (data.timeElapsed / 60).round(),
                //                         questType: data.quest.type,
                //                       )
                //                     : HistoryTile(
                //                         screenTime: true,
                //                         date: data.startedAt is String
                //                             ? DateTime.now()
                //                             : data.startedAt.toDate(),
                //                         name:
                //                             model.explorerNameFromUid(data.uid),
                //                         credits: data.afkCreditsUsed ??
                //                             data.afkCredits,
                //                         minutes:
                //                             data.minutesUsed ?? data.minutes,
                //                       ),
                //                 if (index !=
                //                     min(model.sortedHistory.length, 3) - 1)
                //                   Divider(),
                //               ],
                //             ),
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                verticalSpaceMassive,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChildrenStatsList extends StatelessWidget {
  final ParentHomeViewModel viewModel;

  const ChildrenStatsList({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        //shrinkWrap: true,
        itemCount: viewModel.supportedExplorers.length,
        itemBuilder: (context, index) {
          String uid = viewModel.supportedExplorers[index].uid;
          User explorer = viewModel.supportedExplorers[index];
          return Padding(
            padding: EdgeInsets.only(
                left: (index == 0) ? 20.0 : 5.0,
                right: (index == viewModel.supportedExplorers.length - 1)
                    ? 20.0
                    : 0),
            child: GestureDetector(
              onTap: () =>
                  viewModel.navigateToScreenTimeOrSingleChildView(uid: uid),
              child: ChildStatsCard(
                  screenTimeLastWeek:
                      viewModel.totalChildScreenTimeLastDays[uid],
                  activityTimeLastWeek:
                      viewModel.totalChildActivityLastDays[uid],
                  screenTimeTrend: viewModel.totalChildScreenTimeTrend[uid],
                  activityTimeTrend: viewModel.totalChildActivityTrend[uid],
                  user: explorer,
                  childStats: viewModel.childStats[uid],
                  usingScreenTime: viewModel.usingScreenTime(uid: uid)),
            ),
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
