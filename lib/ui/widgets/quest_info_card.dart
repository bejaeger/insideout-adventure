import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuestInfoCard extends StatelessWidget {
  final double height;
  final Quest quest;
  final String? sponsoringSentence;
  final String? subtitle;
  final double? userDistanceInMeter;
  final void Function() onCardPressed;

  const QuestInfoCard(
      {Key? key,
      required this.height,
      required this.quest,
      this.subtitle,
      required this.onCardPressed,
      this.sponsoringSentence,
      this.userDistanceInMeter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardPressed,
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: kHorizontalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quest.name, style: textTheme(context).headline6),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: textTheme(context)
                            .bodyText2!
                            .copyWith(fontSize: 18)),
                  Text("Credits to earns: " + quest.afkCredits.toString()),
                  Text("Type: " + describeEnum(quest.type).toString()),
                  AnimatedOpacity(
                    opacity: userDistanceInMeter == null ? 0 : 1,
                    duration: Duration(milliseconds: 500),
                    child: Text(userDistanceInMeter == null
                        ? "Distance: Unkown"
                        : "Distance: " +
                            (0.001 * userDistanceInMeter!).toStringAsFixed(1) +
                            " km"),
                  ),
                  // if (quest.type == QuestType.VibrationSearch)
                  //   ElevatedButton(
                  //     onPressed: onCardPressed,
                  //     child: Text(
                  //       "Start Quest",
                  //     ),
                  //   ),
                  if (sponsoringSentence != null) Text(sponsoringSentence!),
                ],
              )),
        ),
      ),
    );
  }
}
