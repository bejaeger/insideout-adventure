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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AfkCreditsText.headingTwo(widget.statistic),
        verticalSpaceTiny,
        AfkCreditsText.caption(widget.title),
      ],
    );
  }
}
