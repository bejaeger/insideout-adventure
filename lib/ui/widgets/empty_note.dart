import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class EmptyNote extends StatelessWidget {
  final void Function() onMoreButtonPressed;
  final String? title;
  final String? buttonTitle;
  const EmptyNote({
    required this.onMoreButtonPressed,
    this.title,
    Key? key,
    this.buttonTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpaceMassive,
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
              title ?? "You mastered this mission!",// "You are the best, you successfully finished the quest",
              textAlign: TextAlign.center,
              style: textTheme(context).headline3),
        ),
        verticalSpaceMedium,
        ElevatedButton(
            onPressed: onMoreButtonPressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(buttonTitle ?? "More Quests",
                  style: textTheme(context)
                      .headline6!
                      .copyWith(color: kWhiteTextColor)),
            )),
      ],
    );
  }
}
