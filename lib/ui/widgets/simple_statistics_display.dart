import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class SimpleStatisticsDisplay extends StatelessWidget {
  final String? title;
  final String statistic;
  final bool showCreditsSymbol;
  final String? dollarValue;
  const SimpleStatisticsDisplay({
    Key? key,
    this.title,
    required this.statistic,
    this.showCreditsSymbol = false,
    this.dollarValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: showCreditsSymbol
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            if (dollarValue != null)
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("\$ " + dollarValue! + " equals",
                      style: textTheme(context)
                          .headline6!
                          .copyWith(fontSize: 15))),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (showCreditsSymbol)
                  AFKCreditsIcon(height: 40, alignment: Alignment.centerLeft),
                Text(
                  statistic,
                  style: textTheme(context).bodyText2!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: kcBlackHeadlineColor),
                ),
              ],
            ),
          ],
        ),
        verticalSpaceTiny,
        if (title != null) Text(title!),
      ],
    );
  }
}
