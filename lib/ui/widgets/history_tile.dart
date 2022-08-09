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
  const HistoryTile(
      {Key? key,
      required this.name,
      required this.date,
      required this.credits,
      this.minutes,
      this.screenTime = true,
      this.questType})
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
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          //color: screenTime ? kcScreenTimeBlueOpaque : kcActivityColorOpaque,
          border: Border.all(color: Colors.grey[400]!),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: kcLightGreyColor,
              offset: Offset(1, 1),
              blurRadius: 0.5,
              spreadRadius: 0.3,
            )
          ],
          borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large left side icon
          Image.asset(screenTime ? kScreenTimeIcon : kActivityIcon,
              height: 35,
              width: 35,
              color: screenTime ? kcScreenTimeBlue : kcActivityColor),
          horizontalSpaceMedium,
          // Name and Quest/screen time info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AfkCreditsText.caption(name),
                SizedBox(height: 3),
                screenTime
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AfkCreditsText.headingFour(minutes.toString()),
                          SizedBox(width: 2),
                          AfkCreditsText.caption("min"),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // questType
                          AfkCreditsText.headingFour(
                              minutes!.round().toString()),
                          SizedBox(width: 1),
                          AfkCreditsText.caption("min"),

                          horizontalSpaceTiny,
                          AfkCreditsText.headingFour("-"),
                          horizontalSpaceTiny,
                          AfkCreditsText.headingFour(
                              getShortQuestType(questType!)),
                        ],
                      )

                // Name and date row
              ],
            ),
          ),
          horizontalSpaceRegular,
          // Date and credits info
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AfkCreditsText.caption(formatDateDetailsType5(date)),
              // SizedBox(height: 3),
              // CreditsAmount(
              //     color: Colors.grey[800]!,
              //     amount: credits ?? -1,
              //     height: 16,
              //     style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
