import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/transfers/transfer_details.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/ui/views/single_ward_stat/single_ward_stat_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/custom_drop_down_menu.dart';
import 'package:afkcredits/ui/widgets/history_tile.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:afkcredits/ui/widgets/trend_icon.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

class SingleWardStatView extends StatefulWidget {
  final String uid;
  const SingleWardStatView({Key? key, required this.uid}) : super(key: key);

  @override
  State<SingleWardStatView> createState() => _SingleWardStatViewState();
}

class _SingleWardStatViewState extends State<SingleWardStatView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleWardStatViewModel>.reactive(
      viewModelBuilder: () => SingleWardStatViewModel(wardUid: widget.uid),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: model.isBusy
                ? "Child stats"
                : model.ward != null
                    ? model.ward!.fullName
                    : "Child Statistics",
            onBackButton: model.popView,
            dropDownButton: CustomDropDownMenu(
              icon1: Icon(Icons.delete_outline_rounded,
                  color: kcMediumGrey, size: 22),
              onTap1: model.removeWardFromGuardianAccount,
              text1: 'Remove child',
              icon2: Icon(Icons.settings, color: kcMediumGrey, size: 22),
              onTap2: model.showWardSettingsDialogDialog,
              text2: 'Settings',
            ),
          ),
          body: RefreshIndicator(
            onRefresh: model.refresh,
            child: model.isBusy
                ? model.removedUser
                    ? Container()
                    : AFKProgressIndicator()
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    verticalSpaceMedium,
                                    SummaryStatsDisplay(
                                      title: "Credits",
                                      icon: Image.asset(kInsideOutLogoPath,
                                          color: kcPrimaryColor, height: 24),
                                      stats: model.stats.creditsBalance
                                          .toStringAsFixed(0),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: IconButton(
                                          padding: const EdgeInsets.only(
                                              top: 4.0,
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 0.0),
                                          visualDensity: VisualDensity.compact,
                                          onPressed: model
                                              .showExplainCreditsConversionDialog,
                                          icon: Icon(Icons.info_outline,
                                              color: kcPrimaryColor, size: 22)),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 30,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalSpaceMedium,
                                    SummaryStatsDisplay(
                                      title: "Screen time",
                                      icon: Image.asset(kScreenTimeIcon,
                                          height: 24, color: kcScreenTimeBlue),
                                      unit: "min",
                                      stats: model.stats.creditsBalance
                                          .toStringAsFixed(0),
                                    ),
                                  ],
                                ),
                                Spacer(),
                              ],
                            ),
                            verticalSpaceSmall,
                            childButtons(context, model),
                            verticalSpaceSmall,
                            verticalSpaceTiny,
                            SectionHeader(
                              title: "Last 7 days",
                              horizontalPadding: 0,
                              //onButtonTap: model.showNotImplementedSnackbar,
                              otherTrailingIcon: IconButton(
                                icon: Icon(Icons.more_vert,
                                    size: 24, color: kcGreyTextColor),
                                onPressed: model.showWardStatDetailsDialog,
                                //color: Colors.red,
                              ),
                            ),
                            //    TextButton(
                            //     child: InsideOutText.body(
                            //       "Total Stats",
                            //       color: kcPrimaryColor,
                            //     ),
                            //     onPressed: model.showWardStatDetailsDialog,
                            //   ),
                            // ),
                            verticalSpaceSmall,
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(kActivityIcon,
                                          height: 30,
                                          width: 30,
                                          color: kcActivityIconColor),
                                      horizontalSpaceSmall,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              InsideOutText.statsStyle(model
                                                      .totalWardActivityLastDaysString +
                                                  " min"),
                                              TrendIcon(
                                                  metric: model
                                                      .totalWardActivityTrend),
                                            ],
                                          ),
                                          if (model.totalWardActivityTrend !=
                                              null)
                                            InsideOutText.caption(
                                                ((model.totalWardActivityTrend ??
                                                                0) >=
                                                            0
                                                        ? "+"
                                                        : "") +
                                                    model.totalWardActivityTrend
                                                        .toString() +
                                                    " min"),
                                          if (model.totalWardActivityTrend !=
                                              null)
                                            InsideOutText.caption(
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
                                          height: 28,
                                          width: 28,
                                          color: kcScreenTimeBlue),
                                      horizontalSpaceSmall,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              InsideOutText.statsStyle(model
                                                      .totalWardScreenTimeLastDaysString +
                                                  " min"),
                                              TrendIcon(
                                                  metric: model
                                                      .totalWardScreenTimeTrend,
                                                  screenTime: true),
                                            ],
                                          ),
                                          if (model.totalWardScreenTimeTrend !=
                                              null)
                                            InsideOutText.caption(
                                                ((model.totalWardScreenTimeTrend ??
                                                                0) >=
                                                            0
                                                        ? "+"
                                                        : "") +
                                                    model
                                                        .totalWardScreenTimeTrend
                                                        .toString() +
                                                    " min"),
                                          if (model.totalWardScreenTimeTrend !=
                                              null)
                                            InsideOutText.caption(
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
                                title: "Recent activities",
                                horizontalPadding: 0,
                              ),
                            if (model.sortedHistory.length > 0)
                              verticalSpaceSmall,
                            if (model.sortedHistory.length > 0)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: kcMediumGrey.withOpacity(0.1)),
                                      color: kcCultured,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount:
                                        model.sortedHistory.length.clamp(0, 8),
                                    itemBuilder: (context, index) {
                                      final data = model.sortedHistory[index];
                                      if (data is ScreenTimeSession &&
                                          data.status ==
                                              ScreenTimeSessionStatus.active) {
                                        return SizedBox(height: 0, width: 0);
                                      } else {
                                        return Column(
                                          children: [
                                            HistoryTile(
                                              showName: false,
                                              showCredits: true,
                                              data: data,
                                              name: data is ActivatedQuest
                                                  ? model.wardNameFromUid(
                                                      data.uids![0])
                                                  : data is TransferDetails
                                                      ? model.wardNameFromUid(
                                                          data.recipientId)
                                                      : model.wardNameFromUid(
                                                          data.uid),
                                              onTap: () => model
                                                  .showHistoryItemInfoDialog(
                                                      data),
                                            ),
                                            if (index <
                                                model.sortedHistory.length - 1)
                                              Divider(),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      verticalSpaceLarge,
                      if (model.sortedHistory.length == 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding),
                          child: InsideOutText.headingTwoLight(
                              "No activities found",
                              align: TextAlign.center),
                        ),
                      if (model.sortedHistory.length == 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding * 2, vertical: 4),
                          child: InsideOutText.body(
                              "Switch account and let " +
                                  model.ward!.fullName +
                                  " earn credits",
                              align: TextAlign.center),
                        ),
                      verticalSpaceMassive,
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // WARNING: Same is in guardian home view
  Widget childButtons(BuildContext context, SingleWardStatViewModel model) {
    return Container(
      height: 96,
      width: screenWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: model.getScreenTimeSession(uid: widget.uid) != null
                ? InsideOutButtonVertical.outline(
                    leading: Icon(Icons.hourglass_top_rounded, color: kcRed),
                    title: "Active Timer",
                    height: 100,
                    onTap: () => model.navigateToSelectScreenTimeGuardianView(
                        wardId: widget.uid),
                    color: kcRed)
                : InsideOutButtonVertical(
                    color: kcBlue.withOpacity(0.9),
                    leading: Icon(Icons.hourglass_top_rounded,
                        color: Colors.grey[100], size: 26),
                    title: "Timer",
                    onTap: model.navigateToSelectScreenTimeGuardianView,
                    height: 100),
          ),
          horizontalSpaceSmall,
          Expanded(
            child: InsideOutButtonVertical(
              color: kcBlue.withOpacity(0.9),
              title: "Switch",
              leading: Image.asset(kSwitchAccountIcon,
                  height: 22, color: Colors.grey[100]),
              onTap: model.handleSwitchToWardEvent,
              height: 100,
            ),
          ),
          horizontalSpaceSmall,
          Expanded(
            child: InsideOutButtonVertical(
              color: kcBlue.withOpacity(0.9),
              title: "Reward",
              leading: Image.asset(kInsideOutLogoSmallPath,
                  height: 24, color: Colors.grey[100]),
              onTap: model.navigateToAddFundsView,
              height: 100,
            ),
          ),
          //verticalSpaceSmall,
        ],
      ),
    );
  }
}
