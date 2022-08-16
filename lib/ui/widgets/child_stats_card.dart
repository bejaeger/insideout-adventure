import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/trend_icon.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class ChildStatsCard extends StatelessWidget {
  final Map<String, UserStatistics>? childrenStats;
  final User user;
  final int? screenTimeLastWeek;
  final int? activityTimeLastWeek;
  final int? screenTimeTrend;
  final int? activityTimeTrend;

  const ChildStatsCard(
      {Key? key,
      required this.childrenStats,
      required this.user,
      required this.screenTimeLastWeek,
      required this.activityTimeLastWeek,
      this.screenTimeTrend,
      this.activityTimeTrend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserStatistics? stats;
    if (childrenStats != null) {
      stats = childrenStats![user.uid];
    }
    return Card(
      elevation: 0,
      //color: Color.fromARGB(255, 231, 234, 241),
      color: kcCultured.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: screenWidth(context, percentage: 0.8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                  if (stats != null)
                    CreditsAmount(
                      amount: stats.afkCreditsBalance,
                      height: 18,
                    ),
                ],
              ),
              verticalSpaceSmall,
              if (activityTimeLastWeek != null || screenTimeLastWeek != null)
                AfkCreditsText.body("Stats last 7 days"),
              if (activityTimeLastWeek == null && screenTimeLastWeek == null)
                AfkCreditsText.body("Switch to " +
                    user.fullName +
                    "'s account and let your child earn credits"),
              stats == null
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
                              Image.asset(kScreenTimeIcon,
                                  height: 20,
                                  width: 20,
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
              verticalSpaceSmall,

              // Flexible(
              //     //heightFactor: 0.6,
              //     child: Icon(Icons.trip_origin_sharp,
              //         size: 50, color: Colors.orange.shade400)),
              // verticalSpaceSmall,
            ],
          ),
        ),
      ),
    );
  }
}
