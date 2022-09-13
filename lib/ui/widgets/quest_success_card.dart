import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class QuestSuccessCard extends StatelessWidget {
  final void Function() onContinuePressed;
  const QuestSuccessCard({
    Key? key,
    required this.onContinuePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: kcGreenWhiter,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.3,
            spreadRadius: 0.4,
            offset: Offset(1, 1),
            color: kcShadowColor,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "You mastered this mission!", // "You are the best, you successfully finished the quest",
              textAlign: TextAlign.center,
              style: textTheme(context).headline5),
          verticalSpaceMedium,
          ElevatedButton(
            onPressed: onContinuePressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Continue",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
