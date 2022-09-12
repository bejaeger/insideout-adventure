import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
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
            bottom: 20.0,
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
                  child: Icon(getIconForCategory(quest.type!),
                      size: 80,
                      color: getColorOfType(quest.type!).withOpacity(0.25)),
                ),
              ),
              FractionallySizedBox(
                heightFactor: 0.65,
                widthFactor: 0.8,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceTiny,
                      if (quest.distanceFromUser != null)
                        Text(
                            (0.001 * quest.distanceFromUser!)
                                    .toStringAsFixed(1) +
                                " km" +
                                " - " +
                                getStringForCategory(quest.type),
                            style: textTheme(context).bodyText2!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: kcPrimaryColorSecondary,
                                fontSize: 15)),
                      verticalSpaceSmall,
                      Expanded(
                        child: Text(
                          quest.name!,
                          style: textTheme(context).headline6!.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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
                        CreditsAmount(
                          amount: quest.afkCredits,
                          color: kcPrimaryColor,
                          textColor: kcPrimaryColor,
                          height: 20,
                        ),
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
