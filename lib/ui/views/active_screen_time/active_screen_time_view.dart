import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/screen_time_notifications_note.dart';
import 'package:afkcredits/ui/widgets/simple_statistics_display.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class ActiveScreenTimeView extends StatelessWidget {
  final ScreenTimeSession session;
  const ActiveScreenTimeView({Key? key, required this.session})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveScreenTimeViewModel>.reactive(
      onModelReady: (model) {
        model.initialize();
      },
      viewModelBuilder: () => ActiveScreenTimeViewModel(session: session),
      builder: (context, model, child) {
        bool showStats = model.expiredScreenTime != null &&
            model.expiredScreenTime?.status ==
                ScreenTimeSessionStatus.completed &&
            model.currentScreenTimeSession?.status !=
                ScreenTimeSessionStatus.active;
        return WillPopScope(
          onWillPop: () async {
            model.resetActiveScreenTimeView(uid: session.uid);
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              body: Container(
                height: screenHeight(context),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 40, bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Display the following when screen time is still active!
                    if (model.currentScreenTimeSession?.status ==
                        ScreenTimeSessionStatus.active)
                      model.isBusy
                          ? AFKProgressIndicator()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    onPressed: () =>
                                        model.resetActiveScreenTimeView(
                                            uid: session.uid),
                                    icon: Icon(Icons.arrow_back_ios, size: 26),
                                  ),
                                ),
                                Column(
                                  children: [
                                    verticalSpaceSmall,
                                    Center(
                                      child: InsideOutText.headingTwo(
                                          !model.isParentAccount
                                              ? "Woop woop, enjoy time on the screen!"
                                              : model.childName +
                                                  " is using screen time",
                                          align: TextAlign.center),
                                    ),
                                    verticalSpaceSmall,
                                    verticalSpaceMedium,
                                    Align(
                                      child: InsideOutText.subheading(
                                        "Time left",
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        horizontalSpaceSmall,
                                        !(model.screenTimeLeft is int)
                                            ? AFKProgressIndicator(
                                                color: kcScreenTimeBlue)
                                            : Text(
                                                secondsToMinuteSecondTime(
                                                    model.screenTimeLeft),
                                                style: heading2Style.copyWith(
                                                    fontSize: 40)),
                                        Column(
                                          children: [
                                            InsideOutText.body(
                                                "  / ${session.minutes} min",
                                                color: kcBlackHeadlineColor),
                                            SizedBox(height: 8),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    // Display the following when screen time is over!
                    if (showStats)
                      model.isBusy
                          ? AFKProgressIndicator()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      model.resetStopWatch();
                                      model.popView();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Icon(Icons.close_rounded, size: 30),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: InsideOutText.headingTwo(
                                      "Screen Time Over"),
                                ),
                                //Spacer(),
                                verticalSpaceLarge,
                                Icon(Icons.timer_off_outlined,
                                    size:
                                        screenHeight(context, percentage: 0.12),
                                    color: kcRed),
                                verticalSpaceLarge,
                                //Spacer(),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: InsideOutText.subheading(
                                      model.childName +
                                          "'s screen time expired",
                                      align: TextAlign.center),
                                ),
                                verticalSpaceMedium,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SimpleStatisticsDisplay(
                                        statistic: formatDateDetailsType6(
                                            model.getStartedAt()),
                                        title: "Started",
                                        showScreenTimeIcon: false),
                                    SimpleStatisticsDisplay(
                                      statistic: formatDateDetailsType6(model
                                          .getStartedAt()
                                          .add(Duration(
                                              minutes: (model.expiredScreenTime!
                                                      .minutesUsed ??
                                                  model.expiredScreenTime!
                                                      .minutes)))),
                                      title: "Expired",
                                      showCreditsIcon: false,
                                    ),
                                  ],
                                ),
                                verticalSpaceMedium,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SimpleStatisticsDisplay(
                                        statistic: secondsToMinuteTime((model
                                                        .expiredScreenTime!
                                                        .minutesUsed ??
                                                    model.expiredScreenTime!
                                                        .minutes) *
                                                60) +
                                            "in",
                                        title: "Total time",
                                        showScreenTimeIcon: true),
                                    SimpleStatisticsDisplay(
                                      statistic: model
                                          .expiredScreenTime!.afkCreditsUsed
                                          .toString()
                                          .split(".")
                                          .first,
                                      title: "Credits spent",
                                      showCreditsIcon: true,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    if (!showStats) Spacer(),
                    if (!showStats)
                      model.isParentAccount
                          ? ScreenTimeNotificationsNote()
                          : Lottie.asset(
                              kLottieBigTv,
                              height: screenHeight(context, percentage: 0.25),
                            ),
                    Spacer(),
                    if (showStats && model.isParentAccount)
                      InsideOutButton.text(
                        title: "See ${model.childName}'s statistics",
                        onTap: () => model.replaceWithSingleChildView(
                            uid: model.childId),
                      ),
                    verticalSpaceSmall,
                    if (!model.currentUserSettings.ownPhone ||
                        model.currentScreenTimeSession?.status !=
                            ScreenTimeSessionStatus.active ||
                        model.isParentAccount)
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: InsideOutButton(
                          color: model.currentScreenTimeSession?.status ==
                                  ScreenTimeSessionStatus.active
                              ? kcRed
                              : kcPrimaryColor,
                          onTap: model.currentScreenTimeSession?.status ==
                                  ScreenTimeSessionStatus.active
                              ? () =>
                                  model.stopScreenTime(session: model.session)
                              : () => model.resetActiveScreenTimeView(
                                  uid: session.uid),
                          title: model.currentScreenTimeSession?.status ==
                                  ScreenTimeSessionStatus.active
                              ? "Stop screen time"
                              : " Back to home",
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
