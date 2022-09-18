import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/trend_icon.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class ChildStatsCard extends StatelessWidget {
  final UserStatistics? childStats;
  final User user;
  final int? screenTimeLastWeek;
  final int? activityTimeLastWeek;
  final int? screenTimeTrend;
  final int? activityTimeTrend;
  final ScreenTimeSession? screenTimeSession;
  final bool isBusy;

  const ChildStatsCard(
      {Key? key,
      required this.childStats,
      required this.user,
      required this.screenTimeLastWeek,
      required this.activityTimeLastWeek,
      this.screenTimeSession,
      this.screenTimeTrend,
      this.activityTimeTrend,
      this.isBusy = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      //color: Color.fromARGB(255, 231, 234, 241),
      color: kcCultured.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: screenWidth(context, percentage: 0.65),
        decoration: BoxDecoration(
            border: Border.all(
                color: screenTimeSession != null ? kcRed : Colors.grey[400]!,
                width: screenTimeSession != null ? 2.0 : 1.0),
            borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, left: 15.0, right: 15.0, bottom: 5.0),
          child: isBusy
              ? AFKProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: AfkCreditsText.headingFour(user.fullName)),
                        Icon(Icons.arrow_forward_ios,
                            size: 20, color: kcPrimaryColorSecondary),
                      ],
                    ),
                    Row(
                      children: [
                        //AfkCreditsText.body("Balance: "),
                        if (childStats != null)
                          CreditsAmount(
                            amount: childStats!.afkCreditsBalance,
                            height: 18,
                          ),
                      ],
                    ),
                    verticalSpaceSmall,
                    if (activityTimeLastWeek != null ||
                        screenTimeLastWeek != null)
                      AfkCreditsText.body("Last 7 days"),
                    if (activityTimeLastWeek == null &&
                        screenTimeLastWeek == null)
                      AfkCreditsText.body("Switch to " +
                          user.fullName +
                          "'s account to earn screen time"),
                    childStats == null
                        ? AFKProgressIndicator()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (activityTimeLastWeek != null)
                                Row(
                                  children: [
                                    Image.asset(kActivityIcon,
                                        height: 20,
                                        width: 20,
                                        color: kcActivityIconColor),
                                    SizedBox(width: 4),
                                    AfkCreditsText.body(
                                        activityTimeLastWeek.toString() +
                                            " min"),
                                    if (activityTimeTrend != null)
                                      TrendIcon(metric: activityTimeTrend!)
                                    // AfkCreditsText.body("(" +
                                    //     (activityTimeTrend! >= 0 ? "+" : "") +
                                    //     activityTimeTrend.toString() +
                                    //     ")"),
                                  ],
                                ),
                              if (screenTimeLastWeek != null)
                                Row(
                                  children: [
                                    Image.asset(kScreenTimeIcon2,
                                        height: 18,
                                        width: 18,
                                        color: kcScreenTimeBlue),
                                    SizedBox(width: 4),
                                    AfkCreditsText.body(
                                        screenTimeLastWeek.toString() + " min"),
                                    if (screenTimeTrend != null)
                                      TrendIcon(
                                          metric: screenTimeTrend!,
                                          screenTime: true)
                                  ],
                                ),
                              // AfkCreditsText.body("# quests compl.: " +
                              //     stats.numberQuestsCompleted.toString()),
                              // AfkCreditsText.body(
                              //     "screen time: " + stats.afkCreditsSpent.toString()),
                            ],
                          ),

                    // Flexible(
                    //     //heightFactor: 0.6,
                    //     child: Icon(Icons.trip_origin_sharp,
                    //         size: 50, color: Colors.orange.shade400)),
                    // verticalSpaceSmall,
                    Spacer(),
                    if (screenTimeSession != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AfkCreditsText.warn("Screen time active"),
                          AfkCreditsText.warn("-"),
                          AfkCreditsText.warn(
                            secondsToMinuteTime(
                              getTimeLeftInSeconds(session: screenTimeSession!),
                            ),
                          ),
                          //) +
                          //"in left"),
                        ],
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

// TODO: put somewhere more central
int getTimeLeftInSeconds({required ScreenTimeSession session}) {
  DateTime now = DateTime.now();
  int diff = now.difference(session.startedAt.toDate()).inSeconds;
  int timeLeft = session.minutes * 60 - diff;
  return timeLeft;
}
