import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/simple_statistics_display.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
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
            model.resetStopWatch();
            if (model.justStartedListeningToScreenTime) {
              // this is needed so that new state listeners are being started
              // in home views!
              model.cancelOnlyActiveScreenTimeSubjectListeners(
                  uid: session.uid);
              model.clearStackAndNavigateToHomeView();
              return false;
            }
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
                    if (model.currentScreenTimeSession == null &&
                        model.expiredScreenTime == null)
                      model.isBusy
                          ? AFKProgressIndicator()
                          : AfkCreditsText.subheading(
                              "Error: Sorry something went wrong when starting the screen time session. Please let the developers know via our feedback option, thank you!"),
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
                                  child: GestureDetector(
                                    onTap: () {
                                      model.resetStopWatch();
                                      if (model
                                          .justStartedListeningToScreenTime) {
                                        // this is needed so that new state listeners are being started
                                        // in home views!
                                        model
                                            .cancelOnlyActiveScreenTimeSubjectListeners(
                                                uid: session.uid);
                                        model.clearStackAndNavigateToHomeView();
                                        return;
                                      }
                                      model.popView();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Icon(Icons.close_rounded, size: 30),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Center(
                                      child: AfkCreditsText.headingTwo(
                                          "Active screen time"),
                                    ),
                                    verticalSpaceMedium,
                                    Center(
                                      child: AfkCreditsText.subheadingItalic(
                                          !model.isParentAccount
                                              ? "Woop woop, enjoy time on the screen!"
                                              : model.childName +
                                                  " is using screen time",
                                          align: TextAlign.center),
                                    ),
                                    verticalSpaceSmall,
                                    // if (model.currentUser.createdByUserWithId !=
                                    //     null)
                                    //   SwitchToParentsAreaButton(
                                    //     onTap: model.showNotImplementedSnackbar,
                                    //     show: !(model.isShowingQuestDetails ||
                                    //             model.hasActiveQuest) ||
                                    //         model.isFadingOutQuestDetails,
                                    //   ),
                                    verticalSpaceMedium,
                                    Align(
                                      child: AfkCreditsText.subheading(
                                        "Time left",
                                        //align: TextAlign.center,
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(kScreenTimeIcon,
                                            width: 35, color: kcScreenTimeBlue),
                                        horizontalSpaceSmall,
                                        !(model.screenTimeLeft is int)
                                            ? AFKProgressIndicator(
                                                color: kcScreenTimeBlue)
                                            : AfkCreditsText.headingTwo(
                                                secondsToMinuteSecondTime(
                                                    model.screenTimeLeft),
                                              )
                                        // : SizedBox(height: 0, width: 0)
                                      ],
                                    ),
                                    verticalSpaceSmall,
                                    AfkCreditsText.body("Total length"),
                                    verticalSpaceTiny,
                                    AfkCreditsText.bodyBold(
                                        "${session.minutes} min",
                                        color: kcBlackHeadlineColor),
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
                                  child: AfkCreditsText.headingTwo(
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
                                  child: AfkCreditsText.subheading(
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
                                        statistic: formatDateDetailsType6(model
                                            .expiredScreenTime!.startedAt
                                            .toDate()),
                                        title: "Started",
                                        showScreenTimeIcon: false),
                                    SimpleStatisticsDisplay(
                                      statistic: formatDateDetailsType6(model
                                          .expiredScreenTime!.startedAt
                                          .toDate()
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
                      Lottie.asset(
                        kLottieBigTv,
                        height: screenHeight(context, percentage: 0.25),
                      ),
                    Spacer(),
                    if (showStats && model.isParentAccount)
                      AfkCreditsButton.text(
                        title: "See ${model.childName}'s statistics",
                        onTap: () => model.replaceWithSingleChildView(
                            uid: model.childId),
                      ),
                    verticalSpaceSmall,
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: AfkCreditsButton(
                        color: model.currentScreenTimeSession?.status ==
                                ScreenTimeSessionStatus.active
                            ? kcRed
                            : kcPrimaryColor,
                        onTap: model.currentScreenTimeSession?.status ==
                                ScreenTimeSessionStatus.active
                            ? () => model.stopScreenTime(session: model.session)
                            : model.replaceWithHomeView,
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
