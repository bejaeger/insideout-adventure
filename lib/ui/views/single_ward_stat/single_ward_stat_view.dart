import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
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
                    ? model.ward!.fullName + '\'s Stats'
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
          floatingActionButton: BottomFloatingActionButtons(
              // titleMain: "Add Credits",
              // onTapMain: model.navigateToAddFundsView,
              leadingMain: Image.asset(kSwitchAccountIcon,
                  height: 22, color: Colors.white),
              titleMain: "Switch area",
              onTapMain: model.handleSwitchToWardEvent),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
                                    verticalSpaceTiny,
                                    Container(
                                      width: 120,
                                      child: InsideOutButton(
                                        leading: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        title: "Reward",
                                        onTap: model.navigateToAddFundsView,
                                      ),
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
                                              .showExplainCreditConversionDialog,
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
                                          height: 26, color: kcScreenTimeBlue),
                                      unit: "min",
                                      stats: model.stats.creditsBalance
                                          .toStringAsFixed(0),
                                    ),
                                    verticalSpaceTiny,
                                    Container(
                                      width: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          model.getScreenTimeSession(
                                                      uid: widget.uid) !=
                                                  null
                                              ? InsideOutButton.outline(
                                                  leading: Icon(
                                                      Icons
                                                          .hourglass_top_rounded,
                                                      color: kcScreenTimeBlue),
                                                  title: "Show",
                                                  onTap: () => model
                                                      .navigateToSelectScreenTimeGuardianView(
                                                          wardId: widget.uid),
                                                  color: kcScreenTimeBlue)
                                              : InsideOutButton.outline(
                                                  leading: Icon(
                                                      Icons.play_arrow_rounded,
                                                      color: kcPrimaryColor),
                                                  title: "Set timer",
                                                  onTap: () =>
                                                      model.navigateToSelectScreenTimeGuardianView(
                                                          wardId: widget.uid),
                                                  color: null),
                                          if (model.getScreenTimeSession(
                                                  uid: widget.uid) !=
                                              null)
                                            InsideOutText.screenTimeWarn(
                                                "Screen time active"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                              ],
                            ),
                            verticalSpaceMedium,
                            SectionHeader(
                              title: "Last 7 days",
                              horizontalPadding: 0,
                              //onButtonTap: model.showNotImplementedSnackbar,
                              otherTrailingIcon: TextButton(
                                child: InsideOutText.body(
                                  "Total Stats",
                                  color: kcPrimaryColor,
                                ),
                                onPressed: model.showWardStatDetailsDialog,
                              ),
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
                                    itemCount:
                                        model.sortedHistory.length.clamp(0, 5),
                                    itemBuilder: (context, index) {
                                      final data = model.sortedHistory[index];
                                      return Column(
                                        children: [
                                          HistoryTile(
                                            showName: false,
                                            showCredits: true,
                                            data: data,
                                            name: data is ActivatedQuest
                                                ? model.wardNameFromUid(
                                                    data.uids![0])
                                                : model
                                                    .wardNameFromUid(data.uid),
                                            onTap: () =>
                                                model.showHistoryItemInfoDialog(
                                                    data),
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
                          child: InsideOutText.headingTwoLight(
                              "Switch account and let " +
                                  model.ward!.fullName +
                                  " earn credits",
                              align: TextAlign.center),
                        ),
                      if (model.stats.lifetimeEarnings == 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Icon(Icons.arrow_downward_rounded,
                              size: 40, color: kcPrimaryColor),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
