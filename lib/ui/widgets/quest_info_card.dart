import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/widgets/quest_specifications_row.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class QuestInfoCard extends StatelessWidget {
  final double height;
  final double? width;
  final Quest quest;
  final String? guardianshipSentence;
  final String? subtitle;
  final double? marginRight;
  final double? marginTop;
  final void Function() onCardPressed;

  const QuestInfoCard(
      {Key? key,
      required this.height,
      required this.quest,
      this.subtitle,
      required this.onCardPressed,
      this.guardianshipSentence,
      this.width,
      this.marginRight,
      this.marginTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardPressed,
      child: Card(
        margin: EdgeInsets.only(
            bottom: 25.0,
            left: kHorizontalPadding,
            right: marginRight ?? 0,
            top: marginTop ?? 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        child: Container(
          height: height,
          width: width,
          color: getColorOfType(quest.type).withOpacity(0.05),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 30),
                  child: Icon(getIconForCategory(quest.type),
                      size: 80,
                      color: getColorOfType(quest.type).withOpacity(0.25)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                      child: InsideOutText(
                          text:
                              "${(0.001 * quest.distanceFromUser!).toStringAsFixed(1)} km away",
                          style: bodyStyleSofia.copyWith(
                              fontSize: 14.0,
                              color: kcGreyTextColorSoft,
                              fontWeight: FontWeight.w600)),
                    ),
                    verticalSpaceSmall,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(kInsideOutLogoPath,
                              height: 22, color: kcPrimaryColor),
                        ),
                        SizedBox(width: 4.0),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(quest.credits.toStringAsFixed(0),
                              style: heading3Style.copyWith(
                                  color: kcPrimaryColor)),
                        ),
                        horizontalSpaceTiny,
                        // InsideOutText.headingFour("-"),
                        horizontalSpaceTiny,
                        Expanded(
                          child: Text(quest.name.toString(),
                              style: heading4Style.copyWith(
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 2),
                        ),
                      ],
                    ),
                    verticalSpaceMedium,
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: QuestSpecificationsRow(
                        quest: quest,
                        textColor: kcGreyTextColorSoft,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: kcPrimaryColorSecondary),
                ),
              ),
              if (guardianshipSentence != null) Text(guardianshipSentence!),
            ],
          ),
        ),
      ),
    );
  }
}
