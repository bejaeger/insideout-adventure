import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class SummaryStatsDisplay extends StatelessWidget {
  final String? title;
  final String stats;
  final String? unit;
  final Widget? icon;
  const SummaryStatsDisplay({
    Key? key,
    this.title,
    required this.stats,
    this.unit,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (icon != null) icon!,
            if (icon != null) SizedBox(width: 2),
            AfkCreditsText.statsStyleBlack(stats),
            if (unit != null) SizedBox(width: 2),
            if (unit != null)
              AfkCreditsText.caption(
                unit!,
              )
          ],
        ),
        if (title != null) SizedBox(height: 2),
        if (title != null) AfkCreditsText.caption(title!),
      ],
    );
  }
}
