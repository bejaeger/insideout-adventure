import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FinishedQuestCard extends StatelessWidget {
  final ActivatedQuest quest;
  final void Function()? onTap;

  FinishedQuestCard({required this.quest, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        //clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: kDarkTurquoise.withOpacity(0.2),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     kNiceOrange.withOpacity(0.4),
            //     kNiceOrange.withOpacity(0.8),
            //   ],
            // ),
            //border:
            //  Border.all(color: Colors.black.withOpacity(0.1), width: 2.0),
            borderRadius: BorderRadius.circular(15.0),
            //color: kPrimaryColor.withOpacity(0.2),
          ),
          //width: screenWidthPercentage(context, percentage: 0.8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (quest.quest.networkImagePath != null)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.transparent,
                        Colors.orange.withOpacity(0.5)
                      ],
                    ),
                    image: DecorationImage(
                      image: NetworkImage(quest.quest.networkImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16.0)),
                    color: kDarkTurquoise.withOpacity(0.9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 7.0),
                    child: SizedBox(
                      width: screenWidth(context, percentage: 0.8),
                      child: Text(
                        quest.quest.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme(context)
                            .headline6!
                            .copyWith(fontSize: 15, color: kWhiteTextColor),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(describeEnum(quest.quest.type.toString()),
                        style: textTheme(context)
                            .bodyText1!
                            .copyWith(color: kGreyTextColor)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AFKCreditsIcon(height: 40),
                        // Text("Earned Credits: ",
                        //     style: textTheme(context)
                        //         .bodyText1!
                        //         .copyWith(color: kWhiteTextColor)),
                        Text(quest.afkCreditsEarned.toString(),
                            style: textTheme(context)
                                .headline4!
                                .copyWith(color: kPrimaryColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
