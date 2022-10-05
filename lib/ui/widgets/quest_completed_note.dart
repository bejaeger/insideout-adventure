import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class QuestCompletedNote extends StatelessWidget {
  final void Function() onTap;
  final bool? repeatable;
  const QuestCompletedNote({
    Key? key,
    required this.onTap,
    this.repeatable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kcWhiteTextColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(),
        boxShadow: [
          BoxShadow(
              blurRadius: 2,
              spreadRadius: 0.5,
              offset: Offset(1, 1),
              color: kcShadowColor),
        ],
      ),
      padding: const EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AfkCreditsText.headingFour("Quest already completed"),
          verticalSpaceSmall,
          if (repeatable == true)
            AfkCreditsButton.text(
                title: "Redo quest",
                // color: Colors.white,
                width: 120,
                onTap: onTap),
          if (repeatable == false)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: AfkCreditsText.body("You cannot redo this quest"),
            ),
        ],
      ),
    );
  }
}
