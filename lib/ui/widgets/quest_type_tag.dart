import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class QuestTypeTag extends StatelessWidget {
  const QuestTypeTag({
    Key? key,
    required this.quest,
  }) : super(key: key);

  final Quest? quest;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: getColorOfType(quest?.type)),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(getIconForCategory(quest?.type),
              color: getColorOfType(quest?.type), size: 18),
          horizontalSpaceTiny,
          InsideOutText.tag(getShortQuestType(quest?.type),
              color: getColorOfType(quest?.type)),
        ],
      ),
    );
  }
}
