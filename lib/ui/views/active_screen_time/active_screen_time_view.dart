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
  final ScreenTimeSession? session;
  final String? screenTimeSessionId;
  const ActiveScreenTimeView(
      {Key? key, required this.session, this.screenTimeSessionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveScreenTimeViewModel>.reactive(
      onModelReady: (model) {
        model.initialize();
      },
      viewModelBuilder: () => ActiveScreenTimeViewModel(
          session: session, screenTimeSessionId: screenTimeSessionId),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            model.resetStopWatch();
            if (model.justStartedListeningToScreenTime) {
              model.replaceWithHomeView();
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
                    // Display the following when screen time is still active!
                    if (model.currentScreenTimeSession?.status ==
                        ScreenTimeSessionStatus.active)
                      model.isBusy
                          ? AFKProgressIndicator()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    model.resetStopWatch();
                                    if (model
                                        .justStartedListeningToScreenTime) {
                                      model.replaceWithHomeView();
                                      return;
                                    }
                                    model.popView();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.close_rounded, size: 30),
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
                                            : model.screenTimeLeft! > 0
                                                ? AfkCreditsText.headingTwo(
                                                    secondsToMinuteSecondTime(
                                                        model.screenTimeLeft),
                                                  )
                                                : SizedBox(height: 0, width: 0)
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    // Display the following when screen time is over!
                    if (model.currentScreenTimeSession?.status ==
                        ScreenTimeSessionStatus.completed)
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
                                  if (model.justStartedListeningToScreenTime) {
                                    model.replaceWithHomeView();
                                    return;
                                  }
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
                                    .currentScreenTimeSession!.afkCreditsUsed
                                    .toString(),
                                title: "Credits used",
                                showCreditsIcon: true,
                              ),
                              SimpleStatisticsDisplay(
                                  statistic: secondsToMinuteSecondTime((model
                                              .currentScreenTimeSession!
                                              .minutesUsed ??
                                          model.currentScreenTimeSession!
                                              .minutes) *
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
                    Lottie.asset(kLottieBigTv, height: 200),
                    Spacer(),
                    MainLongButton(
                        onTap: model.currentScreenTimeSession?.status ==
                                ScreenTimeSessionStatus.completed
                            ? model.replaceWithHomeView
                            : () =>
                                model.stopScreenTime(session: model.session),
                        title: model.currentScreenTimeSession?.status ==
                                ScreenTimeSessionStatus.completed
                            ? "Go Back"
                            : "Stop screen time",
                        color: model.currentScreenTimeSession?.status ==
                                ScreenTimeSessionStatus.completed
                            ? kcPrimaryColor
                            : kcRed),
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
