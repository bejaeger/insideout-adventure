import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';

class SimpleStatisticsDisplay extends StatelessWidget {
  final String? title;
  final String statistic;
  final bool showCreditsIcon;
  final bool showScreenTimeIcon;

  final String? dollarValue;
  const SimpleStatisticsDisplay({
    Key? key,
    this.title,
    required this.statistic,
    this.showCreditsIcon = false,
    this.dollarValue,
    this.showScreenTimeIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: showCreditsIcon
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                if (showCreditsIcon)
                  AFKCreditsIcon(
                      height: 35,
                      alignment: Alignment.center,
                      color: kcPrimaryColor),
                if (showScreenTimeIcon)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(kScreenTimeIcon2,
                        height: 28,
                        alignment: Alignment.centerLeft,
                        color: kcScreenTimeBlue),
                  ),
                InsideOutText.headingThree(
                  statistic,
                ),
              ],
            ),
          ],
        ),
        verticalSpaceTiny,
        if (title != null) Center(child: Text(title!)),
      ],
    );
  }
}
