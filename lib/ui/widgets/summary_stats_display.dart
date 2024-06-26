import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class SummaryStatsDisplay extends StatelessWidget {
  final String? title;
  final String stats;
  final String? unit;
  final Widget? icon;
  final TextStyle? statsStyle;
  final TextStyle? titleStyle;
  const SummaryStatsDisplay({
    Key? key,
    this.title,
    required this.stats,
    this.unit,
    this.icon,
    this.statsStyle,
    this.titleStyle,
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
            if (icon != null) SizedBox(width: 4),
            InsideOutText(text: stats, style: statsStyle ?? statsStyleBlack),
            if (unit != null) SizedBox(width: 2),
            if (unit != null)
              InsideOutText.caption(
                unit!,
              )
          ],
        ),
        if (title != null) SizedBox(height: 2),
        if (title != null)
          InsideOutText(text: title!, style: titleStyle ?? captionStyle),
      ],
    );
  }
}
