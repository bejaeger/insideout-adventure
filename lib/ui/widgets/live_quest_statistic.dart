import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class LiveQuestStatistic extends StatefulWidget {
  final String title;
  final String statistic;
  const LiveQuestStatistic({
    Key? key,
    required this.title,
    required this.statistic,
  }) : super(key: key);

  @override
  State<LiveQuestStatistic> createState() => _LiveQuestStatisticState();
}

class _LiveQuestStatisticState extends State<LiveQuestStatistic> {
  @override
  Widget build(BuildContext context) {
    // print("--- rebuilding DURATION: ${widget.statistic} -- ");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.statistic,
          style: textTheme(context).bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: kBlackHeadlineColor),
        ),
        verticalSpaceTiny,
        Text(widget.title),
      ],
    );
  }
}
