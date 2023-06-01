import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/trend_icon.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class WardStatsCard extends StatelessWidget {
  final UserStatistics? wardStats;
  final User user;
  final int? screenTimeLastWeek;
  final int? activityTimeLastWeek;
  final int? screenTimeTrend;
  final int? activityTimeTrend;
  final ScreenTimeSession? screenTimeSession;
  final bool isBusy;

  const WardStatsCard(
      {Key? key,
      required this.wardStats,
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
      color: kcCultured.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: screenWidth(context, percentage: 0.65),
        decoration: BoxDecoration(
            border: Border.all(
                color: screenTimeSession != null
                    ? kcScreenTimeBlue
                    : Colors.grey[400]!,
                width: screenTimeSession != null ? 3.0 : 1.0),
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
                            child: Text(user.fullName,
                                maxLines: 2,
                                style: heading4Style.copyWith(
                                    overflow: TextOverflow.ellipsis))),
                        Icon(Icons.arrow_forward_ios,
                            size: 20, color: kcPrimaryColorSecondary),
                      ],
                    ),
                    Row(
                      children: [
                        //InsideOutText.body("Balance: "),
                        if (wardStats != null)
                          CreditsAmount(
                            amount: wardStats!.creditsBalance,
                            height: 18,
                          ),
                      ],
                    ),
                    verticalSpaceSmall,
                    if (activityTimeLastWeek != null ||
                        screenTimeLastWeek != null)
                      InsideOutText.body("Last 7 days"),
                    if (activityTimeLastWeek == null &&
                        screenTimeLastWeek == null)
                      InsideOutText.body("No recent activities"),
                    // if (activityTimeLastWeek == null &&
                    //     screenTimeLastWeek == null)
                    //   InsideOutText.body("Switch to " +
                    //       user.fullName +
                    //       "'s account to get started"),
                    wardStats == null
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
                                    InsideOutText.body(
                                        activityTimeLastWeek.toString() +
                                            " min"),
                                    if (activityTimeTrend != null)
                                      TrendIcon(metric: activityTimeTrend!)
                                    // InsideOutText.body("(" +
                                    //     (activityTimeTrend! >= 0 ? "+" : "") +
                                    //     activityTimeTrend.toString() +
                                    //     ")"),
                                  ],
                                ),
                              if (screenTimeLastWeek != null)
                                Row(
                                  children: [
                                    Image.asset(kScreenTimeIcon,
                                        height: 18,
                                        width: 18,
                                        color: kcScreenTimeBlue),
                                    SizedBox(width: 4),
                                    InsideOutText.body(
                                        screenTimeLastWeek.toString() + " min"),
                                    if (screenTimeTrend != null)
                                      TrendIcon(
                                          metric: screenTimeTrend!,
                                          screenTime: true)
                                  ],
                                ),
                            ],
                          ),
                    Spacer(),
                    if (screenTimeSession != null)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InsideOutText.screenTimeWarn("Screen time active"),
                            InsideOutText.screenTimeWarn(" "),
                            InsideOutText.screenTimeWarn(secondsToMinuteTime(
                                  getTimeLeftInSeconds(
                                      session: screenTimeSession!),
                                )
                                //) +
                                +
                                "in left"),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

int getTimeLeftInSeconds({required ScreenTimeSession session}) {
  DateTime now = DateTime.now();
  int diff = now.difference(session.startedAt.toDate()).inSeconds;
  int timeLeft = session.minutes * 60 - diff;
  return timeLeft;
}
