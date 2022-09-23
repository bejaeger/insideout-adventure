import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/main_long_button.dart';
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
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 40, bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (model.currentScreenTimeSession == null &&
                        model.expiredScreenTime == null)
                      AfkCreditsText.subheading(
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
                    if (model.expiredScreenTime != null &&
                        model.currentScreenTimeSession?.status !=
                            ScreenTimeSessionStatus.active)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  model.resetStopWatch();
                                  model.popView();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.close_rounded, size: 30),
                                ),
                              ),
                              Center(
                                child: AfkCreditsText.headingTwo(
                                    "Screen Time Over"),
                              ),
                            ],
                          ),
                          // Align(
                          //     alignment: Alignment.center,
                          //     child: AfkCreditsText.headingOne(
                          //         "Screen Time Over")),
                          AfkCreditsText.body(model.childName +
                              " used all requested screen time"),
                          verticalSpaceMassive,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SimpleStatisticsDisplay(
                                statistic: model
                                    .expiredScreenTime!.afkCreditsUsed
                                    .toString(),
                                title: "Credits used",
                                showCreditsIcon: true,
                              ),
                              SimpleStatisticsDisplay(
                                  statistic: secondsToMinuteSecondTime((model
                                              .expiredScreenTime!.minutesUsed ??
                                          model.expiredScreenTime!.minutes) *
                                      60),
                                  title: "Screen time",
                                  showScreenTimeIcon: true),
                            ],
                          )
                          // AfkCreditsText.subheading("Time used"),
                          // AfkCreditsText.body(secondsToMinuteSecondTime(
                          //     model.currentScreenTimeSession!
                          //             .minutesUsed! *
                          //         60)),
                          // verticalSpaceSmall,
                        ],
                      ),
                    Spacer(),
                    Lottie.asset(kLottieBigTv,
                        height: screenHeight(context, percentage: 0.25)),
                    Spacer(),
                    MainLongButton(
                        onTap: model.currentScreenTimeSession?.status ==
                                ScreenTimeSessionStatus.active
                            ? () => model.stopScreenTime(session: model.session)
                            : model.replaceWithHomeView,
                        title: model.currentScreenTimeSession?.status ==
                                ScreenTimeSessionStatus.active
                            ? "Stop screen time"
                            : "Go Back",
                        color: model.currentScreenTimeSession?.status ==
                                ScreenTimeSessionStatus.active
                            ? kcRed
                            : kcPrimaryColor),
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
