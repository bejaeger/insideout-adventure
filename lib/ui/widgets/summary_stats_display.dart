import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class SummaryStatsDisplay extends StatelessWidget {
  final String title;
  final String stats;
  final String? unit;
  final Widget? icon;
  const SummaryStatsDisplay(
      {Key? key,
      required this.title,
      required this.stats,
      this.unit,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null) icon!,
            if (icon != null) SizedBox(width: 2),
            AfkCreditsText.label(stats),
            if (unit != null) SizedBox(width: 2),
            if (unit != null) AfkCreditsText.label(unit!),
          ],
        ),
        AfkCreditsText.caption(title),
      ],
    );
  }
}
