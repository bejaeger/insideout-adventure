
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class LiveQuestStatistic extends StatelessWidget {
  final String title;
  final String statistic;
  const LiveQuestStatistic({
    Key? key,
    required this.title,
    required this.statistic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          statistic,
          style: textTheme(context).bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: kBlackHeadlineColor),
        ),
        verticalSpaceTiny,
        Text(title),
      ],
    );
  }
}
