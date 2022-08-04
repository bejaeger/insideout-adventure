import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class ChildStatsCard extends StatelessWidget {
  final Map<String, UserStatistics>? childrenStats;
  final User user;
  const ChildStatsCard(
      {Key? key, required this.childrenStats, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserStatistics? stats;
    if (childrenStats != null) {
      stats = childrenStats![user.uid];
    }
    return Card(
      elevation: 2,
      color: kNiceBeige,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: screenWidth(context, percentage: 0.45),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AfkCreditsText.headingFour(user.fullName),
              if (stats != null)
                CreditsAmount(amount: stats.afkCreditsBalance, height: 18),
              verticalSpaceSmall,
              stats == null
                  ? AFKProgressIndicator()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AfkCreditsText.body("# quests compl.: " +
                            stats.numberQuestsCompleted.toString()),
                        AfkCreditsText.body(
                            "screen time: " + stats.afkCreditsSpent.toString()),
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
