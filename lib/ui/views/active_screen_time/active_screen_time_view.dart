import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/switch_to_parents_overlay.dart';
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
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          if (model.justStartedScreenTime) {
            model.replaceWithHomeView();
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            body: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 40, bottom: 40),
                child: model.isBusy
                    ? AFKProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Display the following when screen time is still active!
                          if (model.currentScreenTimeSession?.status ==
                              ScreenTimeSessionStatus.active)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AfkCreditsText.headingOne(""),
                                    AfkCreditsText.headingTwo(
                                        "Active Screen Time"),
                                    GestureDetector(
                                      onTap: () {
                                        if (model.justStartedScreenTime) {
                                          model.replaceWithHomeView();
                                          return;
                                        }
                                        model.popView();
                                      },
                                      child: Icon(Icons.keyboard_arrow_down,
                                          size: 30),
                                    )
                                  ],
                                ),
                                AfkCreditsText.body(model.childName == ""
                                    ? model.currentUser.role == UserRole.sponsor
                                        ? ""
                                        : "You are using screen time"
                                    : model.childName +
                                        " is using screen time"),
                                verticalSpaceLarge,
                                // if (model.currentUser.createdByUserWithId !=
                                //     null)
                                //   SwitchToParentsAreaButton(
                                //     onTap: model.showNotImplementedSnackbar,
                                //     show: !(model.isShowingQuestDetails ||
                                //             model.hasActiveQuest) ||
                                //         model.isFadingOutQuestDetails,
                                //   ),
                                verticalSpaceMedium,
                                AfkCreditsText.subheading(
                                  "Time left",
                                ),
                                verticalSpaceTiny,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Lottie.network(
                                    //     'https://assets8.lottiefiles.com/packages/lf20_wTfKKa.json',
                                    //     height: 45),
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
                          // Display the following when screen time is over!
                          if (model.currentScreenTimeSession?.status ==
                              ScreenTimeSessionStatus.completed)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: AfkCreditsText.headingOne(
                                        "Screen Time Over")),
                                AfkCreditsText.body(model.childName +
                                    " used all requested screen time"),
                                verticalSpaceMassive,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SimpleStatisticsDisplay(
                                      statistic: model.currentScreenTimeSession!
                                          .afkCreditsUsed
                                          .toString(),
                                      title: "Credits",
                                      showCreditsIcon: true,
                                    ),
                                    SimpleStatisticsDisplay(
                                        statistic: secondsToMinuteSecondTime(
                                            model.currentScreenTimeSession!
                                                    .minutesUsed! *
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
                          Lottie.network(
                              'https://assets8.lottiefiles.com/packages/lf20_l3jzffol.json',
                              height: 200),
                          Spacer(),
                          MainLongButton(
                              onTap: model.currentScreenTimeSession?.status ==
                                      ScreenTimeSessionStatus.completed
                                  ? model.replaceWithHomeView
                                  : model.stopScreenTime,
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
        ),
      ),
    );
  }
}
