import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: kcPrimaryColorSecondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15.0),
          ),
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
                    color: kcPrimaryColorSecondary.withOpacity(0.9),
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
                            .copyWith(fontSize: 15, color: kcWhiteTextColor),
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
                            .copyWith(color: kcGreyTextColor)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InsideOutIcon(height: 40),
                        Text(quest.creditsEarned.toString(),
                            style: textTheme(context)
                                .headline4!
                                .copyWith(color: kcPrimaryColor)),
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
