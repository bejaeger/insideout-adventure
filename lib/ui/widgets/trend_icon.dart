import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class TrendIcon extends StatelessWidget {
  final num? metric;
  final bool screenTime;
  const TrendIcon({Key? key, required this.metric, this.screenTime = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return metric == null
        ? SizedBox(height: 0, width: 0)
        : metric! > 0
            ? Icon(Icons.arrow_upward,
                color: screenTime ? kcRedColor : kcAccentuatedGreen)
            : metric == 0
                ? Icon(Icons.arrow_right, color: Colors.black)
                : Icon(Icons.arrow_downward,
                    color: screenTime ? kcAccentuatedGreen : kcRedColor);
  }
}
