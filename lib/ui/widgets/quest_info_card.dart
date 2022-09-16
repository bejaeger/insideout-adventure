import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits/ui/widgets/quest_specifications_row.dart';
import 'package:afkcredits/ui/widgets/quest_type_tag.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class QuestInfoCard extends StatelessWidget {
  final double height;
  final double? width;
  final Quest quest;
  final String? sponsoringSentence;
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
      this.sponsoringSentence,
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
        elevation: 1,
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QuestTypeTag(quest: quest),
                      ],
                    ),
                    verticalSpaceSmall,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 4),
                        Image.asset(kAFKCreditsLogoPath,
                            height: 24, color: kcPrimaryColor),
                        SizedBox(width: 4.0),
                        AfkCreditsText.headingThree(
                          quest.afkCredits.toStringAsFixed(0),
                        ),
                        horizontalSpaceTiny,
                        AfkCreditsText.headingFourLight("-"),
                        horizontalSpaceTiny,
                        Expanded(
                          child: Text(quest.name.toString(),
                              style: heading4LightStyle.copyWith(
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 2),
                        ),
                      ],
                    ),
                    // verticalSpaceTiny,
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 4.0),
                    //   child: AfkCreditsText.body(
                    //       "${(0.001 * quest.distanceFromUser!).toStringAsFixed(1)} km away"),
                    // ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.25,
                  child: Container(
                    // height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 0.5,
                            color: kcShadowColor,
                            offset: Offset(1, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // CreditsAmount(
                        //   amount: quest.afkCredits,
                        //   color: kcPrimaryColor,
                        //   textColor: kcPrimaryColor,
                        //   height: 20,
                        // ),
                        QuestSpecificationsRow(quest: quest),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: kcPrimaryColorSecondary)
                      ],
                    ),
                  ),
                ),
              ),
              if (sponsoringSentence != null) Text(sponsoringSentence!),
            ],
          ),
        ),
      ),
    );
  }
}
