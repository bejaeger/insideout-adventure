import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/trend_icon.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class ChildStatsCard extends StatelessWidget {
  final UserStatistics? childStats;
  final User user;
  final int? screenTimeLastWeek;
  final int? activityTimeLastWeek;
  final int? screenTimeTrend;
  final int? activityTimeTrend;
  final bool usingScreenTime;

  const ChildStatsCard(
      {Key? key,
      required this.childStats,
      required this.user,
      required this.screenTimeLastWeek,
      required this.activityTimeLastWeek,
      this.usingScreenTime = false,
      this.screenTimeTrend,
      this.activityTimeTrend})
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
                color: usingScreenTime ? kcRed : Colors.grey[400]!,
                width: usingScreenTime ? 2.0 : 1.0),
            borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, left: 15.0, right: 15.0, bottom: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AfkCreditsText.headingFour(user.fullName)),
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
              if (activityTimeLastWeek != null || screenTimeLastWeek != null)
                AfkCreditsText.body("Last 7 days"),
              if (activityTimeLastWeek == null && screenTimeLastWeek == null)
                AfkCreditsText.body("Switch to " +
                    user.fullName +
                    "'s account and let your child earn credits"),
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
                                  activityTimeLastWeek.toString() + " min"),
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
                                    metric: screenTimeTrend!, screenTime: true)
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
              if (usingScreenTime)
                Align(
                    alignment: Alignment.bottomRight,
                    child: AfkCreditsText.warn("Using screen time")),
            ],
          ),
        ),
      ),
    );
  }
}
