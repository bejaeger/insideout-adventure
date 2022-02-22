import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class SimpleStatisticsDisplay extends StatelessWidget {
  final String title;
  final String statistic;
  final bool showCreditsSymbol;
  const SimpleStatisticsDisplay({
    Key? key,
    required this.title,
    required this.statistic,
    this.showCreditsSymbol = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("--- rebuilding DURATION: ${widget.statistic} -- ");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: showCreditsSymbol
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            if (showCreditsSymbol) AFKCreditsIcon(height: 40),
            Text(
              statistic,
              style: textTheme(context).bodyText2!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: kBlackHeadlineColor),
            ),
          ],
        ),
        verticalSpaceTiny,
        Text(title),
      ],
    );
  }
}
