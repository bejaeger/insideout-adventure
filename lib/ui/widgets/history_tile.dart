import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class HistoryTile extends StatelessWidget {
  final String name;
  final bool showCredits;
  final bool showName;
  final dynamic data;
  final void Function() onTap;
  const HistoryTile(
      {Key? key,
      required this.name,
      required this.onTap,
      this.showCredits = false,
      this.showName = true,
      this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool screenTime = !(data is ActivatedQuest);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        height: 55,
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large left side icon
            Container(
              width: 60,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!showName) SizedBox(height: 4),
                  Image.asset(screenTime ? kScreenTimeIcon2 : kActivityIcon,
                      height: showName ? 25 : 30,
                      width: showName ? 25 : 30,
                      color:
                          screenTime ? kcScreenTimeBlue : kcActivityIconColor),
                  if (showName) SizedBox(height: 1),
                  if (showName) InsideOutText.captionBold(name),
                ],
              ),
            ),
            // Name and Quest/screen time info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (showName) InsideOutText.caption(name),
                  // if (showName) SizedBox(height: 3),
                  screenTime
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InsideOutText.headingFour(
                                    (data.minutesUsed ?? data.minutes)
                                        .toString()),
                                SizedBox(width: 2),
                                InsideOutText.caption("min"),
                              ],
                            ),
                            InsideOutText.caption("Screen time"),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 5),
                                // questType
                                InsideOutText.headingFour(
                                    ((data.timeElapsed / 60).round())!
                                        .round()
                                        .toString()),
                                SizedBox(width: 1),
                                InsideOutText.caption("min"),
                              ],
                            ),
                            InsideOutText.caption("Activity: " +
                                getShortQuestType(data.quest.type)),
                          ],
                        )

                  // Name and date row
                ],
              ),
            ),
            horizontalSpaceRegular,
            // Date and credits info
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 5),
                if (showCredits) SizedBox(height: 3),
                if (showCredits)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CreditsAmount(
                          amount: screenTime
                              ? data.creditsUsed ?? data.credits
                              : data.creditsEarned,
                          height: 16,
                          style: bodyStyleSofia),
                      SizedBox(width: 3),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: InsideOutText.caption(
                            screenTime ? "Spent" : "Earned"),
                      ),
                    ],
                  ),
                if (showCredits) SizedBox(height: 3),
                InsideOutText.caption(formatDateDetailsType5(screenTime
                    ? data.startedAt.toDate()
                    : data.createdAt.toDate())),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
