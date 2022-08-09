import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
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
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(20.0)),
        width: screenWidth(context, percentage: 0.45),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AfkCreditsText.headingLight(user.fullName),
              verticalSpaceSmall,
              AfkCreditsText.body("Last Week:"),
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
                                  color: kcActivityColor),
                              SizedBox(width: 4),
                              AfkCreditsText.body(
                                  activityTimeLastWeek.toString() + " min"),
                              if (activityTimeTrend != null)
                                AfkCreditsText.body("(" +
                                    (activityTimeTrend! >= 0 ? "+" : "") +
                                    activityTimeTrend.toString() +
                                    ")"),
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
                                AfkCreditsText.body("(" +
                                    (screenTimeTrend! >= 0 ? "+" : "") +
                                    screenTimeTrend.toString() +
                                    ")"),
                            ],
                          ),

                        // AfkCreditsText.body("# quests compl.: " +
                        //     stats.numberQuestsCompleted.toString()),
                        // AfkCreditsText.body(
                        //     "screen time: " + stats.afkCreditsSpent.toString()),
                      ],
                    ),
              verticalSpaceSmall,
              Row(
                children: [
                  AfkCreditsText.body("Balance: "),
                  if (stats != null)
                    CreditsAmount(
                        amount: stats.afkCreditsBalance,
                        height: 18,
                        color: Colors.grey[800]!),
                ],
              ),
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
