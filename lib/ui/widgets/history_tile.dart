import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:afkcredits_ui/src/shared/app_colors.dart';
import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final bool screenTime;
  final String name;
  final int? minutes;
  final QuestType? questType;
  final DateTime date;
  final num? credits;
  final bool showCredits;
  final bool showName;
  const HistoryTile(
      {Key? key,
      required this.name,
      required this.date,
      required this.credits,
      this.minutes,
      this.screenTime = true,
      this.questType,
      this.showCredits = false,
      this.showName = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (screenTime) {
      if (minutes == null) {
        throw Exception(
            "If screen time should be displayed in history tile need to provide minute!");
      }
    } else {
      if (questType == null) {
        throw Exception(
            "If activity should be displayed in history tile need to provide questType!");
      }
    }
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //     //color: screenTime ? kcScreenTimeBlueOpaque : kcActivityColorOpaque,
      //     border: Border.all(color: Colors.grey[400]!),
      //     color: Colors.white,
      //     boxShadow: const [
      //       BoxShadow(
      //         color: kcLightGreyColor,
      //         offset: Offset(1, 1),
      //         blurRadius: 0.3,
      //         spreadRadius: 0.1,
      //       )
      //     ],
      //     borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large left side icon
          Container(
            width: 60,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(screenTime ? kScreenTimeIcon : kActivityIcon,
                    height: showName ? 25 : 30,
                    width: showName ? 25 : 30,
                    color: screenTime ? kcScreenTimeBlue : kcActivityIconColor),
                if (showName) SizedBox(height: 1),
                if (showName) AfkCreditsText.captionBold(name),
              ],
            ),
          ),
          // Name and Quest/screen time info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (showName) AfkCreditsText.caption(name),
                // if (showName) SizedBox(height: 3),
                screenTime
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AfkCreditsText.caption("Screen time"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AfkCreditsText.headingFour(minutes.toString()),
                              SizedBox(width: 2),
                              AfkCreditsText.caption("min"),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AfkCreditsText.caption(
                              "Activity: " + getShortQuestType(questType!)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // questType
                              AfkCreditsText.headingFour(
                                  minutes!.round().toString()),
                              SizedBox(width: 1),
                              AfkCreditsText.caption("min"),
                            ],
                          ),
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
              AfkCreditsText.caption(formatDateDetailsType5(date)),
              if (showCredits) SizedBox(height: 3),
              if (showCredits)
                CreditsAmount(
                    amount: credits ?? -1,
                    height: 16,
                    style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
